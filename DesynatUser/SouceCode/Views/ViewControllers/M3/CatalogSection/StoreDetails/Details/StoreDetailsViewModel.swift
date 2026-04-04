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
    var sellerHighlights: [GetHighLightsList] = []
    var sellerReels: [GetMyReelsList] = []
    
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
                self.getSellerHighlightsService(sellerId: list.store?.sellerID ?? 0)
                self.getSellerStory(sellerId: list.store?.sellerID ?? 0)
                if let store = list.store {
                    self.hostVC.configData(data: store)
                }
                DispatchQueue.main.async {
                    self.hostVC.storesCollectionView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.hostVC.storesCollectionView.layoutIfNeeded()
                        self.hostVC.storesCollectionViewHeightConstraint.constant =
                        self.hostVC.storesCollectionView.collectionViewLayout.collectionViewContentSize.height
                    }
                }
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
    
    func getSellerHighlightsService(sellerId: Int) {
        let param: [String: Any] = ["seller_id": sellerId]
        WebService.sharedInstance.getSellerHighlightsService(param: param) { list in
            self.sellerHighlights = list
            self.hostVC.storiesCollectionView.reloadData()
        }
    }
    
    func getSellerReelsService(sellerId: Int) {
        let param: [String: Any] = ["seller_id": sellerId]
        WebService.sharedInstance.getSellerReelsService(param: param) { list in
            self.sellerReels = list
            DispatchQueue.main.async {
                self.hostVC.reelsCollectionView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.hostVC.reelsCollectionView.layoutIfNeeded()
                    self.hostVC.storesCollectionViewHeightConstraint.constant =
                    self.hostVC.reelsCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.hostVC.reelsCollectionViewHeightConstriant.constant =
                    self.hostVC.reelsCollectionView.collectionViewLayout.collectionViewContentSize.height
                }
            }
        }
    }
    
    func addToReelsWishelistRequest(reelId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["reel_id": reelId]
        WebService.sharedInstance.addToReelsWishelistSercie(param: param) { list in
            completion(true)
        }
    }
    
    func getSellerStory(sellerId: Int) {
        let param: [String:Any] = ["seller_id": sellerId]
        WebService.sharedInstance.getSellerStoryService(param: param) { list in
            if list.count > 0 {
                self.hostVC.userProfileImage.borderWidth = 1.5
                self.hostVC.sellerProfileButton.isUserInteractionEnabled = true
            } else {
                self.hostVC.sellerProfileButton.isUserInteractionEnabled = false
                self.hostVC.userProfileImage.borderWidth = 0
            }
        }
    }
    
    func shareReelsRequest(reelId: Int, completion: @escaping (String?) -> Void) {
        let param = ["reel_id": reelId]
        WebService.shared.shareReelsService(param: param) { response in
            let link = response.file ?? ""
            completion(link)
        }
    }
}
