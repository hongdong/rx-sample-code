//
//  PushSettingData.swift
//  RxDealCell
//
//  Created by DianQK on 8/8/16.
//  Copyright © 2016 T. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


let pushSettingData: [PushSettingSectionModel] = {
    let consumptionItems = [
        PushItemModel(pushType: .confirm, select: Variable(true)),
        PushItemModel(pushType: .willExpire, select: Variable(true)),
        PushItemModel(pushType: .expired, select: Variable(true)),
        PushItemModel(pushType: .refunded, select: Variable(true)),
    ]
    let consumptionSection = PushSettingSectionModel(model: "全选", items: consumptionItems)

    let otherItems = [
        PushItemModel(pushType: .getGift, select: Variable(true)),
        PushItemModel(pushType: .couponInfo, select: Variable(true)),
        PushItemModel(pushType: .favorite, select: Variable(true)),
    ]
    let otherSection = PushSettingSectionModel(model: "全选", items: otherItems)
    return [consumptionSection, otherSection]
}()
