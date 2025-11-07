//
//  SideMenuModel.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//


struct SideMenuModel {
    let title: String
    let image: String
}

struct ChangeMobileNumModel: Codable {
    let userID: Int?
    let countryCode: String?
    let mobile: String?
    let otp: String?
    let type: String?
    let status: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case countryCode = "country_code"
        case mobile
        case otp
        case type
        case status
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

struct UserVerifyOtpModel: Codable {
    let id: Int?
    let userID: Int?
    let email: String?
    let countryCode: String?
    let mobile: String?
    let otp: String?
    let otpVerify: String?
    let type: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case email
        case countryCode = "country_code"
        case mobile
        case otp
        case otpVerify = "otp_verify"
        case type
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}







