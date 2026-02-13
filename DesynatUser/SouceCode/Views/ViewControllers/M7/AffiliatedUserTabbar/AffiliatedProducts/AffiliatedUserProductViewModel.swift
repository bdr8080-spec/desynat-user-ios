//
//  AffiliatedUserProductViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import Foundation

class AffiliatedUserProductViewModel {
    
    private var hostVC: AffiliatedUserProductViewController
    var subCategoriesSection: [SubCategoriesDataModel] = []
    var categoriesSection:[CategoriesDataModel] = []
    
    init(hostVC: AffiliatedUserProductViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi() {
        WebService.sharedInstance.getCategoriesService { [weak self] list in
            guard let self = self else { return }

            var updatedList = list

            // Default "All" Category
            let allCategory = CategoriesDataModel(
                id: 0,
                name: "All",
                description: nil,
                image: nil,
                status: 1,
                colorCode: nil,
                createdAt: nil,
                updatedAt: nil
            )

            updatedList.insert(allCategory, at: 0)

            self.categoriesSection = updatedList
            
            // Load subcategories for "All"
            self.getSubCategoriesListApi(categoryID: list.first?.id ?? 0)
            
            self.hostVC.categoryCollectionView.reloadData()
        }
    }

    
    func getSubCategoriesListApi(categoryID: Int) {
        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { [weak self] list in
            guard let self = self else { return }

            var updatedList = list

            // Default "All" SubCategory
            let allSubCategory = SubCategoriesDataModel(
                id: 0,
                categoryID: categoryID,
                nameEnglish: "All",
                nameArabic: "الكل",
                image: nil,
                status: 1,
                createdAt: nil,
                updatedAt: nil
            )

            updatedList.insert(allSubCategory, at: 0)

            self.subCategoriesSection = updatedList
            
            self.hostVC.subCatgeoryCollectionView.reloadData()
        }
    }

}
