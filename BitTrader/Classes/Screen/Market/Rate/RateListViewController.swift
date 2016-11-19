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

    func startRequest() {
        
        let bitflyerTickerRequest = BitflyerTickerRequest()
        let bitflyerTickerRequestExecuter = ApiKitApiExecuter(bitflyerTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.bitflyer,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.ask),
                                 bidPrice: Variable(response.bid))
        })

        let btcBoxTickerRequest = BtcBoxTickerRequest()
        let btcBoxTickerRequestExecuter = ApiKitApiExecuter(btcBoxTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.btcBox,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.sell),
                                 bidPrice: Variable(response.buy))
        })

        let coincheckTickerRequest = CoincheckTickerRequest()
        let coincheckTickerRequestExecuter = ApiKitApiExecuter(coincheckTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.coincheck,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.ask),
                                 bidPrice: Variable(response.bid))
        })

        let krakenTickerRequest = KrakenTickerRequest()
        let krakenTickerRequestExecuter = ApiKitApiExecuter(krakenTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.kraken,
                                 midPrice: Variable(Int(floor(atof(response.result!.currencyPair.c.first!)))),
                                 askPrice: Variable(Int(floor(atof(response.result!.currencyPair.a.first!)))),
                                 bidPrice: Variable(Int(floor(atof(response.result!.currencyPair.b.first!)))))
        })

        let zaifTickerRequest = ZaifTickerRequest()
        let zaifTickerRequestExecuter = ApiKitApiExecuter(zaifTickerRequest, responseConverter: { response in
            return RateViewModel(rateType:.zaif,
                                 midPrice: Variable(response.last),
                                 askPrice: Variable(response.ask),
                                 bidPrice: Variable(response.bid))
        })

        Observable.combineLatest(Api.rxExecute(bitflyerTickerRequestExecuter),
                                 Api.rxExecute(btcBoxTickerRequestExecuter),
                                 Api.rxExecute(coincheckTickerRequestExecuter),
                                 Api.rxExecute(krakenTickerRequestExecuter),
                                 Api.rxExecute(zaifTickerRequestExecuter)) { ($0, $1, $2, $3, $4) }
            .flatMapLatest { (bitflyer, btcBox, coincheck, kraken, zaif) -> Observable<[RateViewModel]> in
                return .just([bitflyer!, btcBox!, coincheck!, kraken!, zaif!])
            }
            .subscribe(onNext: { [weak self] models in
                self?.rateListViewModel.rateList.value = models
            })
            .addDisposableTo(disposeBag)
        
    }
    
}
