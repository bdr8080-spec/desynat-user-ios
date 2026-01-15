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
  
  func getOrders(type: Int) {
    var params: [String: Any] = [
      "order_type": type,
      "filter": hostVC.selectedFilter.rawValue // 1 all 2 onging 3 delivered 4 cancelled 5 return
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
