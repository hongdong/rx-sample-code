//
//  SelectTableViewCell.swift
//  RxDealCell
//
//  Created by DianQK on 8/8/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectTableViewCell: UITableViewCell {

    var name: String? {
        get {
            return nameLabel?.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var selectButton: UIButton!{
        didSet{
            selectButton.layer.borderWidth = 1.0
            selectButton.layer.borderColor = UIColor.black.cgColor
        }
    }

}

extension Reactive where Base: SelectTableViewCell {
    var select: ControlProperty<Bool> {
        return base.selectButton.rx.select
    }
}
