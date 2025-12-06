//
//  GiftCardsListViewModel.swift
//  DesynatUser
//
//  Created by fluper on 06/12/25.
//

import Foundation

class GiftCardsListViewModel {
  
  private var hostVC: GiftCardsListViewController
  var giftsList: [GiftCardsListDataModel]?
  var searchText: String = ""
  
  init(hostVC: GiftCardsListViewController) {
    self.hostVC = hostVC
  }
  
  func getAllGiftsCards(){
    var param: [String: Any] = [:]
    if !searchText.isEmpty {
      param["search"] = searchText
    }
    WebService.sharedInstance.getAllGiftCardsList(param: param) { list in
      self.giftsList = list
      DispatchQueue.main.async {
        self.hostVC.tableView.reloadData()
        self.hostVC.noDataLabel.isHidden = !(self.giftsList?.isEmpty ?? false)
      }
    }
  }
  
}
