//
import Foundation
import UIKit
import Alamofire

extension WebService {
    
    func uploadFile(withParams file:MultipartUpload,
                    completion:@escaping (_ url:String, _ msg:String?, _ code:HTTPStatusCode?)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.requestMultiPart(url: .endpoint(.uploadFile), assets: [file], model: UploadFileDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let url = response?.url {
                    completion(url, message, code)
                } else if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                }
            }
        }
    }
    
    func uploadFileForPdfImageVideoGif(withParams file:MultipartUpload,
                    completion:@escaping (_ url:String, _ msg:String?, _ code:HTTPStatusCode?)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.requestMultiPartForPdfImageVideoGif(url: .endpoint(.uploadFile), assets: [file], model: UploadFileDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let url = response?.url {
                    completion(url, message, code)
                } else if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                }
            }
        }
    }
    
    func getProfileService(completion:@escaping (_ user:UserModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.viewProfile), requestMethod: .get,requestModel:UserModel.self) { result, code in
            
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
    
    func changeMobileNumberService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: ChangeMobileNumModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.changeMobileNumber), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: ChangeMobileNumModel.self) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    CommonUtils.showToast(message: "Otp sent succesfully".localiz())
                    completion(response)
                }
            }
        }
    }
    
    func userVerifyOtpService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.userVerifyOtp), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func updateProfileService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: UserModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateProfile), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: UserModel.self) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                } else if let response {
                    Global.shared.user = response
                    kSharedUserDefaults.saveModelFor(key: .user, value: response)
                    CommonUtils.showToast(message:message ?? "")
                    completion(response)
                }
            }
        }
    }
    
    func changePasswordService(withParams dictParams: Dictionary<String, Any>, completion: @escaping (_ user: EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.changePassword), requestMethod: .post, requestParams: dictParams, encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func singleChatDetails(param: [String: Any], completion:@escaping (_ user: ChatDetailsDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSingleChats), requestMethod: .post, requestParams: param, requestModel:ChatDetailsDataModel.self) { result, code in
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
    
    func markAllchatThread(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markAllchatThread), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func acceptAndRejectOrderQuotationDetails(param: [String: Any], completion:@escaping (_ user: ChatDetailsDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.acceptAndRejectQuotation), requestMethod: .post, requestParams: param, requestModel:ChatDetailsDataModel.self) { result, code in
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
    
    func sendNotificationDetails(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.sendNotification), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getAllChatsList(param: [String: Any], completion:@escaping (_ user: [ChatInboxListModel])-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllChatsRecord), requestMethod: .post, requestParams: param, requestModel:[ChatInboxListModel].self) { result, code in
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
    
    func getAllChatsCount(completion:@escaping (_ user: [ChatInboxListModel])-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllChatsRecord), requestMethod: .post, requestModel:[ChatInboxListModel].self) { result, code in
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
    
    func createCustomOrderRequest(param: [String: Any], completion:@escaping (_ user: CustomOrderPlaceOrderDetail)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.createCustomOrderRequest), requestMethod: .post, requestParams: param, requestModel: CustomOrderPlaceOrderDetail.self) { result, code in
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
    
    func CustomOrderAddToCardService(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.CustomOrderAddToCard), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getMyNotificationsListService(param: [String:Any], completion: @escaping(NotificationsListDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyNotificationsList),requestMethod: .get, requestParams: param, requestModel: NotificationsListDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func markReadNotificationsService(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markReadNotifications),requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func markAllReadNotificationsService(param: [String:Any], completion: @escaping(EmptyModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markAllReadNotifications),requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            Shimmer.shared.show(show: false)
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

