//
//  AffiliatedUserCategoriesViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import Foundation

class AffiliatedUserCategoriesViewModel: NSObject {
    
    private var hostVC: AffiliatedUserCategoriesViewController
    
    var subCategoriesSection: [SubCategoriesDataModel] = []      // filtered list
    private var originalSubCategories: [SubCategoriesDataModel] = [] // full list
    var categoriesSection:[CategoriesDataModel] = []
    
    init(hostVC: AffiliatedUserCategoriesViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi(){
        WebService.sharedInstance.getCategoriesService { [self] list in
            self.categoriesSection = list
            self.getSubCategoriesListApi(categoryID: list.first?.id ?? 0)
            self.hostVC.categoriesCollectionView.reloadData()
            
        }
    }
    
    func getSubCategoriesListApi(categoryID: Int) {
        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { list in
            self.originalSubCategories = list
            self.subCategoriesSection = list
            DispatchQueue.main.async {
                self.hostVC.subCatgeoiresListCollectionView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.subCategoriesSection.isEmpty
            }
        }
    }
    
    // MARK: - Local Search
    func filterSubCategories(with text: String) {
        if text.isEmpty {
            subCategoriesSection = originalSubCategories
        } else {
            subCategoriesSection = originalSubCategories.filter {
              $0.nameEnglish?.lowercased().contains(text.lowercased()) ?? false
            }
        }
        
        hostVC.noDataFoundLabel.isHidden = !subCategoriesSection.isEmpty
        hostVC.subCatgeoiresListCollectionView.reloadData()
    }
}
