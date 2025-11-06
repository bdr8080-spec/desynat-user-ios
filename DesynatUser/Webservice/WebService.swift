import Foundation
import UIKit

class WebService {
    static let sharedInstance = WebService()
    
    typealias ResultHandler<T:Decodable> = (Result<T, NetworkError>) -> Void
    
    func evaluateWebServiceResponse<T: Decodable>(response: Result<BaseResponse<T>, NetworkError>,
                                                  completion:((_ response:T?, _ message:String?, _ error:String?)->())?) {
        
        switch response {
        case .success(let model):
            completion?(model.data, model.message, nil)
        case .failure(let err):
            switch err {
            case .invalidResponse(let errorResponse):
                if let errorResponse {
                    completion?(nil, nil, getPrintableError(err: errorResponse))
                } else {
                    completion?(nil, nil, err.localizedDescription)
                }
            case .sessionExpired:
                UIApplication.shared.topViewController()?.showAlert(msg: AlertConstant.sessionExpired.value().localiz(), completion: {
                    kSharedSceneDelegate.logoutUser()
                })
                break
                
            default:
                completion?(nil, nil, err.localizedDescription)
            }
        }
    }
    
    private func getPrintableError(err:ErrorResponse) -> String? {
        var msg = ""
        if let title = err.message {
            msg = title
        }
        if let details = err.detail {
            let detail = details.map({$0.message})
            detail.forEach { error in
                if let error {
                    msg += "\n"
                    msg += error
                }
            }
        }
        return msg
    }
    
//    private func getPrintableError(err: ErrorResponse) -> String? {
//        var msg = ""
//
//        // ✅ Try message, msg, or error
//        if let message = err.message, !message.isEmpty {
//            msg = message
//        } else if let title = err.msg, !title.isEmpty {
//            msg = title
//        } else if let error = err.error, !error.isEmpty {
//            msg = error
//        }
//
//        // ✅ Also include details if present
//        if let details = err.detail {
//            let detailMessages = details.compactMap { $0.msg }.joined(separator: "\n")
//            if !detailMessages.isEmpty {
//                msg += msg.isEmpty ? detailMessages : "\n" + detailMessages
//            }
//        }
//
//        // ✅ Final fallback
//        if msg.isEmpty {
//            msg = "Something went wrong. Please try again."
//        }
//
//        return msg
//    }

}
