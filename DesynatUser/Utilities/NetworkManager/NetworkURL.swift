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
    case allUserCountry                     = "api/all_country"
    case logout                             = "api/user/logout"
    
    //M2 API
    case viewProfile                        = "api/user/view-profile"
    case changePassword                     = "api/user/change-password"
    case updateProfile                      = "api/user/update-profile"
    case getCategory                        = "api/user/category"
    case changeMobileNumber                 = "api/user/change-mobile-number"
    case userVerifyOtp                      = "api/user/verify-otp"
    
    //M3
    case categoryWiseStoreList              = "api/user/category-Wise-Store-List"
    case singleStoreDetails                 = "api/user/single-store-details"
    case sortStoreFilter                    = "api/store_filter"
    case addToWishlist                      = "api/user/product-add-to-wishlist"
    case productDetails                     = "api/user/single-product-details"
    case addToCart                          = "api/user/product-add-to-cart"
    case incrementDecrement                 = "api/user/addtocart-increment-decrement"
    case cartDetailsList                    = "api/user/view_cart_details"
    case getSavedAddress                    = "api/user/view-address"
    case addNewAddress                      = "api/user/save-address"
    case editAddress                        = "api/user/update-address"
    case getWishlist                        = "api/user/get_wishlist_products"
    case setDeafultAddress                  = "api/user/set_default_address"
    case getAllBrands                       = "api/all-brand"
    case getAllColors                       = "api/all-color"
    case getAllSizes                        = "api/all-size"
    
    //M4
    case getAllCards                        = "api/user/view-gift-cards"
    case getAllOccassion                    = "api/user/gift-card-occasion-list"
    case addGiftCards                       = "api/user/add-gift-card"
    case paymentForGiftCard                 = "api/user/giftcard-complete-Payment"
    case getAllPromocodeList                = "api/user/view-promocode-list"
    case createOrder                        = "api/user/create-order"
    case applyPromocode                     = "api/user/Apply-promocode"
    case applyGiftCard                      = "api/user/apply-gift-card"
    case singleOrderSummary                 = "api/user/single-order-summary"
    case singleOrderSummaryInvoice          = "api/user/get-Invoice"
    case completePayment                    = "api/user/product-order-complete-payment"
    case getWalletAmount                    = "api/user/waller-balance"
    
    
    //M5
    case getOrders                          = "api/user/All-order"
    case cancelProduct                      = "api/user/cancelled-single-product"
    case rejectReason                       = "api/user/get-reject-reason"
    case OrderReturnEx                      = "api/user/return-exchange-product-after-delivered"
    case orderRating                        = "api/user/product-rating"
    case recentSearch                       = "api/user/get-recent-search-data"
    case recommendedSearch                  = "api/user/get-recommnded-search-data"
    case homeSearch                         = "api/user/home-page-search"
  
  //M6
    case homeFullScreenBanner               = "api/user/popUp-Home-screen-Banner"
    
    func withBaseURL() -> String {
        return "\(BaseURL.value())\(self.rawValue)"
    }
}

enum NetworkURL {
    case endpoint(NetworkEndPoint)
    case custom(String)
}

