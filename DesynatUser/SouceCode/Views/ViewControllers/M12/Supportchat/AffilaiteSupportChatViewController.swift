//
//  AffilaiteSupportChatViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit
import IQKeyboardManagerSwift

class AffilaiteSupportChatViewController: UIViewController {
    
    @IBOutlet weak var chatDetailsTableView: UITableView! {
        didSet {
            chatDetailsTableView.registerCellFromNib(cellID: "SenderChatTableViewCell")
            chatDetailsTableView.registerCellFromNib(cellID: "ReceiverChatTableViewCell")
            chatDetailsTableView.registerCellFromNib(cellID: "ReciverChatForImageTableViewCell")
            chatDetailsTableView.registerCellFromNib(cellID: "SenderChatForImageTableViewCell")
        }
    }
    @IBOutlet weak var baseScrollView:UIScrollView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var baseBottomConstraint: NSLayoutConstraint!
    
    private lazy var viewModel = AffilaiteSupportChatViewModel(hostVC: self)
    var chatList:[Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [AffilaiteSupportChatViewController.self]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.viewModel.checkForEnquiryChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAttachmentDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController { image, _ in
            guard let image else { return }
            WebService.sharedInstance.uploadImage(withParams: image) { [weak self] imageURL in
                self?.handleSendMessage(msg: imageURL.url ?? "", type: "1")
            }
        }
    }
    
    @IBAction func sendMessageDidTapped(_ sender: Any) {
        guard let txt = self.messageTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), !txt.isEmpty else {
            self.showAlert(msg: "Please Enter Text to Send Message".localiz())
            return
        }
        self.messageTF.text = nil
        handleSendMessage(msg: txt, type: "0")
    }
    
    //MARK: Function's declaration
    func handleSendMessage(msg: String, type: String) {
        self.viewModel.sendMsg(msg: msg, type: type)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        let inputViewHeight = messageTF.superview?.bounds.height ?? 0
        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            // Move input view above keyboard (inverted constraint)
            self.baseBottomConstraint.constant = -keyboardHeight - 15
            // ScrollView inset = input view height ONLY
            self.baseScrollView.contentInset.bottom = inputViewHeight
            self.baseScrollView.verticalScrollIndicatorInsets.bottom = inputViewHeight
            self.view.layoutIfNeeded()
        }
        scrollToBottom()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            
            self.baseBottomConstraint.constant = 0
            self.baseScrollView.contentInset = .zero
            self.baseScrollView.verticalScrollIndicatorInsets = .zero
            
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollChatToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let rows = self.chatDetailsTableView.numberOfRows(inSection: 0)
            guard rows > 0 else { return }
            
            let indexPath = IndexPath(row: rows - 1, section: 0)
            self.chatDetailsTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func getNewMsgHanlder(msg: Chat) {
        self.chatList.append(msg)
        DispatchQueue.main.async {
            self.chatDetailsTableView.reloadData()
            self.updateNoChatUI()
            self.scrollToBottom()
        }
    }
    
    private func updateNoChatUI() {
        let hasChats = !chatList.isEmpty
        chatDetailsTableView.isHidden = !hasChats
    }
    
}

// MARK: - TABLE VIEW METHODS
extension AffilaiteSupportChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatList[indexPath.row]
        let isSentByMe = chat.by == "user"
        
        if chat.type == "1" {   // image
            if isSentByMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverChatForImageTableViewCell", for: indexPath) as! ReciverChatForImageTableViewCell
                cell.configData(data: chat)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatForImageTableViewCell", for: indexPath) as! SenderChatForImageTableViewCell
                cell.configData(data: chat)
                return cell
            }
        } else {                // text
            if isSentByMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as! ReceiverChatTableViewCell
                cell.configData(data: chat)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
                cell.configData(data: chat)
                return cell
            }
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let contentHeight = self.baseScrollView.contentSize.height
            let scrollViewHeight = self.baseScrollView.bounds.height
            let bottomInset = self.baseScrollView.contentInset.bottom
            
            let yOffset = max(0, contentHeight - scrollViewHeight + bottomInset)
            self.baseScrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }
}

extension AffilaiteSupportChatViewController : ChatViewModelDelegate {
    
    func getAllMsg(list: [Chat]) {
        self.chatList = list
        self.chatDetailsTableView.reloadData()
        updateNoChatUI()
        self.scrollToBottom()
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AffilaiteSupportChatViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: baseScrollView)
        baseScrollView.scrollRectToVisible(rect, animated: true)
    }
}
