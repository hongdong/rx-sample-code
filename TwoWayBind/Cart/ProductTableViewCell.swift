//
//  ProductTableViewCell.swift
//  RxDealCell
//
//  Created by DianQK on 8/4/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductTableViewCell: UITableViewCell {
    
    var product:ProductInfo! {
        didSet {
            if product == nil {
                fatalError()
            }
            nameLabel?.text = product.name
            unitPriceLabel.text = "单价：\(product.unitPrice) 元"
            product.count.asObservable()
                .subscribe(onNext: {
                if $0 < 0 {
                    fatalError()
                }
                self.minusButton.isEnabled = $0 != 0
                self.countLabel.text = String($0)
                })
                .disposed(by: self.rx.prepareForReuseBag)
            
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var unitPriceLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var minusButton: UIButton! {
        didSet {
            minusButton.addTarget(self, action: #selector(ProductTableViewCell.minusButtonTap), for:.touchUpInside)
        }
    }

    @IBOutlet private weak var plusButton: UIButton! {
        didSet {
            plusButton.addTarget(self, action: #selector(ProductTableViewCell.plusButtonTap), for:.touchUpInside)
        }
    }

    private dynamic func minusButtonTap() {
        changeCount(-=)
    }

    private dynamic func plusButtonTap() {
        changeCount(+=)
    }

    private typealias Action = ((_ lhs: inout Int, _ rhs: Int) -> Void)

    private func changeCount(_ action: Action) {
        action(&product.count.value, 1)
    }

}
