//
//  AffiliatedUserWebServices.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation
import UIKit
import Alamofire
extension WebService {
    
    func getAffiliatedProfileService(completion:@escaping (_ user: AffiliateCreateAccountDataModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAffiliateProfile), requestMethod: .get, requestModel:AffiliateCreateAccountDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func updateAffiliatedProfileService(param: [String: Any], completion:@escaping (_ user: AffiliateCreateAccountDataModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updatedAffiliateProfile), requestMethod: .post, requestParams: param,  requestModel: AffiliateCreateAccountDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func updateAffiliatedAddressService(param: [String: Any], completion:@escaping (_ user: AffiliateCreateAccountDataModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updatedAffiliateAddress), requestMethod: .post, requestParams: param,  requestModel: AffiliateCreateAccountDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    
    func updateAffiliatedBankDetailsService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updatedAffiliateBankDetails), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func addAffiliatedBankDetailsService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addAffiliateBankDetails), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func deleteBankAccountAffilaitedUserService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteAffiliateBankDetails), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func makeDefaultBankAccountAffilaitedUserService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.makeDefualtAffiliateBankDetails), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func changePasswordOfAffilaitedUserService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateAffiliateUserPassword), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getAllAffilliatedUserProductsService(param: [String: Any], completion:@escaping (_ user: AffiliatedProductsDataModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllAffiliateUserProduct), requestMethod: .get, requestParams: param,  requestModel: AffiliatedProductsDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func geenerateProductLinkService(param: [String: Any], completion:@escaping (_ user: GenerateProductLink)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.generateProductLink), requestMethod: .post, requestParams: param,  requestModel: GenerateProductLink.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func addProductToMyProductsService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addProductToMyProducts), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getAffiliatedLatestSearchService(completion:@escaping (_ user: [AffiliatedLatestSearch])-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getLatestSearchData), requestMethod: .get,  requestModel: [AffiliatedLatestSearch].self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getAffiliatedSearchProductsService(completion:@escaping (_ user: [AffiliatedLatestSearch])-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getRecentSearchData), requestMethod: .get,  requestModel: [AffiliatedLatestSearch].self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getSearchProductsService(param: [String: Any], completion:@escaping (_ user: AffiliatedProductsDataModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAffiliatedProductSearchData), requestMethod: .post, requestParams: param,  requestModel: AffiliatedProductsDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getSortListOfAffiliatedProductsService(completion:@escaping (_ user: [SortByStoreDataModel])-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.productfilterKeys), requestMethod: .get,  requestModel: [SortByStoreDataModel].self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getMyProductsListService(param: [String:Any], completion:@escaping (_ user: AffiliatedUserMyProductsDataModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyProducts), requestMethod: .get, requestParams: param,  requestModel: AffiliatedUserMyProductsDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getMyProductsDetailsService(param: [String:Any], completion:@escaping (_ user: AffiliatedUserMyProductsList)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyProductDetails), requestMethod: .get, requestParams: param,  requestModel: AffiliatedUserMyProductsList.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func deleteProductsDetailsService(param: [String:Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteMyProductDetails), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func changeMobileNumberForAffiliateUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: ChangeMobileNumModel) -> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.changeMobileNumberForAffiliatedUser), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: ChangeMobileNumModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToast(message: "Otp sent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func userVerifyOtpForAffiliateUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.userVerifyOtpForAffiliatedUser), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToast(message:message ?? "")
                    completion(response)
                }
            }
        }
    }
    
}
