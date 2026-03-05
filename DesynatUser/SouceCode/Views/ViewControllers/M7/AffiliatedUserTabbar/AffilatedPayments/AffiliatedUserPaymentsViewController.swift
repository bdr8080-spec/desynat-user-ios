//
//  AffiliatedUserPaymentsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserPaymentsViewController: UIViewController {
    
    // MARK: - IBOutlet's
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
        handleHeightOfTableView()
    }
    
    // MARK: - Button's Action
    @IBAction func withdrawDidTapped(_ sender: Any) {
        let nextVC = WithdrawMoneyViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = WithdrawalFiltersViewController.instantiate(fromAppStoryboard: .AffiliateUser)//            vc.selectedFilter = viewModel.appliedFilter
//            vc.onApplyFilter = { [weak self] filter in
//                guard let self = self else { return }
//                self.viewModel.appliedFilter = filter
//                self.viewModel.currentPage = 1
//                self.viewModel.getAllDeliveryBoy()
//            }
//            vc.onClearFilter = { [weak self] in
//                guard let self = self else { return }
//                self.viewModel.appliedFilter = WithdrawalFilterModel()
//                self.viewModel.currentPage = 1
//                self.viewModel.getAllDeliveryBoy()
//            }
            self.navigationController?.present(vc, animated: false)
    }
    
    //MARK: Function's declaration
    func handleHeightOfTableView () {
        DispatchQueue.main.async {
            self.paymentHistoryTableviewHeightConstraint.constant = self.paymentHistoryTableview.contentSize.height
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedUserPaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsHistoryTableViewCell", for: indexPath) as! PaymentsHistoryTableViewCell
        return cell
    }
}
