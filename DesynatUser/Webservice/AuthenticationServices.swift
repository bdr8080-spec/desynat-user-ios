//
//  AuthenticationServices.swift
//  CruzeUserApp
//

import Foundation
import UIKit
import Alamofire

extension WebService {
    
    static let shared = WebService()
    
    func registerUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.register), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    Global.shared.user = response
                    kSharedUserDefaults.saveModelFor(key: .user, value: response)
                    kSharedUserDefaults.saveStringFor(Key: .accessToken, value: response.accessToken)
                    CommonUtils.showToast(message: "OTP sent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func verifyOTPService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.verifyOTP), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    Global.shared.user = response
                    kSharedUserDefaults.saveModelFor(key: .user, value: response)
                    kSharedUserDefaults.saveStringFor(Key: .accessToken, value: response.accessToken)
                    CommonUtils.showToast(message: "OTP sent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func resendOTPService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.resendOtp), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToast(message: "OTP resent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func loginUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.loginUser), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    Global.shared.user = response
                    kSharedUserDefaults.saveModelFor(key: .user, value: response)
                    kSharedUserDefaults.saveStringFor(Key: .accessToken, value: String.getString(response.accessToken))
                    CommonUtils.showToast(message: message ?? "Login Successfully")
                    completion(response)
                }
            }
        }
    }
    
    func loginUserViaOTPService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.loginUserViaOTP), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    Global.shared.user = response
                    kSharedUserDefaults.saveModelFor(key: .user, value: response)
                    kSharedUserDefaults.saveStringFor(Key: .accessToken, value: String.getString(response.accessToken))
                    CommonUtils.showToast(message: "OTP sent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func countryListService(completion:@escaping (_ user:[CountryModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.country), requestMethod: .get,requestModel:[CountryModel].self) { result, code in
            
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
    
    func forgotPasswordService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.forgotPassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    DispatchQueue.main.async {
                        CommonUtils.showToast(message: "OTP sent successfully")
                    }
                    completion(response)
                }
            }
        }
    }
    
    func createPasswordService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createPassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    completion(response)
                }
            }
        }
    }
    
    func logoutService(completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.logout), requestMethod: .get, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func getCategoriesService(completion:@escaping (_ user:[CategoriesDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getCategory), requestMethod: .get,requestModel:[CategoriesDataModel].self) { result, code in
            
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
    
    func getBrandsService(completion:@escaping (_ user:[AllBrandsListData])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllBrands), requestMethod: .get,requestModel:[AllBrandsListData].self) { result, code in
            
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
    
    func getColorsService(completion:@escaping (_ user:[AllColorsList])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllColors), requestMethod: .get,requestModel:[AllColorsList].self) { result, code in
            
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
    
    func getSizeService(completion:@escaping (_ user:[AllSizesList])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllSizes), requestMethod: .get,requestModel:[AllSizesList].self) { result, code in
            
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
    
    func getAllSubCategoriesService(completion:@escaping (_ user:[SubCategoriesDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        let endPoint = NetworkURL.custom("api/user/sub-category")
        NetworkManager.shared.request(withAPI: endPoint, requestMethod: .get,requestModel:[SubCategoriesDataModel].self) { result, code in
            
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
    
    func getSubCategoriesService(categoryID: Int, completion:@escaping (_ user:[SubCategoriesDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        let endPoint = NetworkURL.custom("api/user/sub-category?category_id=\(categoryID)")
        NetworkManager.shared.request(withAPI: endPoint, requestMethod: .get,requestModel:[SubCategoriesDataModel].self) { result, code in
            
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
    
    func getStoresListService(param: [String: Any], completion:@escaping (_ user:[StoreListDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.categoryWiseStoreList), requestMethod: .post,requestParams: param, requestModel:[StoreListDataModel].self) { result, code in
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
    
    func getSingleStoresListService(param: [String: Any], completion:@escaping (_ user:SingleStoreDetailsDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.singleStoreDetails), requestMethod: .post,requestParams: param, requestModel:SingleStoreDetailsDataModel.self) { result, code in
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
    
    func getSortByStoreListService(completion:@escaping (_ user:[SortByStoreDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.sortStoreFilter), requestMethod: .get, requestModel:[SortByStoreDataModel].self) { result, code in
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
    
    func addToWishelistSercie(param: [String: Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addToWishlist), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getProductDetailsService(param: [String: Any], completion:@escaping (_ user:ProductDetailsDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.productDetails), requestMethod: .post,requestParams: param, requestModel:ProductDetailsDataModel.self) { result, code in
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
    
    
    func getWishlistService(completion:@escaping (_ user:[FavoruitesDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getWishlist), requestMethod: .get, requestModel:[FavoruitesDataModel].self) { result, code in
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
    
    func addToCart(param: [String: Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addToCart), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func incrementDecrement(param: [String: Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.incrementDecrement), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    
    func gteBagDetails(completion:@escaping (_ user:MyCartDetailsDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.cartDetailsList), requestMethod: .get, requestModel: MyCartDetailsDataModel.self) { result, code in
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
    
    func getSavedAddressList(completion:@escaping (_ user:[SavedAddressList])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getSavedAddress), requestMethod: .get,requestModel:[SavedAddressList].self) { result, code in
            
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
    
    func deleteAddressAPi(addressId: Int, completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        let endPoint = NetworkURL.custom("api/user/delete-address/\(addressId)")
        NetworkManager.shared.request(withAPI: endPoint, requestMethod: .delete,requestModel:EmptyModel.self) { result, code in
            
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
    
    func makeAddressDefaultAPi(addressId: Int, completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        let param: [String:Any] = ["address_id": addressId]
        NetworkManager.shared.request(withAPI: .endpoint(.setDeafultAddress), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
            
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
    
    func addAddressAPi(param: [String: Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        
        NetworkManager.shared.request(withAPI: .endpoint(.addNewAddress), requestMethod: .post,  requestParams: param ,requestModel:EmptyModel.self) { result, code in
            
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
    
    func editAddressAPi(param: [String: Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        
        NetworkManager.shared.request(withAPI: .endpoint(.editAddress), requestMethod: .put,  requestParams: param ,requestModel:EmptyModel.self) { result, code in
            
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
    
    func getAllUserscountryList(completion:@escaping (_ user:[GetAllUserCountryModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.allUserCountry), requestMethod: .get,requestModel:[GetAllUserCountryModel].self) { result, code in
            
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
    
    func getAllGiftCardsList(param: [String: Any], completion:@escaping (_ user:[GiftCardsListDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllCards), requestMethod: .post,requestParams: param, requestModel:[GiftCardsListDataModel].self) { result, code in
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
    
    func getAllGiftCardsOccassionList(completion:@escaping (_ user:[GiftCardsDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllOccassion), requestMethod: .get, requestModel:[GiftCardsDataModel].self) { result, code in
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
    
    func addGiftCardsApi(param: [String: Any], completion:@escaping (_ user: GiftCardAddedDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addGiftCards), requestMethod: .post, requestParams: param, requestModel:  GiftCardAddedDataModel.self) { result, code in
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
    
    func paymentForGiftCardsApi(param: [String: Any], completion:@escaping (_ user: PaymentMethodForCardAdditionDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.paymentForGiftCard), requestMethod: .post, requestParams: param, requestModel:  PaymentMethodForCardAdditionDataModel.self) { result, code in
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
    
    func paymentForAddMoneyInWalletApi(param: [String: Any], completion:@escaping (_ user: PaymentMoneyInWalletMoneyDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addMoneyInWallet), requestMethod: .post, requestParams: param, requestModel:  PaymentMoneyInWalletMoneyDataModel.self) { result, code in
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
    
    func completePaymentForAddMoneyInWalletApi(param: [String: Any], completion:@escaping (_ user: PaymentMoneyInWalletMoneyDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.completeAddMoneyWallet), requestMethod: .post, requestParams: param, requestModel:  PaymentMoneyInWalletMoneyDataModel.self) { result, code in
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
    
    func getAllPromocodeListApi(param: [String: Any], completion:@escaping (_ user: [GetPromoCodeListDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllPromocodeList), requestMethod: .post, requestParams: param, requestModel:  [GetPromoCodeListDataModel].self) { result, code in
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
    
    func applyPromocodeApi(param: [String: Any], completion:@escaping (_ user: PromocodeApplied)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.applyPromocode), requestMethod: .post, requestParams: param, requestModel:  PromocodeApplied.self) { result, code in
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
    
    func placeOrderApi(param: [String: Any], completion:@escaping (_ user: OrderPlaceDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createOrder), requestMethod: .post, requestParams: param, requestModel:  OrderPlaceDataModel.self) { result, code in
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
    
    func addGiftCardApi(param: [String: Any], completion:@escaping (_ user: UseGiftCardDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.applyGiftCard), requestMethod: .post, requestParams: param, requestModel:  UseGiftCardDataModel.self) { result, code in
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
    
    func redeemGiftCardWallet(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.redeemGiftCardWallet), requestMethod: .post, requestParams: param, requestModel:  EmptyModel.self) { result, code in
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
    
    func getOrderSummary(param: [String: Any], completion:@escaping (_ user: OrderSummaryDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.singleOrderSummary), requestMethod: .post, requestParams: param, requestModel:  OrderSummaryDataModel.self) { result, code in
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
    
    func completeOrderApi(param: [String: Any], completion:@escaping (_ user: OrderPlaceDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.completePayment), requestMethod: .post, requestParams: param, requestModel:  OrderPlaceDataModel.self) { result, code in
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
    
    func getWalletAmount(completion:@escaping (_ user: WalletAmountDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getWalletAmount), requestMethod: .get, requestModel:  WalletAmountDataModel.self) { result, code in
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
    
    func getOrdersApi(param: [String: Any], completion: @escaping (_ user: [OrderModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getOrders), requestMethod: .post, requestParams: param, requestModel: [OrderModel].self) { result, code in
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
    
    func getOrderDetail(param: [String: Any], completion: @escaping (_ user: OrderModel)-> Void) {
        Shimmer.shared.show(show: true)
        //    CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.singleOrderSummary), requestMethod: .post, requestParams: param, requestModel: OrderModel.self) { result, code in
            //      CommonUtils.showHud(show: false)
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
    
    func getOrderDetailInvoice(param: [String: Any], completion: @escaping (_ user: String)-> Void) {
        //    CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.singleOrderSummaryInvoice), requestMethod: .post, requestParams: param, requestModel: String.self) { result, code in
            //      CommonUtils.showHud(show: false)
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
    
    func cancelOrder(param: [String: Any], completion: @escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.cancelProduct), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func rejectReason(param: [String: Any], completion: @escaping (_ user: [RejectReasonModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.rejectReason), requestMethod: .post, requestParams: param, requestModel: [RejectReasonModel].self) { result, code in
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
    
    func orderReturnEx(param: [String: Any], completion: @escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.OrderReturnEx), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getRecentSearch(completion: @escaping (_ user: [RecentDataModel] )-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.recentSearch), requestMethod: .get, requestModel: [RecentDataModel].self) { result, code in
            
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
    
    func getRecommendedSearch(completion: @escaping (_ user: [RecommenedeSearch] )-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.recommendedSearch), requestMethod: .get, requestModel: [RecommenedeSearch].self) { result, code in
            
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
    
    func homeSearch(param: [String: Any], completion: @escaping (_ user: SearchModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.homeSearch), requestMethod: .post, requestParams: param, requestModel: SearchModel.self) { result, code in
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
    
    func addRatingToOrderSercie(param: [String: Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.orderRating), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getAllFullscreenBannersList(completion:@escaping (_ user:[FullscreenBannersList])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.homeFullScreenBanner), requestMethod: .post, requestModel:[FullscreenBannersList].self) { result, code in
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
    
    func createNormalChatSercie(param: [String: Any], completion:@escaping (_ user:CreateChatThreadWithDealer)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.sendInMessageChatNormalChat), requestMethod: .post, requestParams: param, requestModel:CreateChatThreadWithDealer.self) { result, code in
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
    
    func createCustomOrder(param: [String: Any], completion:@escaping (_ user: CreateChatThreadWithDealer)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createCustomOrder), requestMethod: .post, requestParams: param, requestModel: CreateChatThreadWithDealer.self) { result, code in
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
    
    func sendCustomOrderRequest(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.sendCustomOrderRequest), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self) { result, code in
            
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
    
    func getHomeScreenAllBannersListService(param: [String:Any], completion:@escaping (_ user:[HomescreenBannersList])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllHomeScreenBannersList), requestMethod: .post, requestParams: param, requestModel:[HomescreenBannersList].self) { result, code in
            
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
    
    func getHomeScreenAllDealListService(param: [String:Any], completion:@escaping (_ user:[HomeBottomBannerForDeals])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.userGetHomeDealBanner), requestMethod: .post, requestParams: param, requestModel:[HomeBottomBannerForDeals].self) { result, code in
            
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
    
    func createAffiliatedAccountService(param: [String:Any], completion:@escaping (_ user: AffiliateCreateAccountDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.createAffiliatedAccountUser), requestMethod: .post, requestParams: param, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
            
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
    
    func reuploadDocumnetsAffiliatedAccountService(param: [String:Any], completion:@escaping (_ user: AffiliateCreateAccountDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        NetworkManager.shared.request(withAPI:.endpoint(.reverifyDocument), requestMethod: .post, requestParams: param, requestModel: AffiliateCreateAccountDataModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
            
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
    
    func verifyAffiliatedAccountService(param: [String:Any], completion:@escaping (_ user: AffiliateCreateAccountDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.verifyAffiliatedAccountUser), requestMethod: .post, requestParams: param, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
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
    
    func addAddressAffiliatedAccountService(param: [String:Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        NetworkManager.shared.request(withAPI:.endpoint(.affilatedAddAddress), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
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
    
    func addBankDetailsAffiliatedUserService(param: [String:Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        let affiliatedAccessToken = kSharedUserDefaults.getStringFor(key: .affiliatedAccessToken)
        NetworkManager.shared.request(withAPI:.endpoint(.affilatedAddBankDetails), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self, affiliatedUserToken: affiliatedAccessToken) { result, code in
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
    
    func resendOTPServiceForAffiliatedUser(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: AffiliateCreateAccountDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.resendOTPAffiliatedUser), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToast(message: "OTP resent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func loginWithPasswordForAffiliatedUser(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: AffiliateCreateAccountDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.affiliatedLoginWithPassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    //            CommonUtils.showToast(message: "OTP resent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func affiliatedLoginWithOTPService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: AffiliateCreateAccountDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.affiliatedLoginWithOTP), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToast(message: "OTP resent succesfully")
                    completion(response)
                }
            }
        }
    }
    
    func forgotPasswordForAffiliatedUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: AffiliateCreateAccountDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.affiliatedForgotPassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    DispatchQueue.main.async {
                        CommonUtils.showToast(message: "OTP sent successfully")
                    }
                    completion(response)
                }
            }
        }
    }
    
    func createPasswordForAffiliatedUserService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: AffiliateCreateAccountDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.affiliatedCreatePassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: AffiliateCreateAccountDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    completion(response)
                }
            }
        }
    }
    
    func getWalletHistorySerivice(completion: @escaping (_ user: WalletMoneyHistoryDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getWalletHistory), requestMethod: .get, encoding: JSONEncoding.default, requestModel: WalletMoneyHistoryDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    completion(response)
                }
            }
        }
    }
    
    func removeCustomOrderFromCartSerivice(param: [String: Any], completion: @escaping (_ user: EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.CustomOrderRemoveFromCard), requestMethod: .post, requestParams: param, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    completion(response)
                }
            }
        }
    }
}
