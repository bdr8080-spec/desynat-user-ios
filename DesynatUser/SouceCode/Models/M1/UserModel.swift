//
//  Welcome.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 30/10/25.
//

// MARK: - UserModel
struct UserModel: Codable {
    let id: Int?
    let fullName, countryCode, mobile, email, profileImage: String?
    let emailVerifiedAt: String?
    let otp, otpVerify: String?
//    let deviceType: String?
    let deviceToken, dataLet, long: String?
    let createdAt, updatedAt, accessToken: String?
    let affiliatedUserdetails: AffiliatedUserdetails?
    let affiliatedAccessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case dataLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case accessToken
        case profileImage = "profile_image"
        case affiliatedUserdetails = "affiliated_userdetails"
        case affiliatedAccessToken = "affiliated_accessToken"
    }
}

// MARK: - AffiliatedUserdetails
struct AffiliatedUserdetails: Codable {
    let id, userID: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let password: String?
    let document1: String?
    let document2, otp: String?
    let otpVerify: String?
//    let deviceType: String?
    let deviceToken, affiliatedUserdetailsLet, long: String?
    let addressUpdateStatus, bankUpdateStatus, adminVerify, rejectReason: String?
    let rememberToken: String?
    let status, createdAt, updatedAt: String?

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
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case affiliatedUserdetailsLet = "let"
        case long
        case addressUpdateStatus = "address_update_status"
        case bankUpdateStatus = "bank_update_status"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case rememberToken = "remember_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
