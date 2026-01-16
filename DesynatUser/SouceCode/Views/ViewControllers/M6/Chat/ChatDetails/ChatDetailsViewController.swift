//
//  ChatDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import UIKit
import IQKeyboardManagerSwift


class ChatDetailsViewController: UIViewController {
  
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var payNowView: UIView!
  @IBOutlet weak var detailsView: UIView!
  @IBOutlet weak var baseScrollView:UIScrollView!
  @IBOutlet weak var baseBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var productDetailsView: CustomView!
  @IBOutlet weak var messageTF: UITextField!
  @IBOutlet weak var productDetailsActionButtonStackView: UIStackView!
  @IBOutlet weak var totalAmountLabel: UILabel!
  @IBOutlet weak var taxLabel: UILabel!
  @IBOutlet weak var shippingPriceLabel: UILabel!
  @IBOutlet weak var itemPriceLabel: UILabel!
  @IBOutlet weak var customOrderLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var totalQuantityLabel: UILabel!
  @IBOutlet weak var acceptView: UIView!
  @IBOutlet weak var rejectView: CustomView!
  @IBOutlet weak var actionButtonView: UIStackView!
  @IBOutlet weak var productPriceView: CustomView!
  @IBOutlet weak var requestIdLabel: UILabel!
  @IBOutlet weak var mainHeaderView: UIView!
  @IBOutlet weak var chatDetailsTableView: UITableView! {
    didSet {
      chatDetailsTableView.registerCellFromNib(cellID: "SenderChatTableViewCell")
      chatDetailsTableView.registerCellFromNib(cellID: "ReceiverChatTableViewCell")
      chatDetailsTableView.registerCellFromNib(cellID: "ReciverChatForImageTableViewCell")
      chatDetailsTableView.registerCellFromNib(cellID: "SenderChatForImageTableViewCell")
    }
  }
  
  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "OrderForChatTableViewCell")
    }
  }
  var chatType: ChatType = .normalChatWithDealer
  lazy var viewModel = ChatEnquiryViewModel(hostVC: self)
  var chatList:[Chat] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsViewController.self]
    self.viewModel.callBackRefresh = {
      self.handleUIUpdate()
      self.baseScrollView.setNeedsDisplay()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    self.viewModel.singleChatDetailRequest()
    self.viewModel.checkForEnquiryChat()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func payNowDidTapped(_ sender: Any) {
    let nextVC = PlaceOrderPaymentMethodsViewController.instantiate(fromAppStoryboard: .MyBag)
nextVC.customChatUniqueId = viewModel.chatDetailsUniqueId
nextVC.comingForCustomeOrderPlace = true
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @IBAction func acceptDidTapped(_ sender: Any) {
    viewModel.acceptAndRejectOrderQuotationDetails(status: "5")
  }
  
  @IBAction func rejectDidTapped(_ sender: Any) {
    viewModel.acceptAndRejectOrderQuotationDetails(status: "4")
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
      self.showAlert(msg: "Please Enter Text to Send Message")
      return
    }
    self.messageTF.text = nil
    handleSendMessage(msg: txt, type: "0")
  }
  
  func handleSendMessage(msg: String, type: String) {
    self.viewModel.sendMsg(msg: msg, type: type)
  }
  
  func handleUIUpdate() {
    let quotationData = viewModel.quotationData
    let messageType = quotationData?.type ?? "1" // normal msg, customization send
    let requestType = quotationData?.productRequest ?? "1"
    let actiontype = quotationData?.action ?? "1"
    userNameLabel.text = quotationData?.userDetails?.fullName ?? ""
    if messageType == "1" {
      productTableView.isHidden = true
      mainHeaderView.backgroundColor = .white
      productDetailsView.isHidden = true
      productDetailsActionButtonStackView.isHidden = true
      requestIdLabel.isHidden = true
      productPriceView.isHidden = true
      detailsView.backgroundColor = .white
      detailsStackView.isHidden = true
        detailsView.isHidden = true
    } else {
      productTableView.isHidden = false
      detailsStackView.isHidden = false
      payNowView.isHidden = true
      mainHeaderView.backgroundColor = UIColor(hex: "#FFF7EA")
      detailsView.backgroundColor = UIColor(hex: "#FFF7EA")
        detailsView.isHidden = false
      productDetailsView.isHidden = false
      productDetailsActionButtonStackView.isHidden = false
      requestIdLabel.isHidden = false
      requestIdLabel.text = "Request Id #\(quotationData?.id ?? 0)"
      totalQuantityLabel.text = quotationData?.quantity
      productTableView.reloadData()
      addressLabel.text = viewModel.buildFullAddress(from: quotationData?.deliveryDetails)
      customOrderLabel.text = quotationData?.customDetails
      itemPriceLabel.text = CommonUtils.formatPriceStringInput(quotationData?.price)
      shippingPriceLabel.text = CommonUtils.formatPriceStringInput(quotationData?.shipping)
      taxLabel.text = CommonUtils.formatPriceStringInput(quotationData?.tax)
        totalAmountLabel.text = quotationData?.totalAmount//CommonUtils.formatPriceStringInput(quotationData?.totalAmount)
      switch actiontype {
      case "0": //user sent chat for customization new
          requestIdLabel.isHidden = true
        productDetailsView.isHidden = true
        productPriceView.isHidden = true
        productDetailsActionButtonStackView.isHidden = true
        if requestType == "1" {
            requestIdLabel.isHidden = false
          productDetailsView.isHidden = false
        }
      case "1": //"Quotation Sent"
        productDetailsView.isHidden = true
        actionButtonView.isHidden = false
        productPriceView.isHidden = false
      case "2":
        productDetailsView.isHidden = true
        productPriceView.isHidden = false
        productDetailsActionButtonStackView.isHidden = false
        payNowView.isHidden = true
        actionButtonView.isHidden = false
        //        }
      case "5":
        productDetailsView.isHidden = true
        productPriceView.isHidden = false
        productDetailsActionButtonStackView.isHidden = false
        payNowView.isHidden = false
        actionButtonView.isHidden = true
        let isOrderPlaced = quotationData?.orderCreateStatus?.id != nil
        if isOrderPlaced {
          productPriceView.isHidden = false
          productDetailsActionButtonStackView.isHidden = true
        }
      case "4":
        productDetailsView.isHidden = true
        productPriceView.isHidden = false
        productDetailsActionButtonStackView.isHidden = true
      default:
        mainHeaderView.backgroundColor = .white
        productDetailsView.isHidden = true
        productDetailsActionButtonStackView.isHidden = true
        requestIdLabel.isHidden = true
        detailsView.backgroundColor = .white
          detailsView.isHidden = true
        productTableView.reloadData()
      }
    }
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
      
      // 1️⃣ Move input view above keyboard (inverted constraint)
      self.baseBottomConstraint.constant = -keyboardHeight - 15
      
      // 2️⃣ ScrollView inset = input view height ONLY
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
//    noChatFoundLabel.isHidden = hasChats
    chatDetailsTableView.isHidden = !hasChats
  }
  
  
}

extension ChatDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == productTableView {
      return 1
    } else {
      return chatList.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == productTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
      let data = viewModel.quotationData
      cell.configData(data: data)
      cell.onSendRequestTap = { [weak self] in
        guard let self = self else { return }
        let popupVC = CustomOrderPopupViewController.instantiate(fromAppStoryboard: .Chat)
        popupVC.uniqueId = self.viewModel.chatDetailsUniqueId
        popupVC.requestIsSent = {
          self.viewModel.singleChatDetailRequest()
        }
        let navVC = UINavigationController(rootViewController: popupVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
      }
      cell.onViewRequestTap = {
        let popupVC = CustomOrderDetailsPopupViewController.instantiate(fromAppStoryboard: .Chat)
        popupVC.quotationData = self.viewModel.quotationData
        self.present(popupVC, animated: true)
      }
      
      return cell
    }
    
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

extension ChatDetailsViewController : ChatViewModelDelegate {
  
  func getAllMsg(list: [Chat]) {
    self.chatList = list
    self.chatDetailsTableView.reloadData()
    updateNoChatUI()
    self.scrollToBottom()
  }
  
}

extension ChatDetailsViewController : UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let rect = textField.convert(textField.bounds, to: baseScrollView)
    baseScrollView.scrollRectToVisible(rect, animated: true)
  }
}



enum ChatType {
  case quotationReceived
  case quotationAccepted
  case requestSentForCustomization
  case normalChatWithDealer
}


// action 2 ==> (accept and reject)
//
