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
            accountListTableView.registerCellFromNib(cellID: "FooterActionTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = WithdrawMoneyViewModel(hostVC: self)
    var selectedAccountId: Int = 0
    var amountToPay: Double? = 0.0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTF.delegate = self
        viewModel.getUserBankAccountApi()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnotherAccountDidTapped(_ sender: Any) {
        let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.comingForEdit = false
        nextVC.changesAreDone = { [weak self] in
            self?.viewModel.getUserBankAccountApi()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func submitRequestDidTapped(_ sender: Any) {
        guard let finalAmount = getFinalAmount(), finalAmount > 0 else {
            showAlert(msg: "Please enter a valid amount".localiz())
            return
        }
        viewModel.affiliateSubmitWithdrawRequest()
    }
    
    //MARK: Function's declaration
    func getFinalAmount() -> Double? {
        // Check TextField first
        if let text = amountTF.text,
           !text.trimmingCharacters(in: .whitespaces).isEmpty,
           let amount = Double(text.trimmingCharacters(in: .whitespaces)) {
            return amount
        }
        
        // Else fallback to selected collection value
        return amountToPay
    }
}

// MARK: - TABLE VIEW METHODS
extension WithdrawMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.affiliatedUserBankAccount?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddedBankAccountTableViewCell", for: indexPath) as! AddedBankAccountTableViewCell
        let data = viewModel.affiliatedUserBankAccount?[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.makeDefaultBankAccountAffilaitedUserApi(id: viewModel.affiliatedUserBankAccount?[indexPath.row].id ?? 0)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FooterActionTableViewCell") as! FooterActionTableViewCell
        
        cell.addButton.addTarget(self, action: #selector(addBankAccountTapped), for: .touchUpInside)
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    @objc func addBankAccountTapped() {
        let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.comingForEdit = false
        nextVC.changesAreDone = { [weak self] in
            self?.viewModel.getUserBankAccountApi()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: -  UITextField DELEGATE METHODS
extension WithdrawMoneyViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == amountTF else { return true }
        
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Allow only numbers
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) && string != "" {
            return false
        }
        
        // Limit to 7 digits
        return updatedText.count <= 7
    }
}
