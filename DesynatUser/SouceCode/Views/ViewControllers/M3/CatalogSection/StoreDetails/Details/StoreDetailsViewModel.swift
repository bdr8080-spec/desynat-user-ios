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
    var selectedCategoryIDs: [String] = []
    var selectedBrandIDs: [String] = []
    var selectedColorIDs: [String] = []
    var selectedSizeIDs: [String] = []
    var selectedDiscountIDs: [String] = []
    var minPrice: Int?
    var maxPrice: Int?
    
    init(hostVC: StoresDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func getSingleStoresApi() {
        
        var param: [String: Any] = [
            "store_id": hostVC.storeId ?? 0
        ]
        
        if !selectedCategoryIDs.isEmpty { param["category_id"] = selectedCategoryIDs }
        if !selectedBrandIDs.isEmpty { param["brand_id"] = selectedBrandIDs }
        if !selectedColorIDs.isEmpty { param["color_id"] = selectedColorIDs }
        if !selectedSizeIDs.isEmpty { param["size_id"] = selectedSizeIDs }
        if !selectedDiscountIDs.isEmpty { param["discount_range_id"] = selectedDiscountIDs }
        
        if let minPrice = minPrice { param["price_min"] = minPrice }
        if let maxPrice = maxPrice { param["price_max"] = maxPrice }
        
        if !searchText.isEmpty { param["search"] = searchText }
        if let sort = hostVC.appliedSortFilter { param["sort_filter"] = sort }
        
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
    
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["product_id": productId]
        WebService.sharedInstance.addToWishelistSercie(param: param) { list in
            completion(true)
        }
    }
    
    func createNormalChatSercie(sellerId: Int) {
        let param: [String: Any] = ["seller_id": sellerId]
        WebService.sharedInstance.createNormalChatSercie(param: param) { list in
            DispatchQueue.main.async {
                let nextVC = ChatDetailsViewController.instantiate(fromAppStoryboard: .Chat)
                nextVC.viewModel.chatDetailsUniqueId = list.uniqueID ?? ""
                nextVC.comingFromChatInbox = false
                self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
