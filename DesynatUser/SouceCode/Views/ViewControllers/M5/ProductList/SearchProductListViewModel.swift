//
//  SearchProductListViewModel.swift
//  DesynatUser
//
//  Created by fluper on 24/12/25.
//

import Foundation

class SearchProductListViewModel {
    
    private var hostVC: SearchProductListViewController?
    var productDetails: [ProductList]?
    var searchText: String = ""
    var attributeText: [String] = [""]
    var selectedCategoryIDs: [String] = []
    var selectedBrandIDs: [String] = []
    var selectedColorIDs: [String] = []
    var selectedSizeIDs: [String] = []
    var selectedDiscountIDs: [String] = []
    var selectedRatings: [String] = []
    var selectedDelivertTime: [String] = []
    var minPrice: Int?
    var maxPrice: Int?
    
    init(hostVC: SearchProductListViewController? = nil) {
        self.hostVC = hostVC
    }
    
    func getProductsApi() {
        var param: [String: Any] = [:]
      if !attributeText.isEmpty { param["attributes_data"] = attributeText }
        if !searchText.isEmpty { param["search"] = searchText }
        if let sort = hostVC?.appliedSortFilter { param["sort_filter"] = sort }
        if !selectedCategoryIDs.isEmpty { param["category_id"] = selectedCategoryIDs }
        if !selectedBrandIDs.isEmpty { param["brand_id"] = selectedBrandIDs }
        if let minPrice = minPrice { param["price_min"] = minPrice }
        if let maxPrice = maxPrice { param["price_max"] = maxPrice }
        if !selectedColorIDs.isEmpty { param["color_id"] = selectedColorIDs }
        if !selectedSizeIDs.isEmpty { param["size_id"] = selectedSizeIDs }
        if !selectedDiscountIDs.isEmpty { param["discount"] = selectedDiscountIDs }
        
        WebService.sharedInstance.homeSearch(param: param) { list in
            self.productDetails = list.data
            DispatchQueue.main.async {
                self.hostVC?.storesCollectionView.reloadData()
                self.hostVC?.storesCollectionView.layoutIfNeeded()
                self.hostVC?.noProductFoundLabel.isHidden = !(self.productDetails?.isEmpty ?? false)
            }
        }
    }
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["product_id": productId]
        WebService.sharedInstance.addToWishelistSercie(param: param) { list in
            completion(true)
        }
    }

}
