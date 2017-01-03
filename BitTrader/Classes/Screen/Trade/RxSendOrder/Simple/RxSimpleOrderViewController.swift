//
//  RxSimpleOrderViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class RxSimpleOrderViewController: RxBaseSendOrderViewController, ViewContainer, ApiExecuterDelegate {
    
    private let disposeBag = DisposeBag()
    
    fileprivate let viewModel = RxSimpleOrderViewModel(condition: .market)
    
    fileprivate var activeViewController: RxBaseSendOrderCommonViewController?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindLifeCycle()
        bindPicker()
        bindOrderButton()
    }

    override func updateBidPrice(price: String) {
        activeViewController?.updateBidPrice(price: price)
    }

    override func updateAskPrice(price: String) {
        activeViewController?.updateAskPrice(price: price)
    }

    func success<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        showAlert(message: "complete")
    }

    func failure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError) {
        showAlert(message: error.message)
    }

//    @IBAction func onSendOrderButton(_ sender: UIButton) {
//        guard let activeViewController = activeViewController else {
//            return
//        }
//
//        let sendOrderModel: RxSendOrderModel
//        do {
//            sendOrderModel = try activeViewController.sendOrderViewModel()
//        } catch (let error) {
//            guard let error = error as? BitTraderError else {
//                showAlert(message: "Invalid Input value")
//                return
//            }
//            showAlert(message: error.message)
//            return
//        }
//
//        /*
//        showConfirmAlert(message: makeErrorMessage(sendOrderModel),
//                         cancelHandler: nil,
//                         agreeHandler: { [weak self] _ in self?.sendChildOrder(sendOrderModel) })
// */
//    }

    /*
    private func sendChildOrder(_ viewModel: RxSendOrderModel) {
        let requestParameter: BitflyerSendChildOrderRequestParameter!
        do {
            requestParameter = try makeChildOrderParameter(model: viewModel)
        } catch (let error) {
            guard let error = error as? BitTraderError else {
                showAlert(message: "Invalid Input value")
                return
            }
            showAlert(message: error.message)
            return
        }
        let request = BitflyerSendChildOrderRequest(requestParameter: requestParameter)

        let apiExecuter = ApiKitApiExecuter<BitflyerSendChildOrderRequest, BitflyerSendChildOrderResponse>(request)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }

    private func sendParentOrder(_ viewModel: RxSendOrderModel) {
        let sendOrderModel = convert(viewModel)
        let requestParameter = makeParentOrderParameter(orderMethodType: .simple, parameters: [sendOrderModel])
        let request = BitflyerSendParentOrderRequest(requestParameter: requestParameter)

        let apiExecuter = ApiKitApiExecuter<BitflyerSendParentOrderRequest, BitflyerSendParentOrderResponse>(request)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }
*/
    private func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "close", style: .default) { action in
            guard let handler = handler else {
                return
            }
            handler(action)
        }
        alertController.addAction(action)
        rootViewController()?.present(alertController, animated: true, completion: nil)
    }

    private func showConfirmAlert(message: String,
                                  cancelHandler: ((UIAlertAction) -> Void)? = nil,
                                  agreeHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { action in
            guard let cancelHandler = cancelHandler else {
                return
            }
            cancelHandler(action)
        }
        let agreeAction = UIAlertAction(title: "OK", style: .default) { action in
            guard let agreeHandler = agreeHandler else {
                return
            }
            agreeHandler(action)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(agreeAction)
        //rootViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    private func bindLifeCycle() {
    }
    
    private func bindPicker() {
        
        // 注文種別変更
        viewModel.selectedCondition
            .asDriver()
            .drive(onNext: { [weak self] condition in
                
                guard let sSelf = self else {
                    return
                }
                
                sSelf.pickerView.selectRow(Enums.Condition.values.index(of: condition) ?? 0, inComponent: 0, animated: false)
                
                if let controller = sSelf.makeSimpleOrderChildViewController(condition: condition) {
                    
                    if let active = sSelf.activeViewController {
                        sSelf.removeChildContainerViewController(active)
                    }
                    sSelf.activeViewController = controller
                    sSelf.addChildContainerViewController(controller, atContainerView: sSelf.containerView)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func bindOrderButton() {
        
        self.sendOrderButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                do {
                    try self?.activeViewController?.executeOrder(
                        success: { [weak self] in
                            self?.showAlert(message: "complate")
                        },
                        failure: { [weak self] errorMessage in
                            self?.showAlert(message: errorMessage)
                    })
                } catch (let error) {
                    guard let error = error as? BitTraderError else {
                        self?.showAlert(message: "Invalid Input value")
                        return
                    }
                    self?.showAlert(message: error.message)
                    return
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func makeSimpleOrderChildViewController(condition: Enums.Condition) -> RxBaseSendOrderCommonViewController? {
        switch condition {
        case .limit:
            return RxLimitOrderViewController(bidAsk: .bid)
        case .market:
            return RxMarketOrderViewController(bidAsk: .bid)
        default:
            return nil
        }
    }
}

extension RxSimpleOrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.tradeTypeComponentCount()
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.tradeTypeCount(numberOfRowsInComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.tradeTypeTitleForRow(row, forComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        viewModel.updateDidSelectedPicker(row: row, inComponent: component)
    }
    
     private func updateCondition(_ condition: Enums.Condition) {
        guard let activeViewController = activeViewController, let newAvc = makeSendOrderChildViewController(condition: condition) else {
            return
        }
        removeChildContainerViewController(activeViewController)
        self.activeViewController = newAvc
        addChildContainerViewController(newAvc, atContainerView: containerView)
    }
}
