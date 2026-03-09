//
//  MyWithdrawalMoneyDataModel.swift
//  DesynatUser
//
//  Created by Geetam   on 09/03/26.
//

import Foundation

//MARK: - WithdrawRequestDataModel
struct WithdrawRequestDataModel: Codable {
    let withdrawRequests: [WithdrawRequestList]?
    let totalWithdrawals: String?

    enum CodingKeys: String, CodingKey {
        case withdrawRequests = "withdraw_requests"
        case totalWithdrawals = "total_withdrawals"
    }
}

// MARK: - WithdrawRequestList
struct WithdrawRequestList: Codable {
    let id: Int?
    let requestID: String?
    let type, userID, bankdetailsID: Int?
    let amount: String?
    let adminVerify: Int?
    let rejectReason: String?
    let createdAt, updatedAt: String?
    let bankDetails: BankDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case requestID = "request_id"
        case type
        case userID = "user_id"
        case bankdetailsID = "bankdetails_id"
        case amount
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case bankDetails = "bank_details"
    }
}

// MARK: - BankDetails
struct BankDetails: Codable {
    let id: Int?
    let userID, type, accountType: String?
    let accountNo: String?
    let iban, swift, bankName, accountHolderName: String?
    let uploadProof: String?
    let defaultAccount, createdAt, updatedAt: String?

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
        case defaultAccount = "default_account"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
