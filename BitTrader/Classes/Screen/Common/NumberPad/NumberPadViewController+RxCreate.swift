//
//  NumberPadViewController+RxCreate.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/06.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

func dismissViewController(_ viewController: UIViewController, animated: Bool) {

    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: NumberPadViewController {

    static func createWithParent(_ parent: UIViewController?,
                                 animated: Bool = true,
                                 configureNumberPad: @escaping (NumberPadViewController) throws -> () = { x in }) -> Observable<NumberPadViewController> {

        return Observable.create { [weak parent] observer in

            let numberPad = NumberPadViewController()
            let dismissDisposable = numberPad
                .didCancel
                .subscribe(onNext: { numberPad in
                    dismissViewController(numberPad, animated: animated)
                })

            do {
                try configureNumberPad(numberPad)
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            numberPad.modalPresentationStyle = .overCurrentContext
            numberPad.view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
            parent.present(numberPad, animated: animated, completion: nil)
            observer.on(.next(numberPad))

            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(numberPad, animated: animated)
            })
        }
    }
}
