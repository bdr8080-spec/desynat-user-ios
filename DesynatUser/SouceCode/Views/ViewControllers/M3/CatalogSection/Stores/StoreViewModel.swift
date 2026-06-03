//
//  StoreViewModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation
import UIKit

class StoreViewModel: NSObject {
    
    private var hostVC: StoresViewController
    var storesSection:[StoreListDataModel] = []
    var searchText: String = ""
    var homeScreenAllBannersList: [HomescreenBannersList] = []
    
    init(hostVC: StoresViewController) {
        self.hostVC = hostVC
    }
    
    func getStoresListApi() {
        let savedUser = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self)

        var param: [String: Any] = ["category_id": hostVC.slecetedCategoryID,
                                    "subcategory": hostVC.slectedsubCategoryId ?? 0
        ]
        if let userId = savedUser?.id {
            param["user_id"] = userId
        }
        if !searchText.isEmpty {
            param["search"] = searchText
        }
        
        // Ratings
        if !hostVC.appliedRatings.isEmpty {
            param["rating"] = hostVC.appliedRatings
        }
        
        // Availability (1=open, 0=busy)
        if !hostVC.appliedAvailability.isEmpty {
            param["availbility"] = hostVC.appliedAvailability
        }
        
        //          // Shortest delivery
        //          if hostVC.appliedShortest {
        //              param["shortest"] = "1"
        //          }
        //
        //          // Highest sale
        //          if hostVC.appliedHighest {
        //              param["highest"] = "1"
        //          }
        WebService.sharedInstance.getStoresListService(param: param) { list in
            self.storesSection = list
            DispatchQueue.main.async {
                self.hostVC.storesCollectionView.reloadData()
                
                // 🔥 Important
                self.hostVC.storesCollectionView.layoutIfNeeded()
                self.hostVC.updateCollectionsHeight()
                
                self.hostVC.noResultFoundLabel.isHidden = !self.storesSection.isEmpty
            }
        }
    }
    
    func getTopHomeBannersListApi(type: Int, category: Int) {
        let param: [String: Any] = ["type": type,
                                    "category": category]
        WebService.sharedInstance.getHomeScreenAllBannersListService(param: param) { list in
            DispatchQueue.main.async {
                self.homeScreenAllBannersList = list
                self.hostVC.bannerCollectionView.reloadData()
                self.hostVC.bannerPageController.numberOfPages = self.homeScreenAllBannersList.count
//                self.hostVC.noTopHomeBannersFoundLabel.isHidden = !self.homeScreenAllBannersList.isEmpty
            }
        }
    }
}
