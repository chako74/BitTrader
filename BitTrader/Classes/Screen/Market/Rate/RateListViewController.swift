//
//  RateListViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import APIKit
import RxCocoa
import RxSwift

class RateListViewController: UIViewController {

    private static let RateListCellIdentifier = "RateListCell"

    private let disposeBag = DisposeBag()
    private let rateListViewModel = RateListViewModel()

    @IBOutlet weak private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "レート"

        edgesForExtendedLayout = []

        tableView!.register(UINib(nibName: "RateTableViewCell", bundle: nil),
                            forCellReuseIdentifier: RateListViewController.RateListCellIdentifier)

        rateListViewModel.rateList
            .asObservable()
            .bindTo(tableView!.rx.items) { tableView, _, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: RateListViewController.RateListCellIdentifier)!
                if let rateCell = cell as? RateTableViewCell {
                    rateCell.update(model: element)
                }
                return cell
            }
            .addDisposableTo(disposeBag)

        self.startRequest()
    }

    private func startRequest() {
        Observable.combineLatest(Api.rxExecute(createBitflyerTickerRequestExecuter()),
                                 Api.rxExecute(createBitflyerFxTickerRequestExecuter()),
                                 Api.rxExecute(createBtcBoxTickerRequestExecuter()),
                                 Api.rxExecute(createCoincheckTickerRequestExecuter()),
                                 Api.rxExecute(createKrakenTickerRequestExecuter()),
                                 Api.rxExecute(createZaifTickerRequestExecuter())) { r in r }
            .scan((nil, nil, nil, nil, nil, nil)) { [weak self] (x, y) throws -> (RateViewModel?, RateViewModel?, RateViewModel?, RateViewModel?, RateViewModel?, RateViewModel?) in
                let v0 = self?.checkNext(x.0, y.0)
                let v1 = self?.checkNext(x.1, y.1)
                let v2 = self?.checkNext(x.2, y.2)
                let v3 = self?.checkNext(x.3, y.3)
                let v4 = self?.checkNext(x.4, y.4)
                let v5 = self?.checkNext(x.5, y.5)
                return (v0, v1, v2, v3, v4, v5)
            }
            .flatMapLatest { (bitflyer, bitflyerFx, btcBox, coincheck, kraken, zaif) -> Observable<[RateViewModel]> in
                var models = Array<RateViewModel>()
                models.addNotNil(bitflyer)
                models.addNotNil(bitflyerFx)
                models.addNotNil(btcBox)
                models.addNotNil(coincheck)
                models.addNotNil(kraken)
                models.addNotNil(zaif)
                return .just(models)
            }
            .subscribe(onNext: { [weak self] models in
                self?.rateListViewModel.rateList.value = models
                })
            .addDisposableTo(disposeBag)
    }

    private func createBitflyerTickerRequestExecuter() -> ApiKitApiExecuter<BitflyerTickerRequest, RateViewModel> {
        let bitflyerTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: .btcjpy)
        let bitflyerTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerTickerReuqestParameter)
        return ApiKitApiExecuter(bitflyerTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.bitflyer,
                                 midPrice: Variable(response.ltp),
                                 askPrice: Variable(response.bestAsk),
                                 bidPrice: Variable(response.bestBid))
        })
    }

    private func createBitflyerFxTickerRequestExecuter() -> ApiKitApiExecuter<BitflyerTickerRequest, RateViewModel> {
        let bitflyerFxTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: .fxBtcJpy)
        let bitflyerFxTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerFxTickerReuqestParameter)
        return ApiKitApiExecuter(bitflyerFxTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.bitflyerFx,
                                 midPrice: Variable(response.ltp),
                                 askPrice: Variable(response.bestAsk),
                                 bidPrice: Variable(response.bestBid))
        })
    }

    private func createBtcBoxTickerRequestExecuter() -> ApiKitApiExecuter<BtcBoxTickerRequest, RateViewModel> {
        let btcBoxTickerRequest = BtcBoxTickerRequest()
        return ApiKitApiExecuter(btcBoxTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.btcBox,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.sell),
                                 bidPrice: Variable(response.buy))
        })
    }

    private func createCoincheckTickerRequestExecuter() -> ApiKitApiExecuter<CoincheckTickerRequest, RateViewModel> {
        let coincheckTickerRequest = CoincheckTickerRequest()
        return ApiKitApiExecuter(coincheckTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.coincheck,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.ask),
                                 bidPrice: Variable(response.bid))
        })
    }

    private func createKrakenTickerRequestExecuter() -> ApiKitApiExecuter<KrakenTickerRequest, RateViewModel> {
        let krakenTickerRequest = KrakenTickerRequest()
        return ApiKitApiExecuter(krakenTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.kraken,
                                 midPrice: Variable(Int(floor(atof(response.result!.currencyPair.c.first!)))),
                                 askPrice: Variable(Int(floor(atof(response.result!.currencyPair.a.first!)))),
                                 bidPrice: Variable(Int(floor(atof(response.result!.currencyPair.b.first!)))))
        })
    }

    private func createZaifTickerRequestExecuter() -> ApiKitApiExecuter<ZaifTickerRequest, RateViewModel> {
        let zaifTickerRequest = ZaifTickerRequest()
        return ApiKitApiExecuter(zaifTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.zaif,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.ask),
                                 bidPrice: Variable(response.bid))
        })
    }

    private func checkNext(_ prev: RateViewModel?, _ next: RateViewModel?) -> RateViewModel? {
        if prev != nil && next == nil {
            return prev
        }
        return next
    }
    
}
