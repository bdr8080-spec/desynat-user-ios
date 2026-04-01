//
//  ReelsScrollViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//

import Foundation

class ReelsScrollViewModel {
    
    private var hostVC: ReelsScrollViewController
    var selectedReelId: Int? = 0
    
    init(hostVC: ReelsScrollViewController) {
        self.hostVC = hostVC
    }
    
    func addRemoveReelsFromWishlistRequest() {
        let param: [String:Any] = ["reel_id": selectedReelId ?? 0]
        WebService.shared.addRemoveReelsToWishlistService(param: param) { [weak self] response in
        }
    }
    
    func shareReelsRequest() {
        let param: [String:Any] = ["reel_id": selectedReelId ?? 0]
        WebService.shared.shareReelsService(param: param) { [weak self] response in
            
        }
    }
}
