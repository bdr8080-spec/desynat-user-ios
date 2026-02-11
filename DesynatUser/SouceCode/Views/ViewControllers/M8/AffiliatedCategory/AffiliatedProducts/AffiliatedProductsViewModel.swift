//
//  AffiliatedProductsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import Foundation

class AffiliatedProductsViewModel {
    
    private var hostVC: AffiliatedProductsViewController
    var productDetails: [ProductList]?
    var searchText: String = ""
    
    init(hostVC: AffiliatedProductsViewController) {
        self.hostVC = hostVC
    }
    
    func getProductsApi() {
        var param: [String: Any] = [:]
        if !searchText.isEmpty { param["search"] = searchText }
        WebService.sharedInstance.homeSearch(param: param) { list in
            self.productDetails = list.data
            DispatchQueue.main.async {
                self.hostVC.productsCollectionView.reloadData()
                self.hostVC.productsCollectionView.layoutIfNeeded()
                self.hostVC.noDataFoundLabel.isHidden = !(self.productDetails?.isEmpty ?? false)
            }
        }
    }
}
