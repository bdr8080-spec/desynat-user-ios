//
//  PromoCodeListViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import CoreFoundation
import UIKit

class PromoCodeListViewController: UIViewController {
  
  @IBOutlet weak var SearchTF: UITextField!
  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var tableview: UITableView! {
    didSet {
      tableview.registerCellFromNib(cellID: "PromoCodeTableViewCell")
    }
  }
  
  private lazy var viewModel = PromoCodeListViewModel(hostVC: self)
  var deliveryAddress: Int = 0
  var expandedRows = Set<Int>()
  private var searchWorkItem: DispatchWorkItem?
  var onPromoSelected: ((GetPromoCodeListDataModel) -> Void)?
  var selectedPromocode: GetPromoCodeListDataModel?
  var totalAmount: Double = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getAllPromocodeList()
    SearchTF.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableview.visibleCells.forEach { cell in
      (cell as? PromoCodeTableViewCell)?.setNeedsLayout()
    }
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    viewModel.applyPromocode()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension PromoCodeListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.promocodeList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeTableViewCell", for: indexPath) as! PromoCodeTableViewCell
    let data = viewModel.promocodeList[indexPath.row]
    let isExpanded = expandedRows.contains(indexPath.row)
    cell.configure(data: data, expanded: isExpanded)
    cell.onExpansionChanged = { [weak self] in
      guard let self = self else { return }
      if self.expandedRows.contains(indexPath.row) {
        self.expandedRows.remove(indexPath.row)
      } else {
        self.expandedRows.insert(indexPath.row)
      }
      self.tableview.reloadRows(at: [indexPath], with: .automatic)
    }
    cell.isPromoApplied = { [weak self] in
      guard let self else { return }
      onPromoSelected?(data)
      selectedPromocode = data
      viewModel.applyPromocode()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}


extension PromoCodeListViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      viewModel.getAllPromocodeList()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
  
}
