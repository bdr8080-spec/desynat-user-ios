//
//  OrderModel.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

// MARK: - Datum
struct OrderModel: Codable {
    let id: Int?
    let orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue, giftcardAmount, giftcardID: String?
    let shippingFees, tax: String?
    let walletAmount: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID: String?
    let createdAt, updatedAt: String?
    let deliveryDetails: DeliveryDetails?
    let orderDetails: [OrderDetail1]?

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
        case walletAmount = "wallet_amount"
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

// MARK: - OrderDetail
struct OrderDetail1: Codable {
    let id, orderID, userID, productID: Int?
    let variantsID, quantity: Int?
    let amount, status, createdAt, updatedAt: String?
    let returnType, rEApprove: String?
    let returnReason, returnImage, exchangeReason, exchangeNewSize: String?
    let exchangeOldSize: String?
    let paymentStatus, deliveryStatus: String?
    let productDetails: ProductDetails?
    let variationDetails: VariationDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, status
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
        case productDetails = "product_details"
        case variationDetails = "variation_details"
    }
}


// MARK: VariationDetails
struct VariationDetails: Codable {
    let id, productID: Int?
    let parentChild: String?
    let variantImage: [String]?
    let colorID, sizeID, bust, waist: String?
    let hip, shoulder, sleeveLength, length: String?
    let totalStock, sku: String?
    let skuThresholdValue: String?
    let actualPrice, discountType, discountValue, finalPrice: String?
    let status, createdAt, updatedAt: String?
    let color, size: Color?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case parentChild = "parent_child"
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
