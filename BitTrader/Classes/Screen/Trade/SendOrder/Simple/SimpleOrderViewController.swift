//
//  SimpleOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class SimpleOrderViewController: BaseSendOrderViewController, ViewContainer, ApiExecuterDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var activeViewController: BaseSendOrderCommonViewController?
    private var selectedCondition: OldEnums.Condition?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendOrderButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activeViewController = makeSendOrderChildViewController(condition: .limit)
        addChildContainerViewController(activeViewController!, atContainerView: containerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }

    override func updateBidPrice(price: String) {
        activeViewController?.updateBidPrice(price: price)
    }

    override func updateAskPrice(price: String) {
        activeViewController?.updateAskPrice(price: price)
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return OldEnums.Condition.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return OldEnums.Condition(rawValue: row)?.name
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCondition = OldEnums.Condition(rawValue: row)
        guard let selectedCondition = selectedCondition else {
            return
        }
        updateCondition(selectedCondition)
    }

    func success<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        showAlert(message: "complete")
    }

    func failure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError) {
        showAlert(message: error.message)
    }

    @IBAction func onSendOrderButton(_ sender: UIButton) {
        guard let activeViewController = activeViewController else {
            return
        }

        let sendOrderViewModel: SendOrderViewModel
        do {
            sendOrderViewModel = try activeViewController.sendOrderViewModel()
        } catch (let error) {
            guard let error = error as? BitTraderError else {
                showAlert(message: "Invalid Input value")
                return
            }
            showAlert(message: error.message)
            return
        }

        showConfirmAlert(message: makeErrorMessage(sendOrderViewModel),
                         cancelHandler: nil,
                         agreeHandler: { [weak self] _ in self?.sendOrder(sendOrderViewModel) })
    }

    private func sendOrder(_ viewModel: SendOrderViewModel) {
        switch viewModel.orderType {
        case .limit, .market:
            sendChildOrder(viewModel)
        case .stop, .stopLimit, .trail:
            sendParentOrder(viewModel)
        }
    }

    private func sendChildOrder(_ viewModel: SendOrderViewModel) {
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

    private func sendParentOrder(_ viewModel: SendOrderViewModel) {
        let sendOrderModel = convert(viewModel)
        let requestParameter = makeParentOrderParameter(orderMethodType: .simple, parameters: [sendOrderModel])
        let request = BitflyerSendParentOrderRequest(requestParameter: requestParameter)

        let apiExecuter = ApiKitApiExecuter<BitflyerSendParentOrderRequest, BitflyerSendParentOrderResponse>(request)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }

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
        rootViewController()?.present(alertController, animated: true, completion: nil)
    }

    private func updateCondition(_ condition: OldEnums.Condition) {
        guard let activeViewController = activeViewController, let newAvc = makeSendOrderChildViewController(condition: condition) else {
            return
        }
        removeChildContainerViewController(activeViewController)
        self.activeViewController = newAvc
        addChildContainerViewController(newAvc, atContainerView: containerView)
    }
}
