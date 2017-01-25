//
//  ReReSimpleOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import ReSwift

class ReSimpleOrderViewController: ReBaseSendOrderViewController, ViewContainer, ApiExecuterDelegate, StoreSubscriber {
    
    private var activeViewController: ReBaseSendOrderCommonViewController?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendOrderButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let state = store.state.parentOrderState.simple else {
            return
        }
        activeViewController = remakeSendOrderChildViewController(place: .First, condition: state.condition.enums)
        addChildContainerViewController(activeViewController!, atContainerView: containerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) { state in
            state.parentOrderState
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    func newState(state: ParentOrderState) {
        guard let orderState = state.simple else {
            return
        }
        updateCondition(orderState.condition.enums)
    }

    func updateCondition(_ condition: OldEnums.Condition) {
        guard let activeViewController = activeViewController,
            let newAvc = remakeSendOrderChildViewController(place: .First, condition: condition),
            type(of: activeViewController) != type(of: newAvc) else {
                return
        }

        removeChildContainerViewController(activeViewController)
        self.activeViewController = newAvc
        addChildContainerViewController(newAvc, atContainerView: containerView)
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

        let sendOrderViewModel: ReSendOrderViewModel
        do {
            sendOrderViewModel = try activeViewController.reSendOrderViewModel()
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
                         agreeHandler: { [weak self] _ in self?.sendChildOrder(sendOrderViewModel) })
    }

    private func sendChildOrder(_ viewModel: ReSendOrderViewModel) {
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

    private func sendParentOrder(_ viewModel: ReSendOrderViewModel) {
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
}
