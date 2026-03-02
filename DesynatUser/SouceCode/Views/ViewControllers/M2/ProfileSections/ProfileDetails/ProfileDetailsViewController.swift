//
//  ProfileDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var imgProfile: CustomImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ProfileDetailsViewModel(hostVC:self)
    var selectedProfileImageUrl:String = ""
    var isMobile = ""
    var email: String? = ""
    var mobile: String? = ""
    var countryCode: String = ""
    var comingAfterUpdate: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.isUserInteractionEnabled = false
        txtMobileNumber.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if comingAfterUpdate {
            self.txtMobileNumber.text = mobile
            self.txtCountryCode.text = countryCode
            self.txtEmail.text = email
        } else {
            viewModel.getProfileDetailsApi()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeMobileNumberAction(_ sender: Any) {
        viewModel.changeMobileNumberApi()
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        let vc = ChangePassowrdViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .fromNormalUser
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func changeEmailBtnAction(_ sender: Any) {
        viewModel.changeEmailApi()
    }
    
    @IBAction func btnTapImage(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedProfileImageUrl = uploadedUrl
                    self.imgProfile.image = image
                }
            }
        }
    }
    
    @IBAction func btnTapCountryCode(_ sender: Any) {
    }
    
    @IBAction func btnTapSaveChanges(_ sender: UIButton) {
        viewModel.updateProfileApi()
    }
    
}
