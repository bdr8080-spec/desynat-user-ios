//
//  AffiliatedProductsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import Foundation

class AffiliatedProductsViewModel {
    
    private var hostVC: AffiliatedProductsViewController
    var productDetails: [AffiliatedProductsList] = []
    var searchText: String = ""
    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true
    
    init(hostVC: AffiliatedProductsViewController) {
        self.hostVC = hostVC
    }
    
    func getAllProducts(reset: Bool = false) {
        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            productDetails.removeAll()
            hostVC.productsCollectionView.reloadData()
        }
        guard !isFetching, hasMorePages else { return }
        isFetching = true
        var params: [String: Any] = [
            "category_id": hostVC.categoryId,
            "subcategory_id": hostVC.subCatrgoryId,
            "page": currentPage,
            "limit": 6]
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        WebService.shared.getAllAffilliatedUserProductsService(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                let data = response.data ?? []
                if reset {
                    self.productDetails = data
                } else {
                    self.productDetails.append(contentsOf: data)
                }
                self.lastPage = response.lastPage ?? 1
                self.hasMorePages = self.currentPage < self.lastPage
                if self.hasMorePages {
                    self.currentPage += 1
                }
                self.hostVC.productsCollectionView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.productDetails.isEmpty
            }
        }
    }
    
    func generateProductLink(productId: Int) {
        let params: [String: Any] = ["product_id": productId]
        WebService.shared.geenerateProductLinkService(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let nextVC = AffiliatedCopyLinkViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                nextVC.productLink = response.link ?? ""
                nextVC.productID = productId
                self.hostVC.navigationController?.present(nextVC, animated: true)
            }
        }
    }
    
    func resetAndFetchProducts() {
        currentPage = 1
        lastPage = 1
        isFetching = false
        hasMorePages = true
        productDetails.removeAll()
        getAllProducts(reset: true)
    }
}
