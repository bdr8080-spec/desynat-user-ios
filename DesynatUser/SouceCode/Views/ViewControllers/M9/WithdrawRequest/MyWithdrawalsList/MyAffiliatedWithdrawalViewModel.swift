//
//  MyAffiliatedWithdrawalViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import Foundation

class MyAffiliatedWithdrawalViewModel {
    
    private var hostVC: MyAffiliatedWithdrawalViewController!
    var moneyWithdrawalData: WithdrawRequestDataModel?
    var searchWorkItem: DispatchWorkItem?
    var searchText: String = ""
    
    init(hostVC: MyAffiliatedWithdrawalViewController!) {
        self.hostVC = hostVC
    }
    
    func getWalletHistory() {
        var param: [String:Any]  = ["req_type": hostVC.requestType.rawValue] //0-pending/upcoming,1-approved/credited
        if !searchText.isEmpty { param["search"] = searchText }
        WebService.sharedInstance.getAffilateWithdrwalService(withParams: param) { data in
            DispatchQueue.main.async {
                self.moneyWithdrawalData = data
                self.hostVC.totalWithdrawalsLabel.text = CommonUtils.formatPriceStringInput(data.totalWithdrawals)
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !(self.moneyWithdrawalData?.withdrawRequests?.data?.isEmpty ?? true)
            }
        }
    }
    
}
