//
//  ChangeCurrencyViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import Foundation
class ChangeCurrencyViewModel{
    
    var hostVc: ChangeCurrencyViewController?
    var getAllUSerCountryList:[CountryModel] = []
    
    init(hostVc: ChangeCurrencyViewController? = nil) {
        self.hostVc = hostVc
    }
    
//    func getALlUserCountryListApi(){
//        WebService.sharedInstance.getAllUserscountryList { list in
//            self.getAllUSerCountryList = list
//            DispatchQueue.main.async {
//                self.hostVc?.listTableView.reloadData()
//            }
//        }
//    }
    
    func getAllUsersCurrencyList(){
        WebService.sharedInstance.getAllUsersCurrencyList { list in
            self.getAllUSerCountryList = list
            DispatchQueue.main.async {
                self.hostVc?.listTableView.reloadData()
            }
        }
    }
    
    func updateCountry(){
        let param: [String: Any] = ["country_id": hostVc?.selectedId ?? 1]
        WebService.sharedInstance.updatecountryList(param: param) { list in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Country updated successfully".localiz())
                self.hostVc?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateCurrency(){
        let param: [String: Any] = ["currency": hostVc?.selectedId ?? 1]
        WebService.sharedInstance.updateCurrencyList(param: param) { list in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Currency updated successfully".localiz())
                self.hostVc?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateAffiliateCountry(){
        let param: [String: Any] = ["country_id": hostVc?.selectedId ?? 1]
        WebService.sharedInstance.updateAffiliatecountryList(param: param) { list in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Country updated successfully".localiz())
                self.hostVc?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateAffiliateCurrency(){
        let param: [String: Any] = ["currency": hostVc?.selectedId ?? 1]
        WebService.sharedInstance.updateAffiliateCurrencyList(param: param) { list in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Currency updated successfully".localiz())
                self.hostVc?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
