//
//  StoresDataModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation

// MARK: - StoreListDataModel
struct StoreListDataModel: Codable {
    let id, sellerID: Int?
    let storeImage: String?
    let storeName, country, storeAddress, addressLine1: String?
    let addressLine2, storePhone, countryCode, storeMailID: String?
    let storeAvailability: Int?
    let bio, datumLet, long, createdAt: String?
    let updatedAt: String?
    let sellerInformation: SellerInformation?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailID = "store_mail_id"
        case storeAvailability = "Store_Availability"
        case bio
        case datumLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellerInformation = "seller_information"
    }
}

// MARK: - SellerInformation
struct SellerInformation: Codable {
    let id: Int?
    let profilePic: String?
    let firstName, lastName, countryCode, mobile: String?
    let email, password, acceptTerms, otp: String?
    let otpVerify: String?
//    let deviceType: String?
    let deviceToken: String?
    let adminVerify, storeInformation, bankInformation: String?
    let rejectReason, lang: String?
    let isBlock: Int?
    let createdAt, updatedAt: String?
    let profileQr, qrSellerUrl: String?

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
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case profileQr = "profile_qr"
        case qrSellerUrl = "qrSellerUrl"
    }
}
