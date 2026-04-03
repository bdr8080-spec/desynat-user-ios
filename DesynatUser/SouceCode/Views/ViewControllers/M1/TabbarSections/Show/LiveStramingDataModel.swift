//
//  LiveStramingDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 03/04/26.
//

import Foundation

// MARK: - AgroaTokenDataModel
struct AgroaTokenDataModel: Codable {
    let token: String?
    let uid: UInt?
}



// MARK: - LiveStramingDataModel
struct LiveStramingDataModel: Codable {
    let id, timeslotID, sellerID, orderID: Int?
    let adminVerify: Int?
    let rejectReason, cancelReason: String?
    let channelID: String?
    let uid: Int?
    let createdAt, updatedAt: String?
    let liveToken: String?
    let sellerDetails: SellerDetails?
    let timeslotDetails: TimeslotDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case timeslotID = "timeslot_id"
        case sellerID = "seller_id"
        case orderID = "order_id"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case cancelReason = "cancel_reason"
        case channelID = "channel_id"
        case uid
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case liveToken
        case sellerDetails = "seller_details"
        case timeslotDetails = "timeslot_details"
    }
}

// MARK: - SellerDetails
//struct SellerDetails: Codable {
//    let id: Int?
//    let profilePic: String?
//    let firstName, lastName, countryCode, mobile: String?
//    let email, password, acceptTerms, otp: String?
//    let otpVerify, deviceType: String?
//    let deviceToken: String?
//    let adminVerify, storeInformation, bankInformation: String?
//    let rejectReason: String?
//    let lang: String?
//    let isBlock: Int?
//    let affilateCommission: String?
//    let fcmToken: String?
//    let profileQr: String?
//    let qrSellerURL: String?
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
//        case fcmToken = "fcm_token"
//        case profileQr = "profile_qr"
//        case qrSellerURL = "qrSellerUrl"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - TimeslotDetails
struct TimeslotDetails: Codable {
    let id, countryID: Int?
    let date, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case date, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

// MARK: - CountryInfo
struct CountryInfo: Codable {
    let id: Int?
    let name, isoCode, currencyName, currencyCode: String?
    let currencySymbol, dialCode, flag: String?
    let flag1: String?
    let exchangeRateToKwd, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag, flag1
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
