//
//  WithdrawMoneyViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/03/26.
//

import UIKit

class WithdrawMoneyViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var accountListTableView: UITableView! {
        didSet {
            accountListTableView.registerCellFromNib(cellID: "AddedBankAccountTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = WithdrawMoneyViewModel(hostVC: self)
    private var selectedAccountIndex: Int = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnotherAccountDidTapped(_ sender: Any) {
        let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.comingForEdit = false
        nextVC.changesAreDone = { [weak self] in
            //            Again Call api here
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func submitRequestDidTapped(_ sender: Any) {
        let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .amountAddedIntoWalletForAffiliatedUser
        vc.callBackDismiss = {
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.present(vc, animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension WithdrawMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddedBankAccountTableViewCell", for: indexPath) as! AddedBankAccountTableViewCell
        if selectedAccountIndex == indexPath.row {
            cell.mainImageView.image = .radioSelected
        } else {
            cell.mainImageView.image = .radioUnselected
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAccountIndex = indexPath.row
        accountListTableView.reloadData()
    }
}
