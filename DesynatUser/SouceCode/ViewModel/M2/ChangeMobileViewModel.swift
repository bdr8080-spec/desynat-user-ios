//
//  ChangeMobileViewModel.swift
//  DesynatUser
//
//  Created by Mohd Faizan on 07/11/25.
//

import Foundation
import UIKit

class ChangeMobileViewModel:NSObject{
    private var hostVC:ChangeMobileViewController
    
    init(hostVC: ChangeMobileViewController) {
        self.hostVC = hostVC
    }
    
    //Mark->:changeMobileNumberApi
    func changeMobileNumberAndEmailApi(){
        var param:[String:Any] = [:]
        
        if hostVC.comingToUpdateMobile == true{
            param = [
                "for":"mobile",
                "country_code":self.hostVC.countryCode,
                "mobile":self.hostVC.txtMobileNumber.text ?? "",
                "type":"1"
                
            ]
        }else{
            param = [
                "for":"email",
                "email":self.hostVC.txtEmail.text ?? "",
                "type":"1"
                
            ]
        }
           
        WebService.sharedInstance.changeMobileNumberService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            if self.hostVC.comingToUpdateMobile {
                vc.comingReason = .setNewMobileNumber
            } else {
                vc.comingReason = .setNewEmail
            }
            vc.id = "\(user.id ?? 0)"
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
