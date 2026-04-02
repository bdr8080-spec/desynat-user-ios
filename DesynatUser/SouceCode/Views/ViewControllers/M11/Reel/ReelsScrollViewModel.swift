//
//  ReelsScrollViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//

class ReelsScrollViewModel {
    
    private var hostVC: ReelsScrollViewController
    var selectedReelId: Int? = 0
    var sellerReels: [GetMyReelsList] = []
    
    init(hostVC: ReelsScrollViewController) {
        self.hostVC = hostVC
    }
    
    func addRemoveReelsFromWishlistRequest() {
        let param = ["reel_id": selectedReelId ?? 0]
        WebService.shared.addRemoveReelsToWishlistService(param: param) { _ in }
    }
    
    func shareReelsRequest() {
        let param = ["reel_id": selectedReelId ?? 0]
        WebService.shared.shareReelsService(param: param) { _ in }
    }
    
    func getSellerReelsService(sellerId: Int, completion: @escaping () -> Void) {
        let param = ["seller_id": sellerId]
        
        WebService.sharedInstance.getSellerReelsService(param: param) { [weak self] list in
            self?.sellerReels = list
            completion()
        }
    }
}
