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
        Observable.combineLatest(ApiClient.rxExecute(createBitflyerTickerRequestExecuter()),
                                 ApiClient.rxExecute(createBitflyerFxTickerRequestExecuter()),
                                 ApiClient.rxExecute(createBtcBoxTickerRequestExecuter()),
                                 ApiClient.rxExecute(createCoincheckTickerRequestExecuter()),
                                 ApiClient.rxExecute(createKrakenTickerRequestExecuter()),
                                 ApiClient.rxExecute(createZaifTickerRequestExecuter())) { r in r }
            .scan((nil, nil, nil, nil, nil, nil)) { [weak self] (x, y) throws -> (RateModel?, RateModel?, RateModel?, RateModel?, RateModel?, RateModel?) in
                let v0 = self?.checkNext(x.0, y.0)
                let v1 = self?.checkNext(x.1, y.1)
                let v2 = self?.checkNext(x.2, y.2)
                let v3 = self?.checkNext(x.3, y.3)
                let v4 = self?.checkNext(x.4, y.4)
                let v5 = self?.checkNext(x.5, y.5)
                return (v0, v1, v2, v3, v4, v5)
            }
            .flatMapLatest { (bitflyer, bitflyerFx, btcBox, coincheck, kraken, zaif) -> Observable<[RateModel]> in
                var models = Array<RateModel>()
                models.appendNotNil(element: bitflyer)
                models.appendNotNil(element: bitflyerFx)
                models.appendNotNil(element: btcBox)
                models.appendNotNil(element: coincheck)
                models.appendNotNil(element: kraken)
                models.appendNotNil(element: zaif)
                return .just(models)
            }
            .subscribe(onNext: { [weak self] models in
                self?.rateListViewModel.rateList.value = models
                })
            .addDisposableTo(disposeBag)
    }

    private func createBitflyerTickerRequestExecuter() -> ApiKitApiExecuter<BitflyerTickerRequest, RateModel> {
        let bitflyerTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: .btcjpy)
        let bitflyerTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerTickerReuqestParameter)
        return ApiKitApiExecuter(bitflyerTickerRequest, responseConverter: { response in
            return RateModel(rateType:.bitflyer,
                             midPrice: response.ltp,
                             askPrice: response.bestAsk,
                             bidPrice: response.bestBid)
        })
    }

    private func createBitflyerFxTickerRequestExecuter() -> ApiKitApiExecuter<BitflyerTickerRequest, RateModel> {
        let bitflyerFxTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: .fxBtcJpy)
        let bitflyerFxTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerFxTickerReuqestParameter)
        return ApiKitApiExecuter(bitflyerFxTickerRequest, responseConverter: { response in
            return RateModel(rateType:.bitflyerFx,
                             midPrice: response.ltp,
                             askPrice: response.bestAsk,
                             bidPrice: response.bestBid)
        })
    }

    private func createBtcBoxTickerRequestExecuter() -> ApiKitApiExecuter<BtcBoxTickerRequest, RateModel> {
        let btcBoxTickerRequest = BtcBoxTickerRequest()
        return ApiKitApiExecuter(btcBoxTickerRequest, responseConverter: { response in
            return RateModel(rateType:.btcBox,
                             midPrice: response.last,
                             askPrice: response.sell,
                             bidPrice: response.buy)
        })
    }

    private func createCoincheckTickerRequestExecuter() -> ApiKitApiExecuter<CoincheckTickerRequest, RateModel> {
        let coincheckTickerRequest = CoincheckTickerRequest()
        return ApiKitApiExecuter(coincheckTickerRequest, responseConverter: { response in
            return RateModel(rateType:.coincheck,
                             midPrice: response.last,
                             askPrice: response.ask,
                             bidPrice: response.bid)
        })
    }

    private func createKrakenTickerRequestExecuter() -> ApiKitApiExecuter<KrakenTickerRequest, RateModel> {
        let krakenTickerRequest = KrakenTickerRequest()
        return ApiKitApiExecuter(krakenTickerRequest, responseConverter: { response in
            return RateModel(rateType:.kraken,
                             midPrice: Int(floor(atof(response.result!.currencyPair.c.first!))),
                             askPrice: Int(floor(atof(response.result!.currencyPair.a.first!))),
                             bidPrice: Int(floor(atof(response.result!.currencyPair.b.first!))))
        })
    }

    private func createZaifTickerRequestExecuter() -> ApiKitApiExecuter<ZaifTickerRequest, RateModel> {
        let zaifTickerRequest = ZaifTickerRequest()
        return ApiKitApiExecuter(zaifTickerRequest, responseConverter: { response in
            return RateModel(rateType:.zaif,
                             midPrice: response.last,
                             askPrice: response.ask,
                             bidPrice: response.bid)
        })
    }

    private func checkNext(_ prev: RateModel?, _ next: RateModel?) -> RateModel? {
        if prev != nil && next == nil {
            return prev
        }
        return next
    }
    
}
