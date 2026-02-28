//
//  SearchAffiliatedProductViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import Foundation

class SearchAffiliatedProductsViewModel {
    
    private var hostVC: SearchAffiliatedProductsViewController?
    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true
    var productDetails: [AffiliatedProductsList] = []
    var searchText: String = ""
    var attributeText: [String] = []
//    var selectedCategoryIDs: [String] = []
    var selectedBrandIDs: [String] = []
    var selectedColorIDs: [String] = []
    var selectedSizeIDs: [String] = []
    var selectedDiscountIDs: [String] = []
    var minPrice: Int?
    var maxPrice: Int?
    
    init(hostVC: SearchAffiliatedProductsViewController? = nil) {
        self.hostVC = hostVC
    }
    
    func generateProductLink(productId: Int) {
        let params: [String: Any] = ["product_id": productId]
        WebService.shared.geenerateProductLinkService(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let nextVC = AffiliatedCopyLinkViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                nextVC.productLink = response.link ?? ""
                nextVC.productID = productId
                nextVC.onAddToProduct = {
                    self.resetAndFetchProducts()
                }
                self.hostVC?.navigationController?.present(nextVC, animated: true)
            }
        }
    }
    
    func getAllProducts(reset: Bool = false) {
        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            productDetails.removeAll()
            hostVC?.storesCollectionView.reloadData()
        }
        guard !isFetching, hasMorePages else { return }
        isFetching = true
        var param: [String: Any] = ["page": currentPage,
                                    "subcategory_id": [hostVC?.subCatrgoryId],
                                    "category_id": [hostVC?.categoryId],
                                    "limit": 20]
        if !attributeText.isEmpty { param["attributes_data"] = attributeText }
        if !searchText.isEmpty { param["search"] = searchText }
        if let sort = hostVC?.appliedSortFilter { param["sort_filter"] = sort }
//        if !selectedCategoryIDs.isEmpty { param["category_id"] = selectedCategoryIDs }
        if !selectedBrandIDs.isEmpty { param["brand_id"] = selectedBrandIDs }
        if let minPrice = minPrice { param["price_min"] = minPrice }
        if let maxPrice = maxPrice { param["price_max"] = maxPrice }
        if !selectedColorIDs.isEmpty { param["color_id"] = selectedColorIDs }
        if !selectedSizeIDs.isEmpty { param["size_id"] = selectedSizeIDs }
        if !selectedDiscountIDs.isEmpty { param["discount"] = selectedDiscountIDs }
        
        WebService.shared.getSearchProductsService(param: param) { [weak self] response in
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
                self.hostVC?.storesCollectionView.reloadData()
                self.hostVC?.noProductFoundLabel.isHidden = !self.productDetails.isEmpty
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
