//
//  FavouirtesVieModel.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import Foundation
import UIKit

class FavouirtesVieModel: NSObject {
    
    private var hostVC: FavoruitesViewController!
  var favouritesList: [FavoruitesDataModel]?
  
  
    init(hostVC: FavoruitesViewController) {
        self.hostVC = hostVC
    }

    func getProductDetails() {
          WebService.sharedInstance.getWishlistService() { list in
              self.favouritesList = list
            self.hostVC.favouriteTableView.reloadData()
        }
    }
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
      let param: [String: Any] = ["product_id": productId]
      WebService.sharedInstance.addToWishelistSercie(param: param) { list in
          completion(true)
        }
    }

}
