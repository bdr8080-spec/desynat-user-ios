//
//  ComingReasonAtChatScreen.swift
//  DesynatUser
//
//  Created by fluper on 13/01/26.
//


import Foundation

//enum ComingReasonAtChatScreen {
//    case quotationSentForFirstTime
//    case doModificationAfterQuotationSent
//}

// MARK: - ChatDetailsDataModel
struct ChatDetailsDataModel: Codable {
  let record: Record?

  enum CodingKeys: String, CodingKey {
      case record
  }
}

// MARK: - Record
struct Record: Codable {
  let id: Int?
  let uniqueID, type: String?
  let userID, sellerID: Int?
  let productID, variationID, price, quantity: String?
  let deliveryAddress, shipping, tax, totalAmount: String?
  let customDetails, productRequest, action, addtocardStatus, createdAt: String?
  let updatedAt: String?
  let productVariation: ProductVariation?
  let userDetails: UserDetails?
  let sellerDetails: SellerDetails?
  let deliveryDetails: DeliveryDetails?
  let orderCreateStatus: OrderCreateStatus?

  enum CodingKeys: String, CodingKey {
      case id
      case uniqueID = "unique_id"
      case type
      case userID = "user_id"
      case sellerID = "seller_id"
      case productID = "product_id"
      case variationID = "variation_id"
      case price, quantity
      case deliveryAddress = "delivery_address"
      case shipping, tax
      case totalAmount = "total_amount"
      case customDetails = "custom_details"
      case productRequest = "product_request"
      case action, addtocardStatus
      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case productVariation = "product_variation"
      case userDetails = "user_details"
      case sellerDetails = "seller_details"
      case deliveryDetails = "delivery_details"
    case orderCreateStatus = "order_create_status"
  }
}

// MARK: - OrderCreateStatus
struct OrderCreateStatus: Codable {
    let id: Int?
    let orderType: String?
//        let orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue, giftcardAmount, giftcardID: String?
    let shippingFees, tax: String?
    let walletAmount: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID, deliveryBoyID: String?
    let assignStatus: String?
    let assignDate: String?
    let createdAt, updatedAt: String?
    let cancelReason: String?
    let uniqueID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderType = "order_type"
//        case orderID = "order_id"
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
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cancelReason = "cancel_reason"
        case uniqueID = "unique_id"
    }
}


// MARK: - ProductVariation
struct ProductVariation: Codable {
  let id, productID: Int?
  let parentChild: String?
  let variantImage: [String]?
  let colorID, sizeID: String?
  let bust, waist, hip, shoulder: String?
  let sleeveLength, length: String?
  let totalStock, sku: String?
  let skuThresholdValue: String?
  let actualPrice, discountType, discountValue, finalPrice: String?
  let status, createdAt, updatedAt: String?
  let productDetails: ProductDetails?
  let size, color: Color?

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
      case productDetails = "product_details"
    case size, color
  }
}


struct UploadImageModel:Codable{
    let url:String?
}
