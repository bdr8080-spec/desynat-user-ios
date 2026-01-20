//
//  MyOrderVM.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit

class MyOrderVM: NSObject {
    private var hostVC: MyOrderVC
    var searchText: String = ""

    init(hostVC: MyOrderVC) {
        self.hostVC = hostVC
    }

    func getCurrentFilter() -> OrderFilterType {
        return hostVC.isCustomOrderSeleced
            ? hostVC.customOrderFilter
            : hostVC.normalOrderFilter
    }

    func getOrders(type: Int) {
        let filter = getCurrentFilter()

        var params: [String: Any] = [
            "order_type": type,
            "filter": filter.rawValue   // FIX HERE
        ]

        if !searchText.isEmpty {
            params["search"] = searchText
        }

        WebService.sharedInstance.getOrdersApi(param: params) { data in
            self.hostVC.orderData = data
            self.hostVC.orderTableView.reloadData()
            self.hostVC.lblNoData.isHidden = !data.isEmpty
        }
    }
}
