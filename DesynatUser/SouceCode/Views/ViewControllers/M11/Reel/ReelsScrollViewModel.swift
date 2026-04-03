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
    var reelsList: [GetMyWislistDataModelForReels] = []
    
    init(hostVC: ReelsScrollViewController) {
        self.hostVC = hostVC
    }
    
    func addRemoveReelsFromWishlistRequest() {
        let param = ["reel_id": selectedReelId ?? 0]
        WebService.shared.addRemoveReelsToWishlistService(param: param) { _ in }
    }
    
    func shareReelsRequest(completion: @escaping (String?) -> Void) {

        let param = ["reel_id": selectedReelId ?? 0]

        WebService.shared.shareReelsService(param: param) { response in
            // Assuming API returns:  { "link": "https://..." }
            let link = response.file ?? ""
            completion(link)
        }
    }
    
    func getSellerReelsService(sellerId: Int, completion: @escaping () -> Void) {
        let param = ["seller_id": sellerId]
        
        WebService.sharedInstance.getSellerReelsService(param: param) { [weak self] list in
            self?.sellerReels = list
            completion()
        }
    }
    
    func getReelsWishlistRequest(completion: @escaping () -> Void) {
        WebService.sharedInstance.getReelsWishlistService { list in
            self.reelsList = list
            completion()
//            let isEmpty = self.reelsList?.isEmpty ?? true
//            self.hostVC.emptyLabel.text = isEmpty ? "No reels found" : ""
//            self.hostVC.emptyLabel.isHidden = !isEmpty
//            self.hostVC.favouriteCollectionView.reloadData()
        }
    }
}
