//
//  MySavedCardViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 21/04/26.
//

import Foundation

class MySavedCardViewModel {
    
    private var hostVC: MySavedCardViewController
    var savedCardsDetails: [SavedCardsDataModel]?
    
    init(hostVC: MySavedCardViewController) {
        self.hostVC = hostVC
    }
    
    func getMySavedCardsRequest() {
        WebService.sharedInstance.getSavedCardsService { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.savedCardsDetails = response
                self.hostVC.savedTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !(self.savedCardsDetails?.isEmpty ?? true)
            }
        }
    }
    
    func deleteCardAPI(cardId: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["card_id": cardId]
        WebService.sharedInstance.deleteSavedCardsService(param: param) { response in
            completion(true)
        }
    }
    
    func makeDefaultCardAPI(cardID: Int, completion: @escaping (Bool) -> Void) {
        WebService.sharedInstance.makeCardDefaultAPi(cardId: cardID ) { response in
          completion(true)
      }
    }
    
}
