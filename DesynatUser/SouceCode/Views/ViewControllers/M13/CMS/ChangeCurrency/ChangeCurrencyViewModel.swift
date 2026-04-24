//
//  ChangeCurrencyViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import Foundation
class ChangeCurrencyViewModel{
    
    var hostVc: ChangeCurrencyViewController?
    var getAllUSerCountryList:[GetAllUserCountryModel] = []
    var currencyList: [String] = ["USD", "INR", "EUR", "GBP"] // example
    
    init(hostVc: ChangeCurrencyViewController? = nil) {
        self.hostVc = hostVc
    }
    
    func getALlUserCountryListApi(){
          WebService.sharedInstance.getAllUserscountryList { list in
              self.getAllUSerCountryList = list
              DispatchQueue.main.async {
                          self.hostVc?.listTableView.reloadData()
              }
          }
      }
    
}
