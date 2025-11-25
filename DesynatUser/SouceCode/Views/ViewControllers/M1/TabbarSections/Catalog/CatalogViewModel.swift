//
//  CatalogViewModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation

class CatalogViewModel: NSObject {
    
    private var hostVC: CatalogViewController
    var categoriesSection:[CategoriesDataModel] = []
    
    init(hostVC: CatalogViewController) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi(){
        WebService.sharedInstance.getCategoriesService { [self] list in
            self.categoriesSection = list
            self.hostVC.catalogTableView.reloadData()
            
        }
    }
    
}

