//
//  SelectOccassionViewModel.swift
//  DesynatUser
//
//  Created by fluper on 06/12/25.
//

import Foundation
import SDWebImage

class SelectOccassionViewModel {
  
  private var hostVC: SelectOccassionViewController
  
  var occassionsList: [GiftCardsDataModel]?
  
  init(hostVC: SelectOccassionViewController) {
    self.hostVC = hostVC
  }
  
  func getAllGiftsCardsOccassion(){
    WebService.sharedInstance.getAllGiftCardsOccassionList() { list in
      self.occassionsList = list
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.hostVC.selectedIndex = occassionsList?.first?.id
        self.hostVC.populateData(imageUrl: occassionsList?.first?.image)
        self.hostVC.occassionCollectionView.reloadData()
        self.hostVC.updateCollectionViewHeight()
      }
    }
  }
}
