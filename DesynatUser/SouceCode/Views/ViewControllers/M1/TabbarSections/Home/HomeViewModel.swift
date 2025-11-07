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
    
    var selectedCategoriesSection = 0 {
        didSet {
            self.getSubCategoriesListApi(categoryID: selectedCategoriesSection)
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
}

