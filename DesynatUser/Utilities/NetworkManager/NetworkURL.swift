import Foundation

let kIsAppInstalled = "isAppInstalled"

enum BaseURL {
    static let development  = "http://157.241.119.72/"
    static let release      = "http://157.241.119.72/"
    
    static func value() -> String {
        switch BuildConfiguration.shared.environment {
        case .debug:
            return BaseURL.development
        case .release:
            return BaseURL.release
        }
    }
}

enum NetworkEndPoint: String {
    
    //M1 API
    case register                           = "api/register"
    case verifyOTP                          = "api/verify_otp"
    case loginUser                          = "api/login"
    case loginUserViaOTP                    = "api/login_by_mobile_or_email"
    case forgotPassword                     = "api/forgot_password"
    case createPassword                     = "api/create_password"
    case uploadFile                         = "api/upload"
    case resendOtp                          = "api/resend_otp"
    case country                            = "api/country"
    case logout                             = "api/user/logout"
    
    //M2 API
    case viewProfile                        = "api/user/view-profile"
    case changePassword                     = "api/user/change-password"
    case updateProfile                      = "api/user/update-profile"
    case getCategory                        = "api/user/category"
    case changeMobileNumber                 = "api/user/change-mobile-number"
    case userVerifyOtp                      = "api/user/verify-otp"
    
//    case getCategory                        = "api/user/category"
    //M3
  case categoryWiseStoreList                      = "api/user/category-Wise-Store-List"
  case singleStoreDetails                      = "api/user/single-store-details"
  case sortStoreFilter                      = "api/store_filter"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

