//
//  AffiliatedUserHomeViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation
import SDWebImage

class AffiliatedUserHomeViewModel {
    
    private var hostVC: AffiliatedUserHomeViewController
    var dashBoardData = AffiliateDashboardDataModel()
    var dashboardFilter = AffiliateDashboardFilterModel()
    
    init(hostVC: AffiliatedUserHomeViewController) {
        self.hostVC = hostVC
    }
    
    func getCountOfNotificationRequest(){
        WebService.sharedInstance.getCountOfNotificationForAffilatedUserService { [self] count in
            if count > 0 {
                self.hostVC.ntoificationcountView.isHidden = false
                self.hostVC.notificationCountLabel.text = count.description
            } else {
                self.hostVC.ntoificationcountView.isHidden = true
            }
        }
    }
    
    func getUserData() {
        if let userDetails: AffiliateCreateAccountDataModel = kSharedUserDefaults.retrieveModelFor(key: .affiliatedUserDeatils, model: AffiliateCreateAccountDataModel.self) {
            hostVC.usernameLabel.text = "\("Hi".localiz()) \(userDetails.fullName ?? "")"
            
            hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            (hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
            if let imageUrlString = userDetails.profileImage,
               let url = URL(string: imageUrlString) {
                hostVC.userProfileImageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "userProfile")
                )
            } else {
                hostVC.userProfileImageView.image = UIImage(named: "userProfile")
            }
        }
    }
    
    func getDashboardData(fromDate: String,toDate: String, filterType: Int) {
        let param = ["from_date":fromDate, "to_date":toDate, "filter_type":filterType] as [String: Any]
        WebService.sharedInstance.getAffiliateDashboardDataService(param: param) { data in
            self.hostVC.lblTotalRevenue.text = CommonUtils.formatPriceStringInput(data.totalRevenue)
            self.hostVC.lblTotalProduct.text = "\(data.totalProducts ?? 0)"
            self.hostVC.lblTotalOrder.text = "(\(data.totalOrders ?? 0))"
            self.hostVC.lblOngoing.text = "\(data.totalOngoing ?? 0)"
            self.hostVC.lblReturn.text = "\(data.totalReturned ?? 0)"
            self.hostVC.lblCancelled.text = "\(data.totalCancelled ?? 0)"
            self.hostVC.lblCompleted.text = "\(data.totalCompleted ?? 0)"
        }
    }
    
    func getDashboardData() {
        var params: [String : Any] = [:]
        if let filter = dashboardFilter.filter {
            params["filter"] = filter
        }
        
        // ✅ Send dates ONLY if both exist
            if let fromDate = dashboardFilter.fromDate,
               let toDate = dashboardFilter.toDate,
               !fromDate.isEmpty,
               !toDate.isEmpty {
                
                params["from_date"] = fromDate
                params["to_date"] = toDate
            }
        
        WebService.sharedInstance.getAffiliateDashboardDataService(param: params) { data in
            self.hostVC.lblTotalRevenue.text = CommonUtils.formatPriceStringInput(data.totalRevenue)
            self.hostVC.lblTotalProduct.text = "\(data.totalProducts ?? 0)"
            self.hostVC.lblTotalOrder.text = "(\(data.totalOrders ?? 0))"
            self.hostVC.lblOngoing.text = "\(data.totalOngoing ?? 0)"
            self.hostVC.lblReturn.text = "\(data.totalReturned ?? 0)"
            self.hostVC.lblCancelled.text = "\(data.totalCancelled ?? 0)"
            self.hostVC.lblCompleted.text = "\(data.totalCompleted ?? 0)"
        }
    }
}


struct AffiliateDashboardFilterModel {
    var fromDate: String?
    var toDate: String?
    var filter: Int?
    
    var isEmpty: Bool {
        return fromDate == nil && toDate == nil && filter == nil
    }
}
