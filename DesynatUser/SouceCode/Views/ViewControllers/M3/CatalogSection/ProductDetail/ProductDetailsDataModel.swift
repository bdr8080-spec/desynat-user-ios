//
//  ProductDetailsDataModel.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import Foundation

struct CheckDeliveryModel {
    let image: String?
    let title: String?
}

// MARK: - ProductDetailsDataModel
struct ProductDetailsDataModel: Codable {
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
    var wishlist: Int?
    var averageRating: Double?
    var addtocartTotalProduct: Int?
    let category: Category?
    let addtocart: Addtocart?
    let subcategory, brand: Brand?
    let store: Store?
    let productSpecifications: [ProductSpecification]?
    let productVariants: [ProductVariant]?
    let review: [Review]?
    let similarProducts: [BestSellingProductsDataModel]?
    let exptectedDeliveryTime: ExpectedDeilveryTimeModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeID = "store_id"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case brandID = "brand_id"
        case otherEn = "other_en"
        case otherAr = "other_ar"
        case addtocart
        case addtocartTotalProduct = "addtocartTotalProduct"
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
        case wishlist, category, subcategory, brand
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
        case store = "store"
        case review
        case averageRating = "average_rating"
        case similarProducts = "similar_products"
        case exptectedDeliveryTime = "delivery_time"
    }
}

// MARK: - Addtocart
struct Addtocart: Codable {
    let id, userID, productID, quantity: Int?
    let variantsID: Int?
    let amount, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case quantity
        case variantsID = "variants_id"
        case amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Review
struct Review: Codable {
    let id, userID, orderID, orderdetailsID: Int?
    let productID: Int?
    let productRating, productReview: String?
    let storeID: Int?
    let productImage: [String]?
//    let storeImage: [String]?
    let storeRating, storeReview, createdAt: String?
    let updatedAt: String?
    let userDetails: UserDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case orderdetailsID = "orderdetails_id"
        case productID = "product_id"
        case productRating = "product_rating"
        case productReview = "product_review"
        case productImage = "product_image"
        case storeID = "store_id"
        case storeRating = "store_rating"
        case storeReview = "store_review"
//        case storeImage = "store_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userDetails = "user_details"
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let id: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let otp, otpVerify: String?
    //  let deviceType: String?
    let deviceToken, userDetailsLet, long: String?
    let status, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
        //    case deviceType = "device_type"
        case deviceToken = "device_token"
        case userDetailsLet = "let"
        case long, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ExpectedDeilveryTimeModel
struct ExpectedDeilveryTimeModel: Codable {
    let id: Int?
    let name, nameAr, status, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
