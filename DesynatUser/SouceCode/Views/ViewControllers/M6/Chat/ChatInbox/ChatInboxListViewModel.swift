//
//  ChatInboxListViewModel.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import Foundation

class ChatInboxListViewModel {
  
  private var hostVC: ChatInboxListViewController
  var appliedFilter = ChatsFilterModel()
  var chatList: [ChatInboxListModel]?
  var searchText: String = ""
  
  init(hostVC: ChatInboxListViewController) {
    self.hostVC = hostVC
  }
  
  func getChatInboxRequest() {
    var param: [String: Any] = [:]
    if !searchText.isEmpty {
      param["search"] = searchText
    }
    //      if let status = appliedFilter.orderDeliveryStatus {
    //        param["status"] = status
    //      }
    WebService.sharedInstance.getAllChatsList(param: param){ response in
      DispatchQueue.main.async {
        self.chatList = response
        self.hostVC.bindData()
        let chat = self.chatList ?? []
        self.hostVC.noDataFoundLabel.isHidden = !chat.isEmpty
      }
    }
  }
}
