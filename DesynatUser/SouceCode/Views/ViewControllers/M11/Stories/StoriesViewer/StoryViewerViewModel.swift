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
        let param: [String:Any] = ["seller_id": hostVC.sellerId ?? 0]
        WebService.sharedInstance.getSellerStoryService(param: param) { list in
            self.sellerStories = list
            completion()
        }
    }
    
    func getSelfHighlight(completion: @escaping () -> Void) {
        let param: [String:Any] = ["seller_id": hostVC.sellerId ?? 0]
        WebService.sharedInstance.getSellerHighlightsService(param: param) { list in
            self.sellerHighlight = list
            completion()
        }
    }
}

enum ComingReasonAtStoryViewer {
    case forAdminStory
    case forSellerStory
    case forSellerHighlight
}
