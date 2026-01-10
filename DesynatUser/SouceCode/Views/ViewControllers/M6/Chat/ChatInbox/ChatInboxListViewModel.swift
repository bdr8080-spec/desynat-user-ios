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
  
  init(hostVC: ChatInboxListViewController) {
    self.hostVC = hostVC
  }
  
  
}
