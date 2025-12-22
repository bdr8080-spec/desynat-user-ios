//
//  MyOrderDetailVM.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit

class MyOrderDetailVM: NSObject {
    private var hostVC: MyOrderDetailVC
    var searchText: String = ""
    
    init(hostVC: MyOrderDetailVC) {
        self.hostVC = hostVC
    }
    
    func getOrderDetail() {
        var params: [String: Any] = [
            "order_id": hostVC.orderId ?? 0,
            "orderdetails_id": hostVC.orderDetailId ?? 0
        ]
        
        WebService.sharedInstance.getOrderDetail(param: params) { data in
            self.hostVC.orderData = data
        }
    }
}
