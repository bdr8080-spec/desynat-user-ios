//
//  SubCategoryViewModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation
import UIKit
//
//class SubCategoryViewModel: NSObject {
//    
//    private var hostVC: SubCatgoryViewController
//    var subCategoriesSection:[SubCategoriesDataModel] = []
//    
//    init(hostVC: SubCatgoryViewController) {
//        self.hostVC = hostVC
//    }
//    
//    func getSubCategoriesListApi(categoryID: Int) {
//        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { list in
//            self.subCategoriesSection = list
//            DispatchQueue.main.async {
//                self.hostVC.subCatgeoryTableView.reloadData()
//                self.hostVC.noDataFoundLabel.isHidden = !self.subCategoriesSection.isEmpty
//            }
//        }
//    }
//}
//


class SubCategoryViewModel: NSObject {
    
    private var hostVC: SubCatgoryViewController
    
    var subCategoriesSection: [SubCategoriesDataModel] = []      // filtered list
    private var originalSubCategories: [SubCategoriesDataModel] = [] // full list
    
    init(hostVC: SubCatgoryViewController) {
        self.hostVC = hostVC
    }
    
    func getSubCategoriesListApi(categoryID: Int) {
        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { list in
            self.originalSubCategories = list
            self.subCategoriesSection = list
            
            DispatchQueue.main.async {
                self.hostVC.subCatgeoryTableView.reloadData()
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
        hostVC.subCatgeoryTableView.reloadData()
    }
}
