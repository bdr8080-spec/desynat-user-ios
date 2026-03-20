//
//  HomeViewModel.swift
//  DesynatUser
//
//  Created by fluper on 07/11/25.
//

import Foundation
import UIKit

class HomeViewModel: NSObject {
    
    private var hostVC: HomeViewController
    var categoriesSection:[CategoriesDataModel] = []
    var subCategoriesSection:[SubCategoriesDataModel] = []
    var fullScreenBannersList: [FullscreenBannersList]?
    var homeScreenAllBannersList: [HomescreenBannersList] = []
    var homeCenterScreenAllBannersList: [HomescreenBannersList] = []
    var homeBottomDealAllBannersList: [HomeBottomBannerForDeals] = []
    
    var selectedCategoriesSection = 0 {
        didSet {
            self.getSubCategoriesListApi(categoryID: selectedCategoriesSection)
            self.getBottomHomeDealBannersListApi()
        }
    }
    
    init(hostVC: HomeViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi(){
        WebService.sharedInstance.getCategoriesService { [self] list in
            self.categoriesSection = list
            self.hostVC.categoriesSectionCollectionView.reloadData()
            self.selectedCategoriesSection = categoriesSection.first?.id ?? 0
            
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
}

