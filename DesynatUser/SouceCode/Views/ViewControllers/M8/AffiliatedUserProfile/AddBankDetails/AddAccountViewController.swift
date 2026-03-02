//
//  AddAccountViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmAccountNumberTF: UITextField!
    @IBOutlet weak var accountNumberTF: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var swiftTextField: UITextField!
    @IBOutlet weak var ibanTextField: UITextField!
    @IBOutlet weak var accountHolderTextField: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AddAccountViewModel(hostVC: self)
    var comingForEdit: Bool = false
    var bankDetail: BankDetail?
    var changesAreDone: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ibanTextField.delegate = self
        swiftTextField.delegate = self
        bankNameTextField.delegate = self
        accountHolderTextField.delegate = self
        viewModel.populateData()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if comingForEdit {
                viewModel.updateAccountApi()
            } else {
                viewModel.addAccountApi()
            }
        }
    }
}

