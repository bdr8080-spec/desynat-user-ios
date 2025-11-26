//
//  MyBagViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//

import Foundation
import UIKit

class MyBagViewModel: NSObject {
    
    private var hostVC: MyBagViewController
    var bagDetails: MyCartDetailsDataModel?
    
    init(hostVC: MyBagViewController) {
        self.hostVC = hostVC
    }
    
    func gteBagDetailsApi(){
        WebService.sharedInstance.gteBagDetails { [self] list in
            self.bagDetails = list
            self.hostVC.bagTableView.reloadData()
            self.hostVC.condifData(data: list)
            self.hostVC.noDataFoundLabel.isHidden = !(self.bagDetails?.cartData?.isEmpty ?? true)
            self.hostVC.bagDetailsView.isHidden = self.bagDetails?.cartData?.isEmpty ?? true
        }
    }
    
    func handleIncrementDecrement(cartID: Int, type: String, index: Int) {
        
        let param: [String: Any] = [
            "cart_id": "\(cartID)",
            "type": type   // increment/decrement
        ]
        WebService.sharedInstance.incrementDecrement(param: param) { [weak self] list in
            guard let self = self else { return }
            if type == "increment" {
                self.bagDetails?.cartData?[index].quantity += 1
            } else {
                let current = self.bagDetails?.cartData?[index].quantity ?? 1
                if current > 1 {
                    self.bagDetails?.cartData?[index].quantity -= 1
                }
            }
            
            DispatchQueue.main.async {
                self.hostVC.bagTableView.reloadData()
                self.hostVC.viewWillLayoutSubviews()
            }
        }
    }
}

