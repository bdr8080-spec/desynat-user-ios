//
//  AffiliatedUserPaymentsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserPaymentsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var totalRevenuwAmountLabel: CustomLabelFont!
    @IBOutlet weak var paymentHistoryTableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentHistoryTableview: UITableView! {
        didSet {
            paymentHistoryTableview.registerCellFromNib(cellID: "PaymentsHistoryTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedUserPaymentsViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentHistoryTableview.rowHeight = UITableView.automaticDimension
        paymentHistoryTableview.estimatedRowHeight = 120
        paymentHistoryTableview.isScrollEnabled = false
        searchTF.delegate = self
        viewModel.getWalletHistory()
        
    }
    
    // MARK: - Button's Action
    @IBAction func withdrawDidTapped(_ sender: Any) {
        let nextVC = WithdrawMoneyViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = WithdrawalFiltersViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
//            self.viewModel.currentPage = 1
            self.viewModel.getWalletHistory()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = WithdrawalFilterModel()
//            self.viewModel.currentPage = 1
            self.viewModel.getWalletHistory()
        }
        self.navigationController?.present(vc, animated: false)
    }
    
    //MARK: Function's declaration
    func handleHeightOfTableView() {
        paymentHistoryTableview.beginUpdates()
        paymentHistoryTableview.endUpdates()
        paymentHistoryTableview.layoutIfNeeded()
        paymentHistoryTableviewHeightConstraint.constant = paymentHistoryTableview.contentSize.height
        paymentHistoryTableview.reloadData()
    }
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedUserPaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentListData?.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsHistoryTableViewCell", for: indexPath) as! PaymentsHistoryTableViewCell
        let data = viewModel.paymentListData?.orders?[indexPath.row]
        cell.configData(data: data)
        return cell
    }
}

// MARK: - UITextField Delegate METHODS
extension AffiliatedUserPaymentsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        viewModel.searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getWalletHistory()
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
