//
//  ChatInboxListViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class ChatInboxListViewController: UIViewController {

  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var inboxTableView: UITableView! {
    didSet {
      inboxTableView.registerCellFromNib(cellID: "ChatInboxTableViewCell")
    }
  }
  private var searchWorkItem: DispatchWorkItem?
  private lazy var viewModel = ChatInboxListViewModel(hostVC: self)
  
  override func viewDidLoad() {
        super.viewDidLoad()
    searchTF.delegate = self
    }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func filtreDidTapped(_ sender: Any) {
    let vc = ChatFilterViewController.instantiate(fromAppStoryboard: .Chat)
    vc.selectedFilter = viewModel.appliedFilter
    vc.onApplyFilter = { [weak self] filter in
        guard let self = self else { return }
        self.viewModel.appliedFilter = filter
//        self.viewModel.currentPage = 1
//        self.viewModel.getAllOrders()
    }
    vc.onClearFilter = { [weak self] in
        guard let self = self else { return }
        self.viewModel.appliedFilter = ChatsFilterModel()
//        self.viewModel.currentPage = 1
//        self.viewModel.getAllOrders()
    }
    self.navigationController?.present(vc, animated: false)
  }
}


extension ChatInboxListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInboxTableViewCell", for: indexPath) as! ChatInboxTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ChatDetailsViewController.instantiate(fromAppStoryboard: .Chat)
    if indexPath.row == 0 {
      nextVC.chatType = .quotationAccepted
    } else if indexPath.row == 1 {
      nextVC.chatType = .quotationReceived
    } else if indexPath.row == 2 {
      nextVC.chatType = .requestSentForCustomization
    } else {
      nextVC.chatType = .normalChatWithDealer
    }
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
}

extension ChatInboxListViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
//      self.viewModel.searchText = currentText
//      viewModel.getProductsApi()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}
