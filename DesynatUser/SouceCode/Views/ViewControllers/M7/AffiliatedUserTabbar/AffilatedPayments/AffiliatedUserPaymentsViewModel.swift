//
//  AffiliatedUserPaymentsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/03/26.
//

import Foundation

class AffiliatedUserPaymentsViewModel {
    
    private var hostVC: AffiliatedUserPaymentsViewController!
    var paymentListData: OrdersDataAffilaitedPaymentDataModel?
    var searchWorkItem: DispatchWorkItem?
    var searchText: String = ""
    var appliedFilter = WithdrawalFilterModel()
    
    init(hostVC: AffiliatedUserPaymentsViewController!) {
        self.hostVC = hostVC
    }
    
    func getWalletHistory() {
        var param: [String:Any]  = [:] //0-pending/upcoming,1-approved/credited
        if !searchText.isEmpty { param["search"] = searchText }
//        if let fromDate = appliedFilter.fromDate {
//            param["filters"] = fromDate
//        }
//        
//        if let toDate = appliedFilter.toDate {
//            param["filters"] = toDate
//        }
        WebService.sharedInstance.getAffilatePaymentHistoryService(withParams: param) { data in
            DispatchQueue.main.async {
                self.paymentListData = data
                self.hostVC.totalRevenuwAmountLabel.text = CommonUtils.formatPrice(data.totalEarning)
                self.hostVC.paymentHistoryTableview.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.hostVC.paymentHistoryTableview.layoutIfNeeded()
                    self.hostVC.paymentHistoryTableviewHeightConstraint.constant =
                    self.hostVC.paymentHistoryTableview.contentSize.height
                }
                self.hostVC.noDataFoundLabel.isHidden = !(self.paymentListData?.orders?.isEmpty ?? true)
            }
        }
    }
}
