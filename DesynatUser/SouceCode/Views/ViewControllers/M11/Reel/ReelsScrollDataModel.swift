//
//  ReelsScrollDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//

import Foundation

struct Reel {
    var id: Int?
    var videoURL: String?
    var caption: String?
    var isWhishlisted: Int?     // <-- REQUIRED for like UI refresh
    
    init(id: Int? = nil,
         videoURL: String? = nil,
         caption: String? = nil,
         isWhishlisted: Int? = nil) {
        
        self.id = id
        self.videoURL = videoURL
        self.caption = caption
        self.isWhishlisted = isWhishlisted
    }
}


// MARK: - GetMyReelsList
struct GetMyReelsList: Codable {
    let id, type, sellerID: Int?
    let file: String?
    let thumbnail: String?
    let caption: String?
    let title:String?
    let status: Int?
    let createdAt, updatedAt: String?
    var isWhishlisted: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, caption, status, thumbnail, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isWhishlisted = "is_whishlisted"
    }
}


// MARK: - GetMyWislistDataModelForReels
struct GetMyWislistDataModelForReels: Codable {
    let id, userID, reelID, status: Int?
    let createdAt, updatedAt: String?
    let reelDetails: GetMyReelsList?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case reelID = "reel_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reelDetails = "reel_details"
    }
}

