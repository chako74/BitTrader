//
//  AppDelegate.swift
//  BitTrader
//
//  Created by chako on 2016/10/04.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import ReSwift

var store = Store<State>(reducer: AppReducer(), state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = RootViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
