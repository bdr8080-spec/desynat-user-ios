//
//  ChatDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import UIKit

class ChatDetailsViewController: UIViewController {
  
  @IBOutlet weak var messageTF: UITextField!
  @IBOutlet weak var productDetailsActionButtonStackView: UIStackView!
  @IBOutlet weak var payNowView: UIView!
  @IBOutlet weak var orderDetailsStackView: UIStackView!
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
  @IBOutlet weak var productShippingDetailsView: CustomView!
  @IBOutlet weak var requestIdLabel: UILabel!
  @IBOutlet weak var headerParentView: UIView!
  @IBOutlet weak var chatDetailsTableView: UITableView! {
    didSet {
      chatDetailsTableView.registerCellFromNib(cellID: "SenderChatTableViewCell")
      chatDetailsTableView.registerCellFromNib(cellID: "ReceiverChatTableViewCell")
    }
  }
  
  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "OrderForChatTableViewCell")
    }
  }
  var chatType: ChatType = .normalChatWithDealer
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialUISetup()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func payNowDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func acceptDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func rejectDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func addAttachmentDidTapped(_ sender: Any) {
    
  }
  
  @IBAction func sendMessageDidTapped(_ sender: Any) {
    
  }
  
  private func initialUISetup() {
    orderDetailsStackView.isHidden = false
    headerParentView.backgroundColor = UIColor(hex: "#FFF7EA")
    requestIdLabel.isHidden = false
    productShippingDetailsView.isHidden = false
    productTableView.isHidden = false
    productPriceView.isHidden = true
    actionButtonView.isHidden = true
    payNowView.isHidden = true
    productDetailsActionButtonStackView.isHidden = false
    switch chatType {
    case .quotationReceived:
      actionButtonView.isHidden = false
      print("quotationReceived")
    case .quotationAccepted:
      productPriceView.isHidden = false
      productShippingDetailsView.isHidden = true
      payNowView.isHidden = false
      print("quotationAccepted")
    case .requestSentForCustomization:
      print("requestSentForCustomization")
      productShippingDetailsView.isHidden = false
      productDetailsActionButtonStackView.isHidden = true
    case .normalChatWithDealer:
      print("normalChatWithDealer")
      orderDetailsStackView.isHidden = true
      headerParentView.backgroundColor = .white
      requestIdLabel.isHidden = true
      productShippingDetailsView.isHidden = true
      productTableView.isHidden = true
      productPriceView.isHidden = true
      actionButtonView.isHidden = true
      productDetailsActionButtonStackView.isHidden = true
    }
  }
  
}

extension ChatDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == productTableView {
      return 1
    } else {
      return 10
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == productTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
      cell.onViewRequestTap = {
        let nextVC = CustomOrderDetailsPopupViewController.instantiate(fromAppStoryboard: .Chat)
        self.navigationController?.present(nextVC, animated: true)
      }
      return cell
    } else {
      if indexPath.row % 2 == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as! ReceiverChatTableViewCell
        return cell
      }
    }
  }
  
  
}

enum ChatType {
  case quotationReceived
  case quotationAccepted
  case requestSentForCustomization
  case normalChatWithDealer
}
