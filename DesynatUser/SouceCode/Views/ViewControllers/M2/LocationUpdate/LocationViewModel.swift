//
//  LocationViewModel.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//


import Foundation
import SDWebImage

class LocationViewModel: NSObject {
    private var hostVC: LocationViewController
    
    init(hostVC: LocationViewController) {
        self.hostVC = hostVC
    }
    
//    func locationRequest(completion: (() -> Void)? = nil) {
//        let fullAddress = hostVC.lblLocation.text ?? ""
//        let latitude = hostVC.latitude ?? 0.0
//        let longitude = hostVC.longitude ?? 0.0
//        let params: [String: Any] = [
//            "fulladdress": fullAddress,
//            "latitude": latitude,
//            "longitude": longitude
//        ]
//        WebService.sharedInstance.locationServices(withParams: params){ (response) in
//            completion?()
//        }
//    }
    
}

