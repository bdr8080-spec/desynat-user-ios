//
//  MyOrderDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 09/02/26.
//

import Foundation

enum OrderType {
    case order
    case customOrder
}

enum OrderFilterType: Int {
    case all = 1
    case ongoing = 2
    case delivered = 3
    case cancelled = 4
    case returned = 5
}

protocol FilterDelegate: AnyObject {
    func didApplyFilter(_ filter: OrderFilterType)
}
