//
//  StoryViewerDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import Foundation

// MARK: - Models
struct Story {
    let url: String?          // Make it optional
    let isVideo: Bool
    let duration: TimeInterval?   // nil for videos
    let uploadedTime: String?
    let type: Int?
    let sellerDetails: SellerDetails?
    
    init(url: String?, isVideo: Bool, duration: TimeInterval?, uploadedTime: String?, type: Int?, sellerDetails: SellerDetails?) {
        self.url = url
        self.isVideo = isVideo
        self.duration = duration
        self.uploadedTime = uploadedTime
        self.type = type
        self.sellerDetails = sellerDetails
    }
}
