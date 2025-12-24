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
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.singleOrderSummary), requestMethod: .post, requestParams: param, requestModel: OrderModel.self) { result, code in
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
}











