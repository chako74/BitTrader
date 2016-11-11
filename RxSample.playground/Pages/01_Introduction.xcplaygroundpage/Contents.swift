
import RxSwift

example("Observable with no subscribers") {
    _ = Observable<String>.create { observerOfString -> Disposable in
        print("This will never be printed")
        observerOfString.on(.next("😬"))
        observerOfString.on(.completed)
        return Disposables.create()
    }
}

example("Observable with subscriber") {
  _ = Observable<String>.create { observerOfString in
            print("Observable created")
            observerOfString.on(.next("😉"))
            observerOfString.on(.completed)
            return Disposables.create()
        }
        .subscribe { event in
            print(event)
    }
}
