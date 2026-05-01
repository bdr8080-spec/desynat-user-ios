//
//  PromoCodeListViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import CoreFoundation
import UIKit

class PromoCodeListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var SearchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.registerCellFromNib(cellID: "PromoCodeTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = PromoCodeListViewModel(hostVC: self)
    var deliveryAddress: Int = 0
    var expandedRows = Set<Int>()
    private var searchWorkItem: DispatchWorkItem?
    var onPromoSelected: ((PromocodeApplied, Int) -> Void)?
    var selectedPromocode: GetPromoCodeListDataModel?
    var totalAmount: Double = 0.0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllPromocodeList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.visibleCells.forEach { cell in
            (cell as? PromoCodeTableViewCell)?.setNeedsLayout()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func applyDidTapped(_ sender: Any) {
        let prmocode = SearchTF.text?.trimmed() ?? ""
        if prmocode.isEmpty {
            showAlert(msg: "Please enter Promocode".localiz())
            return
        }
        viewModel.applyPromocodeFroSearch()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW METHODS
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
            //      onPromoSelected?(data)
            selectedPromocode = data
            viewModel.applyPromocode()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
