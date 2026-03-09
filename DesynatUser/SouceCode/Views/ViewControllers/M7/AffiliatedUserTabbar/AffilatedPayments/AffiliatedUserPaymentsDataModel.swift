//
//  AffiliatedUserPaymentsDataModel.swift
//  DesynatUser
//
//  Created by Geetam   on 09/03/26.
//

import Foundation


// MARK: - OrdersDataAffilaitedPaymentDataModel
struct OrdersDataAffilaitedPaymentDataModel: Codable {
    var orders: [OrdersDataAffilaitedPaymentList]?
    var totalEarning: Double?

    enum CodingKeys: String, CodingKey {
        case orders
        case totalEarning = "total_earning"
    }
}

// MARK: - OrdersDataAffilaitedPaymentList
struct OrdersDataAffilaitedPaymentList: Codable {
    var id: Int?
    var rEType: String?
    var pOrderdetailsId: String?
    var orderId: Int?
    var orderType: String?
    var userId: Int?
    var productId: Int?
    var variantsId: Int?
    var quantity: Int?
    var amount: String?
    var tax: String?
    var shippingFees: String?
    var promocodeId: String?
    var promocodeValue: String?
    var giftcardId: String?
    var giftcardAmount: String?
    var status: String?
    var createdAt: String?
    var updatedAt: String?
    var returnType: String?
    var rEApprove: String?
    var returnReason: String?
    var returnImage: String?
    var exchangeReason: String?
    var exchangeNewSize: String?
    var exchangeOldSize: String?
    var paymentStatus: String?
    var deliveryStatus: String?
    var deliveryBoyId: String?
    var assignStatus: String?
    var assignDate: String?
    var cancelReason: String?
    var isPicked: String?
    var notDeliveredReason: String?
    var sellerId: String?
    var adminCommission: String?
    var orderStatus: String?
    var returnToStore: String?
    var uniqueId: String?
    var referenceLink: String?
    var affiliateId: String?
    var affiliateCommission: String?
    var affiliateAdminCommission: String?

    var userDetails: UserDetails?
    var order: OrderInfo?
    var productDetails: ProductDetails?
    var variationDetails: VariationDetails?
    var exchangeOrderDetails: ExchangeOrderDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case rEType = "r_e_type"
        case pOrderdetailsId = "p_orderdetails_id"
        case orderId = "order_id"
        case orderType = "order_type"
        case userId = "user_id"
        case productId = "product_id"
        case variantsId = "variants_id"
        case quantity
        case amount
        case tax
        case shippingFees = "shipping_fees"
        case promocodeId = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardId = "giftcard_id"
        case giftcardAmount = "giftcard_amount"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case returnType = "return_type"
        case rEApprove = "r_e_approve"
        case returnReason = "return_reason"
        case returnImage = "return_image"
        case exchangeReason = "exchange_reason"
        case exchangeNewSize = "exchange_new_size"
        case exchangeOldSize = "exchange_old_size"
        case paymentStatus = "payment_status"
        case deliveryStatus = "delivery_status"
        case deliveryBoyId = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case cancelReason = "cancel_reason"
        case isPicked = "is_picked"
        case notDeliveredReason = "not_delivered_reason"
        case sellerId = "seller_id"
        case adminCommission = "admin_commission"
        case orderStatus = "order_status"
        case returnToStore = "returntostore"
        case uniqueId = "unique_id"
        case referenceLink = "reference_link"
        case affiliateId = "affiliate_id"
        case affiliateCommission = "affiliate_commission"
        case affiliateAdminCommission = "affiliate_admin_commission"
        case userDetails = "user_details"
        case order
        case productDetails = "product_details"
        case variationDetails = "variation_details"
        case exchangeOrderDetails = "exchange_order_details"
    }
}

//// MARK: - User Details
//struct UserDetails: Codable {
//    var id: Int?
//    var profileImage: String?
//    var fullName: String?
//    var countryCode: String?
//    var mobile: String?
//    var email: String?
//    var otp: String?
//    var otpVerify: String?
//    var deviceType: String?
//    var deviceToken: String?
//    var status: String?
//    var bannerView: String?
//    var lang: String?
//    var createdAt: String?
//    var updatedAt: String?
//    var accessToken: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case profileImage = "profile_image"
//        case fullName = "full_name"
//        case countryCode = "country_code"
//        case mobile
//        case email
//        case otp
//        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
//        case deviceToken = "device_token"
//        case status
//        case bannerView = "banner_view"
//        case lang
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case accessToken
//    }
//}

// MARK: - Order Info
struct OrderInfo: Codable {
    var id: Int?
    var orderType: String?
    var orderId: String?
    var userId: Int?
    var deliveryAddress: Int?
    var totalMrp: String?
    var discountMrp: String?
    var shippingFees: String?
    var tax: String?
    var totalAmount: String?
    var paymentStatus: String?
    var paymentMethod: String?
    var deliveryStatus: String?
    var createdAt: String?
    var updatedAt: String?

    var deliveryDetails: DeliveryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderType = "order_type"
        case orderId = "order_id"
        case userId = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case shippingFees = "shipping_fees"
        case tax
        case totalAmount = "total_amount"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case deliveryStatus = "delivery_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deliveryDetails = "delivery_details"
    }
}

// MARK: - Delivery Details
//struct DeliveryDetails: Codable {
//    var id: Int?
//    var userId: Int?
//    var name: String?
//    var mobile: String?
//    var countryCode: String?
//    var address: String?
//    var houseNo: String?
//    var city: String?
//    var state: String?
//    var countryName: String?
//    var latitude: String?
//    var longitude: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userId = "user_id"
//        case name
//        case mobile
//        case countryCode = "country_code"
//        case address
//        case houseNo = "house_no"
//        case city
//        case state
//        case countryName = "country_name"
//        case latitude
//        case longitude
//    }
//}

// MARK: - Product Details
//struct ProductDetails: Codable {
//    var id: Int?
//    var productNameEn: String?
//    var productNameAr: String?
//    var descriptionEn: String?
//    var descriptionAr: String?
//    var productActiveStatus: Int?
//    var brand: Brand?
//    var category: Category?
//    var subcategory: Subcategory?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productNameEn = "product_name_en"
//        case productNameAr = "product_name_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//        case productActiveStatus = "product_active_status"
//        case brand
//        case category
//        case subcategory
//    }
//}

// MARK: - Brand
//struct Brand: Codable {
//    var id: Int?
//    var nameEnglish: String?
//    var nameArabic: String?
//    var image: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameEnglish = "name_english"
//        case nameArabic = "name_arabic"
//        case image
//    }
//}

// MARK: - Category
//struct Category: Codable {
//    var id: Int?
//    var name: String?
//    var image: String?
//}

// MARK: - Subcategory
struct Subcategory: Codable {
    var id: Int?
    var nameEnglish: String?
    var nameArabic: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
    }
}

// MARK: - Variation
//struct VariationDetails: Codable {
//    var id: Int?
//    var productId: Int?
//    var variantImage: [String]?
//    var color: Color?
//    var size: Size?
//    var finalPrice: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productId = "product_id"
//        case variantImage = "variant_image"
//        case color
//        case size
//        case finalPrice = "final_price"
//    }
//}

// MARK: - Color
//struct Color: Codable {
//    var id: Int?
//    var name: String?
//    var hexCode: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case hexCode = "hex_code"
//    }
//}

// MARK: - Size
struct Size: Codable {
    var id: Int?
    var name: String?
}

// MARK: - Exchange
//struct ExchangeOrderDetails: Codable {
//}
