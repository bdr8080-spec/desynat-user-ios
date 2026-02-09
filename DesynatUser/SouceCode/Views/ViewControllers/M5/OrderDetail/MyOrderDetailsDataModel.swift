//
//  MyOrderDetailsDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 09/02/26.
//

import Foundation

struct StepImage {
    let selected: String
    let unselected: String
}

protocol SelectReasonDelegate: AnyObject {
    func didUpdateOrder(status: SelectScreenType)
}
