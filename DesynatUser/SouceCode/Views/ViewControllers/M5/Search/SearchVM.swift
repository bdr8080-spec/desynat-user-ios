//
//  SearchVM.swift
//  DesynatUser
//
//  Created by fluper on 23/12/25.
//

import UIKit

class SearchVM: NSObject {
    private var hostVC: SearchVC
    
    init(hostVC: SearchVC) {
        self.hostVC = hostVC
    }
    
    func getRecommendedSearchData() {
        WebService.sharedInstance.getRecommendedSearch { data in
            DispatchQueue.main.async {
                self.hostVC.recommendedData = data
                self.hostVC.noReconmmendedDataFoundLAbel.isHidden = !data.isEmpty
                self.hostVC.recommendedCollectionView.reloadData()
                self.hostVC.recommendedCollectionView.layoutIfNeeded()
            }
        }
    }
    
    func getRecentData() {
        WebService.sharedInstance.getRecentSearch { data in
            DispatchQueue.main.async {
                self.hostVC.recentData = data
                self.hostVC.lblNoData.isHidden = !data.isEmpty
                self.hostVC.noLatesSearchFoundLabel.isHidden = !data.isEmpty
                
                self.hostVC.RecentSearchTableView.reloadData()
                self.hostVC.latestSearchCollectionView.reloadData()
                
                self.hostVC.updateLatestSearchCollectionHeight()
            }
        }
    }
    
    
//    func homeSearch() {
//        let params: [String: Any] = [:
//                                        //"search":"add"
//                                     // "sort_filter":"4"
//                                     // , "category_id": ["2"]
//                                     //  ,"brand_id": ["6"],
//                                     // "price_min":100,
//                                     // "price_max":500,
//                                     // "color_id": ["5", "6"],
//                                     // "size_id": ["5", "6"],
//                                     // "discount":10,
//                                     //  "category_id":["2"]
//        ]
//        
//        WebService.sharedInstance.homeSearch(param: params) { data in
//            print("")
//        }
//    }
}
