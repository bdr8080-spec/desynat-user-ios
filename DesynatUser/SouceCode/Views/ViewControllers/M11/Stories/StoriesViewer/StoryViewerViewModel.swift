//
//  StoryViewerViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import Foundation
import AVFoundation

class StoryViewerViewModel {
    
    var adminStories: [SellerHighlightsModel] = []
    var sellerStories: [SellerHighlightsModel] = []
    var sellerHighlight: [GetHighLightsList] = []
    private var hostVC: StoryViewerViewController
    
    init(hostVC: StoryViewerViewController) {
        self.hostVC = hostVC
    }
    
    func getAdminStory(completion: @escaping () -> Void) {
        WebService.sharedInstance.getAdminStoryService() { list in
            self.adminStories = list
            completion()
        }
    }
    
    func getSelfStory(completion: @escaping () -> Void) {
        let param: [String:Any] = ["seller_id": hostVC.sellerId]
        WebService.sharedInstance.getSellerStoryService(param: param) { list in
            self.sellerStories = list
            completion()
        }
    }
    
    func getSelfHighlight(completion: @escaping () -> Void) {
        let param: [String:Any] = ["seller_id": hostVC.sellerId]
        WebService.sharedInstance.getSellerHighlightsService(param: param) { list in
            self.sellerHighlight = list
            completion()
        }
    }
    
    func seeStoryService(storyId: Int) {
        let savedUser = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self)
        
        var param: [String: Any] = [
            "story_id": storyId,
            "type": 1 // 1-user, 2-seller, 3-admin
        ]
        
        if let userId = savedUser?.id, userId != 0 {
            param["user_id"] = userId
        }
        
        WebService.sharedInstance.seeStoryListService(param: param) { success in
            print("Stopry viewed")
        }
    }
}

enum ComingReasonAtStoryViewer {
    case forAdminStory
    case forSellerStory
    case forSellerHighlight
}
