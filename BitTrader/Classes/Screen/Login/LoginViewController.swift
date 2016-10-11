//
//  LoginViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import APIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let loginViewModel = LoginViewModel()
    
    // MARK: IBOutlet
    @IBOutlet weak private var apiKeyTextField: UITextField!
    @IBOutlet weak private var apiSecretKeyTextField: UITextField!
    @IBOutlet weak private var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        apiKeyTextField.text = loginViewModel.apiKey.value
        apiKeyTextField.rx.text
            .bindTo(loginViewModel.apiKey)
            .addDisposableTo(disposeBag)
        
        loginViewModel.apiKey.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(apiKeyTextField.rx.text)
            .addDisposableTo(disposeBag)
        
        apiSecretKeyTextField.text = loginViewModel.apiSecretKey.value
        apiSecretKeyTextField.rx.text
            .bindTo(loginViewModel.apiSecretKey)
            .addDisposableTo(disposeBag)
        
        loginViewModel.apiSecretKey.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(apiSecretKeyTextField.rx.text)
            .addDisposableTo(disposeBag)
        
        
        settingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.loginViewModel.registApiKeyInformation()
                self?.sendRequest()
            })
        .addDisposableTo(disposeBag)
        
        loginViewModel.enableSettingButton
            .bindTo(settingButton.rx.enabled)
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendRequest() {
        let publicAPI = BitTraderPublicAPI()
        publicAPI.sendGetHealthRequest()
        
        let privateAPI = BitTraderPrivateAPI()
        privateAPI.sendGetBalanceRequest()
        privateAPI.sendGetChildOrdersRequest()
    }
}
