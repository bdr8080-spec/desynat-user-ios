//
//  MyCartDetailsDataModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//

import Foundation

// MARK: - MyCartDetailsDataModel
struct MyCartDetailsDataModel: Codable {
    let totalMrp, discountOnMrp, discountCoupon, shippingFees: Int?
    let tax, totalAmount: Int?
    var cartData: [CartItemList]?

    enum CodingKeys: String, CodingKey {
        case totalMrp = "total_mrp"
        case discountOnMrp = "discount_on_mrp"
        case discountCoupon = "discount_coupon"
        case shippingFees = "shipping_fees"
        case tax
        case totalAmount = "total_amount"
        case cartData = "cart_data"
    }
}


// MARK: - CartItemList
struct CartItemList: Codable {
    let id, userID, productID: Int?
    var quantity: Int
    let variantsID: Int?
    let amount, createdAt, updatedAt, checkStock: String?
    let product: Product?
    let productVariants: ProductVariants?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case quantity
        case variantsID = "variants_id"
        case amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case checkStock = "check_stock"
        case product
        case productVariants = "product_variants"
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID, otherEn, otherAr, productNameEn: String?
    let productNameAr, descriptionEn, descriptionAr, minCardQuantity: String?
    let maxCardQuantity, productReturn, returnDays, productExchangable: String?
    let exchangableDays, reviewRating, affiliatedProduct, customizedProduct: String?
    let readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let createdAt, updatedAt: String?
    let sellerDetails: SellerDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeID = "store_id"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case brandID = "brand_id"
        case otherEn = "other_en"
        case otherAr = "other_ar"
        case productNameEn = "product_name_en"
        case productNameAr = "product_name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case minCardQuantity = "min_card_quantity"
        case maxCardQuantity = "max_card_quantity"
        case productReturn = "product_return"
        case returnDays = "return_days"
        case productExchangable = "product_exchangable"
        case exchangableDays = "exchangable_days"
        case reviewRating = "review_rating"
        case affiliatedProduct = "affiliated_product"
        case customizedProduct = "customized_product"
        case readyToShip = "ready_to_ship"
        case cashOnDelivery = "cash_on_delivery"
        case uploadSizeChart = "upload_size_chart"
        case productActiveStatus = "product_active_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellerDetails = "seller_details"
    }
}

// MARK: - SellerDetails
struct SellerDetails: Codable {
    let id: Int?
    let profilePic: String?
    let firstName, lastName, countryCode, mobile: String?
    let email, password, acceptTerms, otp: String?
    let otpVerify: String?
    let deviceType, deviceToken: String?
    let adminVerify, storeInformation, bankInformation: String?
    let rejectReason, lang: String?
    let isBlock: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile, email, password
        case acceptTerms = "accept_terms"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductVariants
struct ProductVariants: Codable {
    let id, productID: Int?
    let variantImage: [String]?
    let colorID, sizeID: String?
    let bust, waist, hip, shoulder: String?
    let sleeveLength, length: String?
    let totalStock, sku, skuThresholdValue, actualPrice: String?
    let discountType, discountValue, finalPrice, status: String?
    let createdAt, updatedAt: String?
    let color, size: Color?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case variantImage = "variant_image"
        case colorID = "color_id"
        case sizeID = "size_id"
        case bust, waist, hip, shoulder
        case sleeveLength = "sleeve_length"
        case length
        case totalStock = "total_stock"
        case sku
        case skuThresholdValue = "sku_threshold_value"
        case actualPrice = "actual_price"
        case discountType = "discount_type"
        case discountValue = "discount_value"
        case finalPrice = "final_price"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case color, size
    }
}
