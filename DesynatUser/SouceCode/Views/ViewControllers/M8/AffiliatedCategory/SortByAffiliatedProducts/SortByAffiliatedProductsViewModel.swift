//
//  SortByAffiliatedProductsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import Foundation
import UIKit

class SortByAffiliatedProductsViewModel {
    
    private var hostVC: SotByAffiliatedProductsViewController
    var sortedStoreList: [SortByStoreDataModel]?
    
    init(hostVC: SotByAffiliatedProductsViewController) {
        self.hostVC = hostVC
    }
    
    func getSortListOfAffilatedProductsApi() {
        WebService.sharedInstance.getSortListOfAffiliatedProductsService() { list in
            DispatchQueue.main.async {
                self.sortedStoreList = list
                self.hostVC.setupOptions()
            }
        }
    }
}
