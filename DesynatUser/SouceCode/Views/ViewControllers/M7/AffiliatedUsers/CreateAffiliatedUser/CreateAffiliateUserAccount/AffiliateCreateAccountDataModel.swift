//
//  AffiliateCreateAccountDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import Foundation

// MARK: - AffiliateCreateAccountDataModel
struct AffiliateCreateAccountDataModel: Codable {
    let id, userID: Int?
    let profileImage, fullName, countryCode, mobile: String?
    let email: String?
    let emailVerifiedAt: String?
    let password,passwordOld, document1, document2, otp: String?
    let otpVerify, deviceType: String?
    let deviceToken, dataLet, long: String?
    let addressUpdateStatus, bankUpdateStatus, adminVerify: String?
    let rejectReason, rememberToken: String?
    let status, createdAt, updatedAt, affiliatedAccessToken: String?
    let addressDetails: AddressDetails?
    let bankDetails: [BankDetail]?
    let countryDetails: CountryDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case password, document1, document2, otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case dataLet = "let"
        case long
        case passwordOld = "password_old"
        case addressUpdateStatus = "address_update_status"
        case bankUpdateStatus = "bank_update_status"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case rememberToken = "remember_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case affiliatedAccessToken = "affiliated_accessToken"
        case addressDetails = "address_details"
        case bankDetails = "bank_details"
        case countryDetails = "country_details"
    }
}

// MARK: - AddressDetails
struct AddressDetails: Codable {
    let id, affiliateID: Int?
    let country, locations, address1, address2: String?
    let pincode: String?
    let town, state, city: String?
    let addressDetailsLet, long, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case affiliateID = "affiliate_id"
        case country, locations, address1, address2, pincode, town, state, city
        case addressDetailsLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - BankDetail
struct BankDetail: Codable {
    let id: Int?
    let userID, type, accountType, accountNo: String?
    let iban, swift, bankName, accountHolderName: String?
    let uploadProof: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case type
        case accountType = "account_type"
        case accountNo = "account_no"
        case iban, swift
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case uploadProof = "upload_proof"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CountryDetails
struct CountryDetails: Codable {
    let id: Int?
    let name, code, isoCode, isoCodeNumber: String?
    let currencyName, currencyCode, currencySymbol, exchangeRateToUsd: String?
    let dialCode, flag1: String?
    let flag: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, code
        case isoCode = "iso_code"
        case isoCodeNumber = "iso_code_number"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case exchangeRateToUsd = "exchange_rate_to_usd"
        case dialCode = "dial_code"
        case flag1, flag
    }
}
