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
    
    case register                           = "api/register"
    case verifyOTP                          = "api/verify_otp"
    case loginUser                          = "api/login"
    case loginUserViaOTP                    = "api/login_by_mobile_or_email"
    case forgotPassword                     = "api/forgot_password"
    case createPassword                     = "api/create_password"
    case uploadFile                         = "api/upload"
    case resendOtp                          = "api/resend_otp"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

