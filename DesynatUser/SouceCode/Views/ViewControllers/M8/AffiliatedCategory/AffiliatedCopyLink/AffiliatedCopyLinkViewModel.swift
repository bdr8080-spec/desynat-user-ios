//
//  AffiliatedCopyLinkViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation

class AffiliatedCopyLinkViewModel {
    
    private var hostVC: AffiliatedCopyLinkViewController
    
    init(hostVC: AffiliatedCopyLinkViewController) {
        self.hostVC = hostVC
    }
    
    func addProductToMyProduct() {
        let params: [String: Any] = ["product_id": hostVC.productID]
        WebService.shared.addProductToMyProductsService(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CommonUtils.showToast(message: "Product is added to my products successfully")
                self.hostVC.onAddToProduct?()
                self.hostVC.dismiss(animated: true)
            }
        }
    }

}
