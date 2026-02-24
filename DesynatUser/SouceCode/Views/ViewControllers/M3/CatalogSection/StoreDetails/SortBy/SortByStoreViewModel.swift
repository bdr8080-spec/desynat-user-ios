//
//  SortByStoreViewModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation
import UIKit

class SortByStoreViewModel {
    
    private var hostVC: SortByStoresViewController
    var sortedStoreList: [SortByStoreDataModel]?
    
    init(hostVC: SortByStoresViewController) {
        self.hostVC = hostVC
    }
    
    func getSingleStoresApi() {
        WebService.sharedInstance.getSortByStoreListService() { list in
            DispatchQueue.main.async {
                self.sortedStoreList = list
                self.hostVC.setupOptions()
                
            }
        }
    }
}
