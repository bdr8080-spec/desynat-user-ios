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
    let password, document1, document2, otp: String?
    let otpVerify, deviceType: String?
    let deviceToken, dataLet, long: String?
    let addressUpdateStatus, bankUpdateStatus, adminVerify: String?
    let rejectReason, rememberToken: String?
    let status, createdAt, updatedAt, affiliatedAccessToken: String?
    
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
        case addressUpdateStatus = "address_update_status"
        case bankUpdateStatus = "bank_update_status"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case rememberToken = "remember_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case affiliatedAccessToken = "affiliated_accessToken"
    }
}
