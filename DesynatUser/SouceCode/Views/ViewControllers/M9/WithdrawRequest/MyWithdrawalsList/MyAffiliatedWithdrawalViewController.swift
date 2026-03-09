//
//  MyAffiliatedWithdrawalViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class MyAffiliatedWithdrawalViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var totalWithdrawalsLabel: CustomLabelFont!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var upcomingButtonOutlet: CustomButton!
    @IBOutlet weak var upcomingTitleLabel: UILabel!
    @IBOutlet weak var completedTitleLabel: UILabel!
    @IBOutlet weak var completedButtonOutlet: CustomButton!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "MyAffiliatedWithdrawalTableViewCell")
        }
    }
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Property Decalaration
    var requestType: WithdrawRequestType = .upcoming
    private lazy var viewModel = MyAffiliatedWithdrawalViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.getWalletHistory()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upcomingDidTapped(_ sender: Any) {
        upcomingButtonOutlet.setImage(.btnGradient, for: .normal)
        upcomingTitleLabel.textColor = .white
        completedTitleLabel.textColor = .black
        completedButtonOutlet.setImage(nil, for: .normal)
        listTableView.reloadData()
        requestType = .upcoming
        viewModel.getWalletHistory()
    }
    
    @IBAction func completedDidTapped(_ sender: Any) {
        upcomingButtonOutlet.setImage(nil, for: .normal)
        upcomingTitleLabel.textColor = .black
        completedTitleLabel.textColor = .white
        completedButtonOutlet.setImage(.btnGradient, for: .normal)
        listTableView.reloadData()
        requestType = .completed
        viewModel.getWalletHistory()
    }
    
    func handleHeightOfTableView() {
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.listTableView.contentSize.height
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension MyAffiliatedWithdrawalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moneyWithdrawalData?.withdrawRequests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAffiliatedWithdrawalTableViewCell", for: indexPath) as! MyAffiliatedWithdrawalTableViewCell
        let data = viewModel.moneyWithdrawalData?.withdrawRequests?[indexPath.row]
        cell.configData(requestType: requestType, data: data)
        return cell
    }
    
}

// MARK: - UITextField Delegate METHODS
extension MyAffiliatedWithdrawalViewController: UITextFieldDelegate {
    
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

enum WithdrawRequestType: Int {
    case upcoming = 0
    case completed = 1
}

