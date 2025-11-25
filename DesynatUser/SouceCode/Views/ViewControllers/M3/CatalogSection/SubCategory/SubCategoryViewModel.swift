//
//  SubCategoryViewModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation
import UIKit

class SubCategoryViewModel: NSObject {
    
    private var hostVC: SubCatgoryViewController
    var subCategoriesSection:[SubCategoriesDataModel] = []
    
    init(hostVC: SubCatgoryViewController) {
        self.hostVC = hostVC
    }
    
    func getSubCategoriesListApi(categoryID: Int) {
        WebService.sharedInstance.getSubCategoriesService(categoryID: categoryID) { list in
            self.subCategoriesSection = list
            DispatchQueue.main.async {
                self.hostVC.subCatgeoryTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.subCategoriesSection.isEmpty
            }
        }
    }
}

