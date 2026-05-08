//
//  AffiliatedUserProductViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import Foundation

class AffiliatedUserProductViewModel {
    
    private var hostVC: AffiliatedUserProductViewController
    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true
    var subCategoriesSection: [SubCategoriesDataModel] = []
    var categoriesSection:[CategoriesDataModel] = []
    var searchText: String = ""
    var productDetails: [AffiliatedUserMyProductsList] = []
    var searchWorkItem: DispatchWorkItem?
    
    init(hostVC: AffiliatedUserProductViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi() {
        WebService.sharedInstance.getCategoriesService { [weak self] list in
            guard let self = self else { return }
            var updatedList = list
            let allCategory = CategoriesDataModel(
                id: -1,
                name: "All",
                nameAr: "الكل",
                description: nil,
                image: nil,
                status: 1,
                colorCode: nil,
                createdAt: nil,
                updatedAt: nil
            )
            updatedList.insert(allCategory, at: 0)
            self.categoriesSection = updatedList
            self.hostVC.selectedCatrgoryId = categoriesSection.first?.id ?? 0
            self.hostVC.categoryCollectionView.reloadData()
        }
    }
    
    func getSubCategoriesListApi(categoryID: Int) {
        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { [weak self] list in
            guard let self = self else { return }
            self.subCategoriesSection.append(contentsOf: list)
            self.hostVC.subCatgeoryCollectionView.reloadData()
        }
    }
    
    func getAllSubCategoriesService() {
        WebService.sharedInstance.getAllSubCategoriesService() { [weak self] list in
            guard let self = self else { return }
            self.subCategoriesSection.append(contentsOf: list)
            self.hostVC.subCatgeoryCollectionView.reloadData()
        }
    }
    
    func getAllProducts(reset: Bool = false) {
        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            productDetails.removeAll()
            hostVC.productCollectionView.reloadData()
        }
        guard !isFetching, hasMorePages else { return }
        isFetching = true
        var params: [String: Any] = ["page": currentPage, "limit": 20]
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if hostVC.selectedCatrgoryId > 0 {
            params["category_id"] = hostVC.selectedCatrgoryId
        }
        
        if hostVC.selectedSubCatrgoryId > 0 {
            params["subcategory_id"] = hostVC.selectedSubCatrgoryId
        }
        
        WebService.shared.getMyProductsListService(param: params) { [weak self] response in
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
                self.hostVC.productCollectionView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.productDetails.isEmpty
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
