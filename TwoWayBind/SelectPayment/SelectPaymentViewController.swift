//
//  SelectPaymentViewController.swift
//  RxDealCell
//
//  Created by DianQK on 8/5/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxExtensions

struct SelectPayment: Hashable , IdentifiableType {
    let select: Variable<Payment>//选择哪一个

    var hashValue: Int {
        return select.value.hashValue
    }

    var identity: Int {
        return select.value.hashValue
    }

    init(defaultSelected: Payment) {
        select = Variable(defaultSelected)
    }
}

func ==(lhs: SelectPayment, rhs: SelectPayment) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

typealias PaymentSectionModel = AnimatableSectionModel<SelectPayment, Payment>

class SelectPaymentViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let dataSource = RxTableViewSectionedReloadDataSource<PaymentSectionModel>{ ds, tb, ip, payment in
        let cell = tb.dequeueReusableCell(withIdentifier: R.reuseIdentifier.paymentTableViewCell, for: ip)!
        cell.setPayment(payment)
        let sectionModel = ds[ip.section]//拿到这个组的SectionModel,里面保存了这个组选择的是哪一个
        let selectedPayment = sectionModel.model.select.asObservable()
        
        selectedPayment
            .map { $0 == payment }
            .bind(to: cell.rx.isSelectedPayment)
            .disposed(by: cell.rx.prepareForReuseBag)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataSource.configureCell = { ds, tb, ip, payment in
//            let cell = tb.dequeueReusableCell(withIdentifier: R.reuseIdentifier.paymentTableViewCell, for: ip)!
//            cell.setPayment(payment)
//            let sectionModel = ds[ip.section]//拿到这个组的SectionModel,里面保存了这个组选择的是哪一个
//            let selectedPayment = sectionModel.model.select.asObservable()
//            selectedPayment
//                .map { $0 == payment }
//                .bind(to: cell.rx.isSelectedPayment)
//                .disposed(by: cell.rx.prepareForReuseBag)
//            return cell
//        }

        let selectPayment = SelectPayment(defaultSelected: Payment.alipay)

        tableView
            .rx
            .modelSelected(Payment.self)
            .bind(to: selectPayment.select)
            .disposed(by: rx.disposeBag)

        let paymentSection = PaymentSectionModel(
            model: selectPayment,
            items: [.alipay, .wechat, .applepay, .unionpay])

        Observable.just([paymentSection])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        tableView
            .rx
            .enableAutoDeselect()
            .disposed(by: rx.disposeBag)

        do {//title
            selectPayment.select.asObservable()
                .map { $0.name }
                .bind(to: self.rx.title)
                .disposed(by: rx.disposeBag)
        }
    }

}
