//
//  CartViewController.swift
//  RxDealCell
//
//  Created by DianQK on 8/4/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxExtensions

struct ProductInfo {
    let id: Int
    let name: String
    let unitPrice: Int
    let count: Variable<Int>
}

extension ProductInfo: Hashable, Equatable, IdentifiableType {
    var hashValue: Int {
        return id.hashValue
    }
    var identity: Int {
        return id
    }

    static func ==(lhs: ProductInfo, rhs: ProductInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

typealias ProductSectionModel = AnimatableSectionModel<String, ProductInfo>



class CartViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var purchaseButton: UIButton!{
        didSet{
            
        }
    }

    private let dataSource = RxTableViewSectionedReloadDataSource<ProductSectionModel>(){
        _, tableView, indexPath, product in
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.productTableViewCell, for: indexPath)!
        cell.product = product
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let products = [1, 2, 3, 4]
            .map { ProductInfo(id: 1000 + $0, name: "Product\($0)", unitPrice: $0 * 100, count: Variable(0)) }

        //数据源信号
        let sectionInfo = Observable.just([ProductSectionModel(model: "Section1", items: products)])
            .shareReplay(1)

//        dataSource.configureCell = { _, tableView, indexPath, product in
//            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.productTableViewCell, for: indexPath)!
//            cell.product = product
//            return cell
//        }

        sectionInfo
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        
        let totalPrice = sectionInfo.map{  //先把所有组中的元素摊平成一个数组
            $0.flatMap{
                $0.items
            }
        }.flatMap{
            $0.reduce(.just(0)){acc,x in
                
                Observable.combineLatest(acc,x.count.asObservable().map{
                    x.unitPrice * $0
                },resultSelector: +)
                
            }
        }
        .shareReplay(1)
        
        totalPrice
            .map { "总价：\($0) 元" }
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: rx.disposeBag)

        totalPrice
            .map { $0 != 0 }
            .bind(to: purchaseButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        tableView.rx.enableAutoDeselect().disposed(by: rx.disposeBag)

    }

}
