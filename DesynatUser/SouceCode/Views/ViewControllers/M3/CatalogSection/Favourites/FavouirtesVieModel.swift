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
    var productList: [FavoruitesDataModel]? = []
    var reelsList: [GetMyWislistDataModelForReels]? = []
    
    init(hostVC: FavoruitesViewController) {
        self.hostVC = hostVC
    }
    
    func getProductDetails() {
        WebService.sharedInstance.getWishlistService { list in
            self.productList = list
            let isEmpty = self.productList?.isEmpty ?? true
            self.hostVC.emptyLabel.text = isEmpty ? "No product found".localiz() : ""
            self.hostVC.emptyLabel.isHidden = !isEmpty
            self.hostVC.favouriteCollectionView.reloadData()
        }
    }
    
    func getReelsWishlistRequest() {
        WebService.sharedInstance.getReelsWishlistService { list in
            self.reelsList = list
            let isEmpty = self.reelsList?.isEmpty ?? true
            self.hostVC.emptyLabel.text = isEmpty ? "No reels found".localiz() : ""
            self.hostVC.emptyLabel.isHidden = !isEmpty
            self.hostVC.favouriteCollectionView.reloadData()
        }
    }
    
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["product_id": productId]
        WebService.sharedInstance.addToWishelistSercie(param: param) { list in
            completion(true)
        }
    }
    
    func shareReelsRequest(reelId: Int, completion: @escaping (String?) -> Void) {

        let param = ["reel_id": reelId]

        WebService.shared.shareReelsService(param: param) { response in
            // Assuming API returns:  { "link": "https://..." }
            let link = response.file ?? ""
            completion(link)
        }
    }
    
    func addToReelsWishelistRequest(reelId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["reel_id": reelId]
        WebService.sharedInstance.addToReelsWishelistSercie(param: param) { list in
            completion(true)
        }
    }
    
}
