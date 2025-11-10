//
//  ChangeMobileViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ChangeMobileViewController: UIViewController {
    private lazy var viewModel = ChangeMobileViewModel(hostVC:self)
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var comingToUpdateMobile: Bool = false
    var countryCode:String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.changeMobileNumberAndEmailApi()
        }
    }
    
    @IBAction func btnTapCountryCode(_ sender: UIButton) {
        CommonUtils.openPicker(controller: self) { code, name, callingCode in
            self.setUpCountryCode(code: callingCode)
            self.countryCode = callingCode
        }
    }
    
    func setUpCountryCode(code: String) {
        self.txtCountryCode.text = code
    }
    
    func initialSetup() {
        if comingToUpdateMobile {
            titleLabel.text = "Enter New Mobile Number"
            emailView.isHidden = true
            mobileView.isHidden = false
        } else {
            titleLabel.text = "Enter New Email "
            emailView.isHidden = false
            mobileView.isHidden = true
        }
    }
}
