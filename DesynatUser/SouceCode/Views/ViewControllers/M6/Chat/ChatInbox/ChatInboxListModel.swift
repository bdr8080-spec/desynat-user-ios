//
//  ChatInboxListModel.swift
//  DesynatUser
//
//  Created by fluper on 13/01/26.
//


import Foundation

struct ChatInboxListModel: Codable {
  let id: Int?
  let uniqueID, type: String?
      let messageType: String?
  let userID, sellerID: Int?
  let productID, variationID, price, quantity: String?
  let deliveryAddress, shipping, tax, totalAmount: String?
  let customDetails: String?
  let productRequest, action, createdAt, updatedAt: String?
  let lastChat: String?
  let lastChatTime: String?
  let productVariation: ProductVariation?
  let userDetails: UserDetails?
  let sellerDetails: SellerDetails?
    let orderCreateStatus: OrderCreateStatus?

  enum CodingKeys: String, CodingKey {
      case id
      case uniqueID = "unique_id"
      case type
    case messageType = "message_type"
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
      case action
      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case lastChat = "last_chat"
      case lastChatTime = "last_chat_time"
      case productVariation = "product_variation"
      case userDetails = "user_details"
      case sellerDetails = "seller_details"
      case orderCreateStatus =  "order_create_status"
  }
}

// MARK: - SellerDetails
//struct SellerDetails: Codable {
//    let id: Int?
//    let profilePic: String?
//    let firstName, lastName, countryCode, mobile: String?
//    let email, password, acceptTerms, otp: String?
//    let otpVerify: String?
//    let deviceType, deviceToken: String?
//    let adminVerify, storeInformation, bankInformation: String?
//    let rejectReason, lang: String?
//    let isBlock: Int?
//    let affilateCommission: String?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case profilePic = "profile_pic"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case countryCode = "country_code"
//        case mobile, email, password
//        case acceptTerms = "accept_terms"
//        case otp
//        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
//        case deviceToken = "device_token"
//        case adminVerify = "admin_verify"
//        case storeInformation = "store_information"
//        case bankInformation = "bank_information"
//        case rejectReason = "reject_reason"
//        case lang
//        case isBlock = "is_block"
//        case affilateCommission = "affilate_commission"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
