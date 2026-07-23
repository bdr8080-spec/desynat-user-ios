//
//  HomeViewModel.swift
//  DesynatUser
//
//  Created by fluper on 07/11/25.
//

import Foundation
import UIKit
import _LocationEssentials
import CoreLocation

class HomeViewModel: NSObject {
    
    private var hostVC: HomeViewController
    var categoriesSection:[CategoriesDataModel] = []
    var subCategoriesSection:[SubCategoriesDataModel] = []
    var fullScreenBannersList: [FullscreenBannersList]?
    var homeScreenAllBannersList: [HomescreenBannersList] = []
    var homeCenterScreenAllBannersList: [HomescreenBannersList] = []
    var homeBottomDealAllBannersList: [HomeBottomBannerForDeals] = []
    var suggestedStoresList: [SuggestedStoresDataModel] = []
    var bestSellingProductsList: [BestSellingProductsDataModel] = []
    var topRatedProductsList: [TopRatedDataModel] = []
    var newestProductsList: [TopRatedDataModel] = []
    var allCategories: [CategorySectionModel] = []
    
    var selectedCategoriesSection = 0 {
        didSet {
            self.getSubCategoriesListApi(categoryID: selectedCategoriesSection)
            self.getBottomHomeDealBannersListApi()
        }
    }
    
    init(hostVC: HomeViewController) {
        self.hostVC = hostVC
    }
    
//    func getCategoriesListApi(){
//        WebService.sharedInstance.getCategoriesService { [self] list in
//            self.categoriesSection = list
//            self.hostVC.categoriesSectionCollectionView.reloadData()
//            self.selectedCategoriesSection = categoriesSection.first?.id ?? 0
//            
//        }
//    }
    
    func getCategoriesListApi() {

        // Static categories (always visible)
        allCategories = [
            CategorySectionModel(
                id: 1,
                name: "Men",
                nameAr: "الرجال",
                isEnabled: false
            ),
            CategorySectionModel(
                id: 2,
                name: "Women",
                nameAr: "النساء",
                isEnabled: false
            ),
            CategorySectionModel(
                id: 3,
                name: "Kids",
                nameAr: "أطفال",
                isEnabled: false
            )
        ]

        WebService.sharedInstance.getCategoriesService { [weak self] list in

            guard let self = self else { return }

            // Store original API list if needed
            self.categoriesSection = list

            // First disable all
            self.allCategories.indices.forEach {
                self.allCategories[$0].isEnabled = false
            }

            // Enable categories coming from API
            for item in list {

                if let index = self.allCategories.firstIndex(where: {
                    $0.id == item.id
                }) {

                    self.allCategories[index].isEnabled = true
                }
            }

            // Default selected = first enabled category
            self.selectedCategoriesSection =
                self.allCategories.first(where: {
                    $0.isEnabled
                })?.id ?? 0

            self.hostVC.categoriesSectionCollectionView.reloadData()
        }
    }
    
    func getAdminStory() {
        WebService.sharedInstance.getAdminStoryService() { list in
            if list.count > 0 {
                self.hostVC.adminStoryProfile.image = .logo
                self.hostVC.adminstoryButtonOutlet.isUserInteractionEnabled = true
            } else{
                self.hostVC.adminStoryProfile.image = .adminStroyEmpty
                self.hostVC.adminstoryButtonOutlet.isUserInteractionEnabled = false
            }
            
        }
    }
    
    func getCountOfNotificationRequest(){
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            WebService.sharedInstance.getCountOfNotificationService { [self] response in
                let notificationCount = response.notificationCount ?? 0
                if notificationCount > 0 {
                    self.hostVC.notigicationView.isHidden = false
                    self.hostVC.notificationCountLabel.text = notificationCount.description
                } else {
                    self.hostVC.notigicationView.isHidden = true
                }
                let chatUnreadCount = response.chatUnreadCount ?? 0
                if chatUnreadCount > 0 {
                    self.hostVC.messageCountView.isHidden = false
                    self.hostVC.messageCountLabel.text = chatUnreadCount.description
                } else {
                    self.hostVC.messageCountView.isHidden = true
                }
            }
        }
    }
    
    func getSubCategoriesListApi(categoryID: Int) {
        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { list in
            self.subCategoriesSection = list
            DispatchQueue.main.async {
                self.hostVC.categoriesCollectionView.reloadData()
                self.hostVC.categoriesCollectionView.layoutIfNeeded()
                self.hostVC.heightConstraintOfCategoryColelctionView.constant = self.hostVC.categoriesCollectionView.contentSize.height
                self.hostVC.noCatgeoriesFoundLabel.isHidden = !self.subCategoriesSection.isEmpty
            }
        }
    }
    
    func getAllFullscreenBannersList() {
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            let hasShownFullscreenBanner = UserDefaults.standard.string(forKey: "hasShownFullscreenBanner") ?? "false"
            if hasShownFullscreenBanner == "true" {
                WebService.sharedInstance.getAllFullscreenBannersList() { list in
                    self.fullScreenBannersList = list
                    if !list.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            let nextVC = FullScreenBannerViewController.instantiate(fromAppStoryboard: .Home)
                            nextVC.viewModel.fullScreenBannersList = self.fullScreenBannersList
                            DispatchQueue.main.async {
                                self.hostVC.navigationController?.present(nextVC, animated: true) {
                                    UserDefaults.standard.set("false", forKey: "hasShownFullscreenBanner")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getTopHomeBannersListApi() {
        let param: [String: Any] = ["type": 1]
        WebService.sharedInstance.getHomeScreenAllBannersListService(param: param) { list in
            DispatchQueue.main.async {
                self.homeScreenAllBannersList = list
                self.hostVC.bannerCollectionView.reloadData()
                self.hostVC.bannerPageController.numberOfPages = self.homeScreenAllBannersList.count
            }
        }
    }
    
    func getCenterHomeBannersListApi() {
        let param: [String: Any] = ["type": 2]
        WebService.sharedInstance.getHomeScreenAllBannersListService(param: param) { list in
            DispatchQueue.main.async {
                self.homeCenterScreenAllBannersList = list
                self.hostVC.browsePrimiumCollectionView.reloadData()
                self.hostVC.browsePrimiumPageController.numberOfPages = self.homeCenterScreenAllBannersList.count
            }
        }
    }
    
    func getBottomHomeDealBannersListApi() {
        let param: [String: Any] = ["category": selectedCategoriesSection]
        WebService.sharedInstance.getHomeScreenAllDealListService(param: param) { list in
            DispatchQueue.main.async {
                self.homeBottomDealAllBannersList = list
                self.hostVC.bowseSomeDisCountCollectionView.reloadData()
                self.hostVC.browseDiscountPageController.numberOfPages = self.homeBottomDealAllBannersList.count
            }
        }
    }
    
    func getSuggestedStoresRequest() {
        WebService.sharedInstance.getSuggestedStoresListService() { list in
            DispatchQueue.main.async {
                self.suggestedStoresList = list
                self.hostVC.suggestedStoresCollectionView.isHidden = self.suggestedStoresList.isEmpty
                self.hostVC.noStoresFoundLabel.isHidden = !self.suggestedStoresList.isEmpty
                self.hostVC.suggestedStoresCollectionView.reloadData()
                self.hostVC.suggestedStoresCollectionView.layoutIfNeeded()
                self.hostVC.heightConstraintOfSuggestedStoreCollectionView.constant = self.hostVC.suggestedStoresCollectionView.contentSize.height
            }
        }
    }
    
    func getBestSellingProductsRequest() {
        WebService.sharedInstance.getBestSellingProductsListService() { list in
            DispatchQueue.main.async {
                self.bestSellingProductsList = list
                self.hostVC.bestSellingCollectionView.isHidden = self.bestSellingProductsList.isEmpty
                self.hostVC.noBestSellingDataFound.isHidden = !self.bestSellingProductsList.isEmpty
                self.hostVC.bestSellingCollectionView.reloadData()
            }
        }
    }
    
    func getTopRatedListRequest() {
        WebService.sharedInstance.getTopRatedListService() { list in
            DispatchQueue.main.async {
                self.topRatedProductsList = list
                self.hostVC.topRatedCollectionView.isHidden = self.topRatedProductsList.isEmpty
                self.hostVC.noTopRatedDataFoundLabel.isHidden = !self.topRatedProductsList.isEmpty
                self.hostVC.topRatedCollectionView.reloadData()
            }
        }
    }
    
    func getNewestProductListRequest() {
        WebService.sharedInstance.getNewestProductListService() { list in
            DispatchQueue.main.async {
                self.newestProductsList = list
                self.hostVC.newestProductsCollectionView.isHidden = self.newestProductsList.isEmpty
                self.hostVC.newestDataFoundLabel.isHidden = !self.newestProductsList.isEmpty
                self.hostVC.newestProductsCollectionView.reloadData()
                self.hostVC.newestProductsCollectionView.layoutIfNeeded()
                self.hostVC.heightConstraintOfNewestProductCollectionView.constant = self.hostVC.newestProductsCollectionView.contentSize.height
            }
        }
    }
    
    func handleWishlistTapForTopRated(index: Int) {
        let productId = topRatedProductsList[index].id ?? 0
        addToWishlist(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                var updatedProduct = self.topRatedProductsList[index]
                let newStatus = updatedProduct.wishlist == 1 ? 0 : 1
                updatedProduct.wishlist = newStatus
                self.topRatedProductsList[index] = updatedProduct
                DispatchQueue.main.async {
                    self.hostVC.topRatedCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    if newStatus == 1 {
                        CommonUtils.showToast(message: "Product added to wishlist".localiz())
                    } else {
                        CommonUtils.showToast(message: "Product removed from wishlist".localiz())
                    }
                }
            } else {
                print("Wishlist API Failed")
            }
        }
    }
    
    func handleWishlistTapForBestSelling(index: Int) {
        let productId = bestSellingProductsList[index].id ?? 0
        addToWishlist(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                var updatedProduct = self.bestSellingProductsList[index]
                let newStatus = updatedProduct.wishlist == 1 ? 0 : 1
                updatedProduct.wishlist = newStatus
                self.bestSellingProductsList[index] = updatedProduct
                DispatchQueue.main.async {
                    self.hostVC.bestSellingCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    if newStatus == 1 {
                        CommonUtils.showToast(message: "Product added to wishlist".localiz())
                    } else {
                        CommonUtils.showToast(message: "Product removed from wishlist".localiz())
                    }
                }
            } else {
                print("Wishlist API Failed")
            }
        }
    }
    
    func handleWishlistTapForNewestProduct(index: Int) {
        let productId = newestProductsList[index].id ?? 0
        addToWishlist(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                var updatedProduct = self.newestProductsList[index]
                let newStatus = updatedProduct.wishlist == 1 ? 0 : 1
                updatedProduct.wishlist = newStatus
                self.newestProductsList[index] = updatedProduct
                DispatchQueue.main.async {
                    self.hostVC.newestProductsCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    if newStatus == 1 {
                        CommonUtils.showToast(message: "Product added to wishlist".localiz())
                    } else {
                        CommonUtils.showToast(message: "Product removed from wishlist".localiz())
                    }
                }
            } else {
                print("Wishlist API Failed")
            }
        }
    }
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["product_id": productId]
        WebService.sharedInstance.addToWishelistSercie(param: param) { list in
            completion(true)
        }
    }
    
    func getAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
//                print("Geocode error:", error.localizedDescription)
                hostVC.lblLocatioin.text = "Address not found".localiz()
                return
            }
            
            if let place = placemarks?.first {
                let address = [
                    place.name,
                    place.locality,
                    place.administrativeArea,
                    place.country
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
                
                DispatchQueue.main.async {
                    self.hostVC.lblLocatioin.text = address
                }
            }
        }
    }
}

