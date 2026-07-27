//
//  ViewAllProductVM.swift
//  DesynatUser
//
//  Created by Chandra Prakash on 27/07/26.
//

import Foundation
import UIKit

class ViewAllProductVM: NSObject {
    
    private var hostVC: ViewAllProductVC
    var searchText: String = ""
    var limit: String = "10"
    var selectedCategoryIDs: [String] = []
    var selectedSubCategoryIDs: Int = -1
    var selectedBrandIDs: [String] = []
    var selectedColorIDs: [String] = []
    var selectedSizeIDs: [String] = []
    var selectedDiscountIDs: [String] = []
    var selectedRatings: [String] = []
    var selectedDeliveryTime: [String] = []
    var minPrice: Int?
    var maxPrice: Int?
    var bestSellingProductsList: [BestSellingProductsDataModel] = []
    var topRatedProductsList: [TopRatedDataModel] = []
    var currentPage = 1
    var totalPages = 1
    var isLoading = false
    var isPagination = false
    
    init(hostVC: ViewAllProductVC) {
        self.hostVC = hostVC
    }
    
    func resetPagination() {
        currentPage = 1
        totalPages = 1
        isPagination = false

        if hostVC.accessibilityHint == "Best Selling" {
            bestSellingProductsList.removeAll()
        } else {
            topRatedProductsList.removeAll()
        }
    }
    
    func getBestSellingApi() {

        guard !isLoading else { return }
        guard currentPage <= totalPages else { return }

        isLoading = true

        var param: [String: Any] = [
            "page": currentPage,
            "limit": limit
        ]

        if selectedSubCategoryIDs != -1 {
            param["subcategory_id"] = selectedSubCategoryIDs
        }

        if !selectedCategoryIDs.isEmpty { param["category_id"] = selectedCategoryIDs }
        if !selectedBrandIDs.isEmpty { param["brand_id"] = selectedBrandIDs }
        if !selectedColorIDs.isEmpty { param["color_id"] = selectedColorIDs }
        if !selectedSizeIDs.isEmpty { param["size_id"] = selectedSizeIDs }
        if !selectedDiscountIDs.isEmpty { param["discount"] = selectedDiscountIDs }
        if !selectedRatings.isEmpty { param["rating"] = selectedRatings }
        if !selectedDeliveryTime.isEmpty { param["delivery_time"] = selectedDeliveryTime }

        if let minPrice = minPrice {
            param["price_min"] = minPrice
        }

        if let maxPrice = maxPrice {
            param["price_max"] = maxPrice
        }

        if !searchText.isEmpty {
            param["search"] = searchText
        }

        if let sort = hostVC.appliedSortFilter {
            param["sort_filter"] = sort
        }

        WebService.sharedInstance.getBestSellingListService(param: param) { list in

            self.isLoading = false

            self.totalPages = list.allProduct?.lastPage ?? 1

            let products = list.allProduct?.data ?? []

            if self.currentPage == 1 {
                self.bestSellingProductsList = products
            } else {
                self.bestSellingProductsList.append(contentsOf: products)
            }

            DispatchQueue.main.async {

                self.hostVC.noProductsFoundLabel.isHidden = !self.bestSellingProductsList.isEmpty

                self.hostVC.storesCollectionView.reloadData()
            }
        }
    }
    
    func getTopSellingApi() {

        guard !isLoading else { return }
        guard currentPage <= totalPages else { return }

        isLoading = true

        var param: [String: Any] = [
            "page": currentPage,
            "limit": limit
        ]

        if selectedSubCategoryIDs != -1 {
            param["subcategory_id"] = selectedSubCategoryIDs
        }

        if !selectedCategoryIDs.isEmpty { param["category_id"] = selectedCategoryIDs }
        if !selectedBrandIDs.isEmpty { param["brand_id"] = selectedBrandIDs }
        if !selectedColorIDs.isEmpty { param["color_id"] = selectedColorIDs }
        if !selectedSizeIDs.isEmpty { param["size_id"] = selectedSizeIDs }
        if !selectedDiscountIDs.isEmpty { param["discount"] = selectedDiscountIDs }
        if !selectedRatings.isEmpty { param["rating"] = selectedRatings }
        if !selectedDeliveryTime.isEmpty { param["delivery_time"] = selectedDeliveryTime }

        if let minPrice = minPrice {
            param["price_min"] = minPrice
        }

        if let maxPrice = maxPrice {
            param["price_max"] = maxPrice
        }

        if !searchText.isEmpty {
            param["search"] = searchText
        }

        if let sort = hostVC.appliedSortFilter {
            param["sort_filter"] = sort
        }

        WebService.sharedInstance.getTopRatingListService(param: param) { list in

            self.isLoading = false

            self.totalPages = list.allProduct?.lastPage ?? 1

            let products = list.allProduct?.data ?? []

            if self.currentPage == 1 {
                self.topRatedProductsList = products
            } else {
                self.topRatedProductsList.append(contentsOf: products)
            }

            DispatchQueue.main.async {

                self.hostVC.noProductsFoundLabel.isHidden = !self.topRatedProductsList.isEmpty

                self.hostVC.storesCollectionView.reloadData()
            }
        }
    }
    
    func getProducts() {
        if hostVC.accessibilityHint == "Best Selling" {
            getBestSellingApi()
        } else {
            getTopSellingApi()
        }
    }
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["product_id": productId]
        WebService.sharedInstance.addToWishelistSercie(param: param) { list in
            completion(true)
        }
    }
}
