//
//  AffiliatedProfileDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit
import SDWebImage

class AffiliatedProfileDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var bankAccountView: UIView!
    @IBOutlet weak var addressScrollView: UIScrollView!
    @IBOutlet weak var personalInfoScrollView: UIScrollView!
    @IBOutlet weak var bankAcountButton: CustomButton!
    @IBOutlet weak var bankAccountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressButton: CustomButton!
    @IBOutlet weak var personalLabel: UILabel!
    @IBOutlet weak var personalButton: CustomButton!
    @IBOutlet weak var bankAccountTableView: UITableView! {
        didSet {
            bankAccountTableView.registerCellFromNib(cellID: "BankAccountsTableViewCell")
        }
    }
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var documentOneImageView: CustomImageView!
    @IBOutlet weak var documentTwoImageView: CustomImageView!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var addressLineOneTF: UITextField!
    @IBOutlet weak var addressLineTwoTF: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedProfileDetailsViewModel(hostVC: self)
    var uplaodDocuOneImage = ""
    var uploadDocTwoImage = ""
    var selectedProfileImageUrl = ""
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var selectedAddressCountryCode: String? = "0"
    var comingAfterUpdate: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.countryListApi()
        selectTab(.personal)
        personalInfoScrollView.isHidden = false
        bankAccountView.isHidden = true
        addressScrollView.isHidden = true
        viewModel.getUserProfileApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if comingAfterUpdate {
            viewModel.getUserProfileApi()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func personalDidTapped(_ sender: Any) {
        selectTab(.personal)
        personalInfoScrollView.isHidden = false
        bankAccountView.isHidden = true
        addressScrollView.isHidden = true
    }
    
    @IBAction func addressDidTapped(_ sender: Any) {
        selectTab(.address)
        addressScrollView.isHidden = false
        personalInfoScrollView.isHidden = true
        bankAccountView.isHidden = true
    }
    
    @IBAction func bankAccountDidTapped(_ sender: Any) {
        selectTab(.bank)
        bankAccountView.isHidden = false
        addressScrollView.isHidden = true
        personalInfoScrollView.isHidden = true
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordDidTapped(_ sender: Any) {
        let vc = ChangePassowrdViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .fromAffiliatedUser
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func addAnotherAccountDidTapped(_ sender: Any) {
        let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.comingForEdit = false
        nextVC.changesAreDone = { [weak self] in
            self?.viewModel.getUserProfileApi()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func changeProfileImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedProfileImageUrl = uploadedUrl
                    self.userProfileImageView.image = image
                }
            }
        }
    }
    
    @IBAction func changeMobileNumberAction(_ sender: Any) {
        viewModel.changeMobileNumberApi()
    }
    
    @IBAction func countryCodeDidTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func emailChangeDidTapped(_ sender: Any) {
        viewModel.changeEmailApi()
    }
    
    @IBAction func uploadDocumnetOneDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.uplaodDocuOneImage = imageURL.url ?? ""
                    if let url = URL(string: imageURL.url ?? "") {
                        self.documentOneImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.documentOneImageView.sd_setImage(with: url,placeholderImage: .uploadDoc1)
                    }
                }
            }
        }
    }
    
    @IBAction func uploadDocumnetTwoDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.uploadDocTwoImage = imageURL.url ?? ""
                    if let url = URL(string: imageURL.url ?? "") {
                        self.documentTwoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.documentTwoImageView.sd_setImage(with: url,placeholderImage: .uploaddoc2)
                    }
                }
            }
        }
    }
    
    @IBAction func personalInfoSaveChangesDidTapped(_ sender: Any) {
        if viewModel.validatePersonalInfoFields() {
            viewModel.updateAffiliatedProfileService()
        }
    }
    
    @IBAction func locationdidTapped(_ sender: Any) {
        let vc = LocationViewController.instantiate(fromAppStoryboard: .Profile)
        vc.preSelectedLat = self.latitude   // your saved lat
        vc.preSelectedLng = self.longitude  // your saved long
        vc.comingReason = .affiliateUserAccountCreation
        vc.locationCallBack = { [weak self] address, localityName, locality, city, state, country, pincode, lat, long in
            guard let self = self else { return }
            let safeAddress = address.isEmpty ? "" : address
            let safeLocality = locality.isEmpty ? "" : locality
            let safeCity = city.isEmpty ? "" : city
            let safeState = state.isEmpty ? "" : state
            let safePincode = pincode.isEmpty ? "" : pincode
            self.locationTF.text = safeAddress
            var addressLineOne: [String] = []
            if !localityName.isEmpty {
                addressLineOne.append(localityName)
            }
            if !safeLocality.isEmpty {
                addressLineOne.append(safeLocality)
            }
            self.addressLineOneTF.text = addressLineOne.joined(separator: ", ")
            
            var components: [String] = []
            
            if !safeCity.isEmpty {
                components.append(safeCity)
            }
            if !safeState.isEmpty {
                components.append(safeState)
            }
            
            var address = components.joined(separator: ", ")
            
            if !safePincode.isEmpty {
                address += " - \(safePincode)"
            }
            self.addressLineTwoTF.text = address
            self.latitude = lat
            self.longitude = long
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryList.map { country -> String in
            let name = country.name ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag) \(name)"
        }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryList[index]
            let name = selectedCountry.name
            self.countryTF.text = name
            self.selectedAddressCountryCode = selectedCountry.id?.description ?? "0"
        }
    }
    
    @IBAction func adressSaveChnagesDidTapped(_ sender: Any) {
        if viewModel.validateAddressFields() {
            viewModel.updateAffiliatedAddressService()
        }
    }
    
    //MARK: Function's declaration
    private func selectTab(_ tab: ProfileTab) {
        let buttons = [personalButton, addressButton, bankAcountButton]
        let labels = [personalLabel, addressLabel, bankAccountLabel]
        for button in buttons {
            button?.setImage(UIImage(named: ""), for: .normal)
            button?.layer.cornerRadius = 0
            button?.layer.maskedCorners = []
            button?.clipsToBounds = true
        }
        for label in labels {
            label?.textColor = .black
        }
        switch tab {
        case .personal:
            personalButton.setImage(UIImage(named: "topTabbar"), for: .normal)
            personalButton.layer.cornerRadius = 5
            personalButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            personalLabel.textColor = .white
        case .address:
            addressButton.setImage(UIImage(named: "topTabbar"), for: .normal)
            addressLabel.textColor = .white
        case .bank:
            bankAcountButton.setImage(UIImage(named: "topTabbar"), for: .normal)
            bankAcountButton.layer.cornerRadius = 5
            bankAcountButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            bankAccountLabel.textColor = .white
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedProfileDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.affiliatedUserProfile?.bankDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccountsTableViewCell", for: indexPath) as! BankAccountsTableViewCell
        cell.configData(data: viewModel.affiliatedUserProfile?.bankDetails?[indexPath.row])
        cell.editButtonAction = { [weak self] in
            let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            nextVC.comingForEdit = true
            nextVC.bankDetail = self?.viewModel.affiliatedUserProfile?.bankDetails?[indexPath.row]
            nextVC.changesAreDone = { [weak self] in
                self?.viewModel.getUserProfileApi()
            }
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        cell.deleteButtonAction = { [weak self] in
            self?.showConfirmationAlert(msg: "Are you sure you want to delete this account?".localiz()){ [weak self] in
                guard let self = self else { return }
                viewModel.deleteBankAccountAffilaitedUserApi(id: viewModel.affiliatedUserProfile?.bankDetails?[indexPath.row].id ?? 0)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.makeDefaultBankAccountAffilaitedUserApi(id: viewModel.affiliatedUserProfile?.bankDetails?[indexPath.row].id ?? 0)
    }
    
}

