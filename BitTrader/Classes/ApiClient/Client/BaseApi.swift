//
//  BaseApi.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit

class BaseApi: ApiProtocol {

    func execute<RequestType: RequestProtocol>(_ request: RequestType) -> Observable<RequestType.Response> {
        return Observable<Int>
            .interval(3.0, scheduler: Dependencies.sharedDependencies.mainScheduler)
            .startWith(0)
            .trackActivity(ActivityIndicator())
            .observeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .flatMap {_ -> Observable<RequestType.Response> in
                return Observable<RequestType.Response>.create { observer in
                    let task = Session.send(request) { result in
                        switch result {
                        case .success(let res):
                            observer.on(.next(res))
                            observer.on(.completed)
                        case .failure(let err):
                            observer.onError(err)
                        }
                    }
                    return Disposables.create { [weak task] in
                        task?.cancel()
                    }
                }
            }
            //            .observeOn(Dependencies.sharedDependencies.mainScheduler)
            .shareReplay(1)
    }
}

class Dependencies {

    // *****************************************************************************************
    // !!! This is defined for simplicity sake, using singletons isn't advised               !!!
    // !!! This is just a simple way to move services to one location so you can see Rx code !!!
    // *****************************************************************************************
    static let sharedDependencies = Dependencies() // Singleton

    let URLSession = Session.shared
    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler
    //    let reachabilityService: ReachabilityService

    private init() {

        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = QualityOfService.userInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)

        mainScheduler = MainScheduler.instance
        //        reachabilityService = try! DefaultReachabilityService() // try! is only for simplicity sake
    }
}

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.

 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityIndicator : SharedSequenceConvertibleType {
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }

    private func increment() {
        _lock.lock()
        _variable.value = _variable.value + 1
        _lock.unlock()
    }

    private func decrement() {
        _lock.lock()
        _variable.value = _variable.value - 1
        _lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
