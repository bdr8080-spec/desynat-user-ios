//
//  AffiliatedCategorySearchViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import Foundation

class AffiliatedCategorySearchViewModel {
    
    private var hostVC: AffiliatedCategorySearchViewController
    var latestSearchData: [AffiliatedLatestSearch] = []
    var searchProductsData: [AffiliatedLatestSearch] = []
    
    init(hostVC: AffiliatedCategorySearchViewController) {
        self.hostVC = hostVC
    }
    
    func getLatestSearchData() {
        WebService.sharedInstance.getAffiliatedLatestSearchService { data in
            DispatchQueue.main.async {
                self.latestSearchData = data
                self.hostVC.latestSearchCollectionView.reloadData()
                self.hostVC.updateLatestSearchCollectionHeight()
                self.hostVC.noLatesSearchFoundLabel.isHidden = !data.isEmpty
            }
        }
    }
    
    func getSearchProducts() {
        WebService.sharedInstance.getAffiliatedSearchProductsService { data in
            DispatchQueue.main.async {
                self.searchProductsData = data
                self.hostVC.lblNoRecentData.isHidden = !data.isEmpty
                self.hostVC.RecentSearchTableView.reloadData()
            }
        }
    }
    
}
