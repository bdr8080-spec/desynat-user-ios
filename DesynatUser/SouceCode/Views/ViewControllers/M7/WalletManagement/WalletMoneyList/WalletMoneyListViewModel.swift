//
//  WalletMoneyListViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation

class WalletMoneyListViewModel {
    
    private var hostVC: WalletMoneyListViewController
    var walletData: WalletMoneyHistoryDataModel?
    
    init(hostVC: WalletMoneyListViewController) {
        self.hostVC = hostVC
    }
    
    func getWalletHistory() {
        WebService.sharedInstance.getWalletHistorySerivice() { data in
            DispatchQueue.main.async {
                self.walletData = data
                self.hostVC.setData()
                self.hostVC.walletTableView.reloadData()
                self.hostVC.walletTableView.layoutIfNeeded()
                self.hostVC.updateTableViewHieght()
                self.hostVC.noDataFoundLabel.isHidden = !(self.walletData?.history?.isEmpty ?? true)
            }
        }
    }
    
}
