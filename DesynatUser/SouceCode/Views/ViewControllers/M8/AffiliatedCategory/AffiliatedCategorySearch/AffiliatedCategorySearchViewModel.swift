//
//  AffiliatedCategorySearchViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import Foundation

class AffiliatedCategorySearchViewModel {
    
    private var hostVC: AffiliatedCategorySearchViewController
    
    init(hostVC: AffiliatedCategorySearchViewController) {
        self.hostVC = hostVC
    }
    
//    func getLatestSearchData() {
//        WebService.sharedInstance.getRecommendedSearch { data in
//            DispatchQueue.main.async {
//                self.hostVC.recommendedData = data
//                self.hostVC.noReconmmendedDataFoundLAbel.isHidden = !data.isEmpty
//                self.hostVC.recommendedCollectionView.reloadData()
//                self.hostVC.recommendedCollectionView.layoutIfNeeded()
//            }
//        }
//    }
    
//    func getSearchProducts() {
//        WebService.sharedInstance.getRecentSearch { data in
//            DispatchQueue.main.async {
//                self.hostVC.recentData = data
//                self.hostVC.lblNoRecentData.isHidden = !data.isEmpty
//                self.hostVC.noLatesSearchFoundLabel.isHidden = !data.isEmpty
//                self.hostVC.RecentSearchTableView.reloadData()
//                self.hostVC.latestSearchCollectionView.reloadData()
//                self.hostVC.updateLatestSearchCollectionHeight()
//            }
//        }
//}

}
