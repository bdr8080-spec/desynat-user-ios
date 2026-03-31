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
    
    init(url: String?, isVideo: Bool, duration: TimeInterval?) {
        self.url = url
        self.isVideo = isVideo
        self.duration = duration
    }
}
