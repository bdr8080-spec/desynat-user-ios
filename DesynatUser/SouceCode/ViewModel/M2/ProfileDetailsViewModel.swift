//
//  ProfileDetailsViewModel.swift
//  DesynatUser
//
//  Created by Mohd Faizan on 07/11/25.
//

import Foundation
import UIKit

class ProfileDetailsViewModel:NSObject{
    private var hostVC:ProfileDetailsViewController
    
    init(hostVC: ProfileDetailsViewController) {
        self.hostVC = hostVC
    }
    
    //Mark->:GetProfileDetailsApi
    func getProfileDetailsApi(){
        WebService.sharedInstance.getProfileService { user in
            self.hostVC.imgProfile.sd_setImage(with:URL(string:user.profileImage ?? ""), placeholderImage:UIImage(named:""))
            self.hostVC.email = user.email
            self.hostVC.countryCode = user.countryCode ?? ""
            self.hostVC.mobile = user.mobile
            self.hostVC.txtFullName.text = user.fullName
            self.hostVC.txtMobileNumber.text = user.mobile
            self.hostVC.txtCountryCode.text = user.countryCode
            self.hostVC.txtEmail.text = user.email
        }
    }
    
    //Mark->:uploadDocument
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
    //Mark->:changeMobileNumberApi
    func changeMobileNumberApi(){
        let param:[String:Any] = [
               "for":"mobile",
               "country_code":self.hostVC.txtCountryCode.text ?? "",
               "mobile":self.hostVC.txtMobileNumber.text ?? "",
               "type":"0"
               
           ]
       
        WebService.sharedInstance.changeMobileNumberService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .changeOldMobileNumber
            vc.id = "\(user.id ?? 0)"
            vc.callBackForProfileDetails = { mobile,countryCode,_ in
                self.hostVC.txtMobileNumber.text = mobile
                self.hostVC.txtCountryCode.text = countryCode
                print("mobile:\(mobile)")
                print("countryCode:\(countryCode)")
            }
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    //Mark->:changeEmailApi
    func changeEmailApi(){
        let param:[String:Any] = [
               "for":"email",
               "email":self.hostVC.txtEmail.text ?? "",
               "type":"0"
               
           ]
         
        WebService.sharedInstance.changeMobileNumberService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .changeOldEmail
            vc.id = "\(user.id ?? 0)"
            vc.callBackForProfileDetails = { _, _, email in
                self.hostVC.txtEmail.text = email
                print("email:\(email)")
            }
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func updateProfileApi(){
        let param:[String:Any] = [
            "full_name":self.hostVC.txtFullName.text ?? "",
            "image":self.hostVC.selectedProfileImageUrl,
            "country_code":self.hostVC.txtCountryCode.text ?? "",
            "mobile":self.hostVC.txtMobileNumber.text ?? "",
            "email":self.hostVC.txtEmail.text ?? ""
        ]
        WebService.sharedInstance.updateProfileService(withParams:param) { user in
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
}
