//
//  StoreDetailsViewModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation
import UIKit

class StoreDetailsViewModel: NSObject {
    
    private var hostVC: StoresDetailsViewController
  var singleStoresSection: SingleStoreDetailsDataModel?
  var searchText: String = ""
  
    init(hostVC: StoresDetailsViewController) {
        self.hostVC = hostVC
    }

    func getSingleStoresApi() {
      var param: [String: Any] = ["store_id": hostVC.storeId ?? 0]
      if !searchText.isEmpty {
        param["search"] = searchText
      }
      
      if let sort = hostVC.appliedSortFilter {
              param["sort_filter"] = sort
          }

          // Ratings
//          if !hostVC.appliedRatings.isEmpty {
//              param["rating"] = hostVC.appliedRatings
//          }
//
//          // Availability (1=open, 0=busy)
//          if !hostVC.appliedAvailability.isEmpty {
//              param["availbility"] = hostVC.appliedAvailability
//          }

//          // Shortest delivery
//          if hostVC.appliedShortest {
//              param["shortest"] = "1"
//          }
//
//          // Highest sale
//          if hostVC.appliedHighest {
//              param["highest"] = "1"
//          }
      WebService.sharedInstance.getSingleStoresListService(param: param) { list in
            self.singleStoresSection = list
        DispatchQueue.main.async {
            self.hostVC.storesCollectionView.reloadData()
          if let store = list.store {
            self.hostVC.configData(data: store)
          }
            self.hostVC.storesCollectionView.layoutIfNeeded()
            self.hostVC.updateCollectionsHeight()

          self.hostVC.noProductsFoundLabel.isHidden = !(self.singleStoresSection?.allProduct?.data?.isEmpty ?? false)
        }
        }
    }
}
