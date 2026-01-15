//
//  HomeDataModel.swift
//  DesynatUser
//
//  Created by fluper on 07/11/25.
//

import Foundation

// MARK: - CategoriesDataModel
struct CategoriesDataModel: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    let status: Int?
    let colorCode, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - SubCategoriesDataModel
struct SubCategoriesDataModel: Codable {
    let id, categoryID: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - HomescreenBannersList
struct HomescreenBannersList: Codable {
    let id: Int?
    let orderID: String?
    let sellerID: Int?
    let bannerPosition: String?
    let category: String?
    let subcatgory: String?
    let startDate, endDate, totalDays: String?
    let uploadBanner: String?
    let price, adminVerify, paymentStatus, transactionID: String?
    let cancelledReason: String?
    let status, createdAt, updatedAt: String?
    let categoryDetails: CategoryDetails?
//    let subcategoryDetails: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case sellerID = "seller_id"
        case bannerPosition = "banner_position"
        case category, subcatgory
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case uploadBanner = "upload_banner"
        case price
        case adminVerify = "Admin_verify"
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case cancelledReason = "cancelled_reason"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
//        case subcategoryDetails = "subcategory_details"
    }
}

// MARK: - CategoryDetails
struct CategoryDetails: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    let status: Int?
    let colorCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
