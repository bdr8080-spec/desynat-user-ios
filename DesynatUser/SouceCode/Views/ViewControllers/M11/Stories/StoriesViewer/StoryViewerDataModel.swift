//
//  StoryViewerDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import Foundation

// MARK: - Models
struct Story {
    let url: String?
    let isVideo: Bool
    let duration: TimeInterval?
}

struct UserStories {
    let userName: String?
    let stories: [Story]?
}

