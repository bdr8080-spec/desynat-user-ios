//
//  SavedAddressViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//

import Foundation
import UIKit

class SavedAddressViewModel: NSObject {
    
    private var hostVC: SavedAddressViewController
    var savedAddressList:[SavedAddressList] = []

    
    init(hostVC: SavedAddressViewController) {
        self.hostVC = hostVC
    }
    
    func getSavedAddressListAPI(){
        WebService.sharedInstance.getSavedAddressList { [self] list in
            self.savedAddressList = list
            self.hostVC.savedAddressTableView.reloadData()
            self.hostVC.noDataFoundLabel.isHidden = !savedAddressList.isEmpty
            
        }
    }
    
    func deleteAddressAPI(addressID: Int, completion: @escaping (Bool) -> Void) {
        WebService.sharedInstance.deleteAddressAPi(addressId: addressID ) { response in
            completion(true)
        }
    }

    
}


