//
//  RxMarketOrderViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class RxMarketOrderViewController: RxBaseSendOrderCommonViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = RxMarketOrderViewModel()
    
    private var bidAsk: OldEnums.BidAsk
    
    @IBOutlet weak var bidButton: BidAskButton!
    @IBOutlet weak var askButton: BidAskButton!
    
    init(bidAsk: OldEnums.BidAsk) {
        self.bidAsk = bidAsk
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponent()
        
        bindRateButton()
    }
        
    private func initializeComponent() {
        bidButton.initializeBidAsk(.bid)
        bidButton.font(UIFont(name: (bidButton.titleLabel?.font.fontName)!, size: 30.0)!)
        bidButton.title(OldEnums.BidAsk.bid.rawValue)
        
        askButton.initializeBidAsk(.ask)
        askButton.font(UIFont(name: (askButton.titleLabel?.font.fontName)!, size: 30.0)!)
        askButton.title(OldEnums.BidAsk.ask.rawValue)
    }
    
    private func bindRateButton() {
        self.viewModel.selectedBidAsk()
            .asDriver()
            .drive(onNext: { [weak self] selectedBidAsk in
                self?.bidButton?.selected(bidAsk: selectedBidAsk)
                self?.askButton?.selected(bidAsk: selectedBidAsk)
            })
            .addDisposableTo(disposeBag)
        
        bidButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.setSelectedBidAsk(.bid)
            })
            .addDisposableTo(disposeBag)
        
        askButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.setSelectedBidAsk(.ask)
            })
            .addDisposableTo(disposeBag)
    }
}
