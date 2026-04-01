//
//  ReelsScrollDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//

import Foundation

struct Reel {
    let id: Int?
    let videoURL: String?
    let caption: String?
    
    init(id: Int? = nil, videoURL: String? = nil, caption: String? = nil) {
        self.id = id
        self.videoURL = videoURL
        self.caption = caption
    }
}
