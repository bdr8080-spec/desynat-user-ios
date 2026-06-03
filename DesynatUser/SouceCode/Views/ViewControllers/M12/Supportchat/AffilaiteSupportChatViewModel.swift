//
//  AffilaiteSupportChatViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import Foundation
import FirebaseDatabaseInternal

class AffilaiteSupportChatViewModel {
    
    var chatDetailsUniqueId: String = ""
    private var hostVC: AffilaiteSupportChatViewController
    public var delegate:ChatViewModelDelegate?
    private var chatDB = Database.database().reference().child("chats")
    private var chatReference:DatabaseReference?
    private var existingKeys = Set<String>()
    
    init(hostVC: AffilaiteSupportChatViewController) {
        self.hostVC = hostVC
    }
    
    func checkForEnquiryChat() {
        let ref = self.chatDB.child(chatDetailsUniqueId)
        self.chatReference = ref
        self.getAllChatHistory()
    }
    
    func getAllChatHistory() {
        guard let ref = self.chatReference else { return }
        
        ref.observeSingleEvent(of: .value) { snap in
            var fetchedChats: [Chat] = []
            
            if snap.exists(), let value = snap.value {
                let messages = CommonUtils.getDictionary(value).map { $0.value }
                
                CommonUtils.getModelFromAny(model: [Chat].self, data: messages) { list in
                    // Sort messages by timestamp
                    let sortedList = list.sorted { chatOne, chatTwo in
                        return (chatOne.getCreatedOn() ?? Date()) < (chatTwo.getCreatedOn() ?? Date())
                    }
                    
                    // Add unique keys to prevent duplication
                    for chat in sortedList {
                        let key = (chat.senderId ?? "") + (chat.times ?? "")
                        self.existingKeys.insert(key)
                    }
                    
                    fetchedChats = sortedList
                    self.delegate?.getAllMsg(list: fetchedChats)
                    
                    // Start listening for new messages after loading existing ones
                    self.getNewChat()
                }
            } else {
                // No chat exists
                self.delegate?.getAllMsg(list: [])
                self.getNewChat()
            }
        }
    }
    
    func getNewChat() {
        self.chatReference?.observe(.childAdded, with: { snap in
            guard let value = snap.value else { return }
            
            CommonUtils.getModelFromAny(model: Chat.self, data: value) { message in
                // Generate unique key safely
                let key = (message.senderId ?? "") + (message.times ?? "")
                
                // Only append new messages
                if !self.existingKeys.contains(key) {
                    self.existingKeys.insert(key)
                    self.hostVC.getNewMsgHanlder(msg: message)
                }
            }
        })
    }
    
    public func sendMsg(msg: String, type: String, by: String = "user") {
        guard let detail = Global.shared.user,
              let id = detail.id,
              let ref = self.chatReference else { return }
        
//        TranslationService.translateToArabic(msg) { arabicText in
//            let formatter = ISO8601DateFormatter()
//            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//            let isoDate = formatter.string(from: Date())
//            let chat = Chat(
//                uniqueId: self.chatDetailsUniqueId,
//                senderId: String(id),
//                type: type,
//                message: msg,
//                messageAr: arabicText,
//                by: by,
//                read: 0,
//                times: isoDate)
//            
//            ref.childByAutoId()
//                .updateChildValues(chat.toBackendDictionary(uniqueId: self.chatDetailsUniqueId))
//        }
        
    }
    
    
}
