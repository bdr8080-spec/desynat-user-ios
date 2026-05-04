//
//  CMSWebServices.swift
//  DesynatUser
//
//  Created by  shailendra singh on 17/04/26.
//

import Foundation
import Foundation
import UIKit
import Alamofire

extension WebService {
    
    func getTermsConditionService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.termsAndCondition),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    func getReturnPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.returnPolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getAboutUsPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.aboutUs),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    func getCancellationPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.cancellationPolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getExchangePolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.exchangePolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    
    
    func getFaqService(parameter:[String:Any],completion: @escaping([FAQListDataModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getFAQ),requestMethod: .get, requestParams: parameter,requestModel: [FAQListDataModel].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    func updatePushNotificationSettingService(completion: @escaping(NotificationDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.pushNotificationOnOff),requestMethod: .post, requestModel: NotificationDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func updateInAppNotificationSettingService(completion: @escaping(NotificationDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.inAppNotificationOnOff),requestMethod: .post, requestModel: NotificationDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getSavedCardsService(completion: @escaping([SavedCardsDataModel]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMySavedCards), requestMethod: .get, requestModel: [SavedCardsDataModel].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func  deleteSavedCardsService(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteSavedCards), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func AddNewCardsService(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addNewCard), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
}
