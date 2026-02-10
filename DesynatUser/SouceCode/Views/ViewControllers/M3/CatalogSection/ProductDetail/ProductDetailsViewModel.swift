//
//  ProductDetailsViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 25/11/25.
//

import Foundation
import UIKit

class ProductDetailsViewModel: NSObject {
    
    private var hostVC: ProductDetailViewController!
    var singleStoresSection: SingleStoreDetailsDataModel?
    var searchText: String = ""
    
    init(hostVC: ProductDetailViewController) {
        self.hostVC = hostVC
    }
    
    func getProductDetails() {
        let param: [String: Any] = ["product_id": hostVC.productId ?? 0]
        WebService.sharedInstance.getProductDetailsService(param: param) { list in
            WebService.sharedInstance.getProductDetailsService(param: param) { list in
                
                self.hostVC.productDetails = list
                self.hostVC.prepareVariantData()
                self.hostVC.noDataFoundLabel.isHidden = (list.review?.isEmpty == false)
            }
        }
    }
    
    func addToWishlist(productId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["product_id": productId]
        WebService.sharedInstance.addToWishelistSercie(param: param) { list in
            completion(true)
        }
    }
    
    func addToCart(productId: Int, variantId: Int, quantity: Int, forIncrement: Bool, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = [
            "product_id": productId,
            "variants_id": variantId,
            "quantity": forIncrement ? 1 : -1 //quantity
        ]
        WebService.sharedInstance.addToCart(param: param) { list in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Product Added to Cart Succesfully")
            }
            completion(true)
        }
    }
    
    func buyNow(productId: Int, variantId: Int, quantity: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = [
            "product_id": productId,
            "variants_id": variantId,
            "quantity":  1
        ]
        WebService.sharedInstance.addToCart(param: param) { list in
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Product Added to Cart Succesfully")
            }
            completion(true)
        }
    }
    
    func createCustomOrder(productId: Int, variantId: Int) {
        let param: [String: Any] = [
            "product_id": productId,
            "variation_id": variantId]
        WebService.sharedInstance.createCustomOrder(param: param) { list in
            DispatchQueue.main.async {
                let nextVC = ChatDetailsViewController.instantiate(fromAppStoryboard: .Chat)
                nextVC.viewModel.chatDetailsUniqueId = list.uniqueID ?? ""
                nextVC.comingFromChatInbox = false
                self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
}
