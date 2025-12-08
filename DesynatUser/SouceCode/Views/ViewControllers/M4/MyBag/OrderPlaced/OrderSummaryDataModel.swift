//
//  OrderSummaryDataModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

// MARK: - OrderSummaryDataModel
struct OrderSummaryDataModel: Codable {
    let id: Int?
    let orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue: String?
    let giftcardAmount, giftcardID, shippingFees, tax: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID: String?
    let createdAt, updatedAt: String?
    let deliveryDetails: DeliveryDetails?
    let orderDetails: [OrderDetail]?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case promocodeStatus = "promocode_status"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardAmount = "giftcard_amount"
        case giftcardID = "giftcard_id"
        case shippingFees = "shipping_fees"
        case tax
        case totalAmount = "total_amount"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case deliveryStatus = "delivery_status"
        case transactionID = "transaction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deliveryDetails = "delivery_details"
        case orderDetails = "order_details"
    }
}

// MARK: - DeliveryDetails
struct DeliveryDetails: Codable {
    let id, userID: Int?
    let name, mobile, countryCode, address: String?
    let houseNo: String?
    let streetNo: String?
    let postalCode, city, state, countryName: String?
    let landmark: String?
    let saveAddressAs, status: Int?
    let latitude, longitude, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, mobile
        case countryCode = "country_code"
        case address
        case houseNo = "house_no"
        case streetNo = "street_no"
        case postalCode = "postal_code"
        case city, state
        case countryName = "country_name"
        case landmark
        case saveAddressAs = "save_address_as"
        case status, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - OrderDetail
struct OrderDetail: Codable {
    let id, orderID, userID, productID: Int?
    let variantsID, quantity: Int?
    let amount, status, createdAt, updatedAt: String?
    let productDetails: ProductDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productDetails = "product_details"
    }
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
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
    let brand: Brand?
    let category: Category?
    let subcategory: Brand?
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
        case brand, category, subcategory
        case sellerDetails = "seller_details"
    }
}
