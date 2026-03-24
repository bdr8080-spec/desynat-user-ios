//
//  ProfileViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var logoutImageView: UIImageView!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var sideMenuHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTableView: UITableView! {
        didSet {
            sideMenuTableView.registerCellFromNib(cellID: "SideMenuTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var sideMenuData: [SideMenuModel] = [
        SideMenuModel(title: "My Wallet", image: "mywallet"),
        SideMenuModel(title: "Terms & Condition", image: "terms"),
        SideMenuModel(title: "Return Policy", image: "return"),
        SideMenuModel(title: "About Us", image: "aboutus"),
        SideMenuModel(title: "FAQ's", image: "faq"),
        SideMenuModel(title: "Change Language", image: "changeLanguage"),
        SideMenuModel(title: "Change Currency", image: "currency"),
        SideMenuModel(title: "Change Country", image: "countryChange"),
        SideMenuModel(title: "Cancellation Policy", image: "cancellation"),
        SideMenuModel(title: "Exchange Policy", image: "exchange"),
        SideMenuModel(title: "Support", image: "support"),
        SideMenuModel(title: "Become An Affiliate", image: "becomeAn"),
        SideMenuModel(title: "Settings", image: "settings")]
    private lazy var viewModel = ProfileViewModel(hostVC: self)
    let isGuestLogin = UserDefaults.standard.string(forKey:"isGuestLogin")
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isGuestLogin == "true" {
            emailLabel.isHidden = true
            usernameLabel.text = "Hello Guest"
            userProfileImageView.image = UIImage(named: "userProfile")
            logoutLabel.text = "Login"
            logoutImageView.isHidden = true
        } else {
            emailLabel.isHidden = false
            viewModel.getUserData()
            logoutLabel.text = "Logout"
            logoutImageView.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight()
    }
    
    // MARK: - Button's Action
    @IBAction func maySavedCardsDidTapped(_ sender: Any) {
        if isGuestLogin == "true" {
            showLoginAlert()
        } else {
            
        }
    }
    
    @IBAction func btnTapLogout(_ sender: UIButton) {
        if isGuestLogin == "true" {
            kSharedSceneDelegate.navigateToLoginVc()
        } else {
            self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
                guard let self = self else { return }
                self.viewModel.logoutAPI()
            }
        }
    }
    
    @IBAction func pencilButtonAction(_ sender: Any) {
        if isGuestLogin == "true" {
            showLoginAlert()
        } else {
            let vc = ProfileDetailsViewController.instantiate(fromAppStoryboard: .Profile)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func savedAddressDidTapped(_ sender: Any) {
        if isGuestLogin == "true" {
            showLoginAlert()
        } else {
            let vc = SavedAddressViewController.instantiate(fromAppStoryboard: .Profile)
            vc.comingFromBag = false
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func giftCardsDidTapped(_ sender: Any) {
        if isGuestLogin == "true" {
            showLoginAlert()
        } else {
            let vc = GiftCardsListViewController.instantiate(fromAppStoryboard: .Profile)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnMyOrder(_ sender: Any) {
        if isGuestLogin == "true" {
            showLoginAlert()
        } else {
            let vc = MyOrderVC.instantiate(fromAppStoryboard: .MyOrder)
            vc.comingFromOrderTracking = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: Function's declaration
    private func updateTableHeight() {
        DispatchQueue.main.async {
            self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
        }
    }
    
}

// MARK: - TABLE VIEW METHODS
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        let item = sideMenuData[indexPath.row]
        cell.configData(data: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isGuestLogin == "true" {
            showLoginAlert()
        } else {
            let selectedItem = sideMenuData[indexPath.row].title
            
            switch selectedItem {
            case "My Wallet":
                let nextVC = WalletMoneyListViewController.instantiate(fromAppStoryboard: .Profile)
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            case "Terms & Condition":
                let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
                vc.comingReason = .termsAndConditions
                vc.comingUserRole = .normalUser
                self.navigationController?.pushViewController(vc, animated: true)
                
            case "Return Policy":
                let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
                vc.comingReason = .returnPolicy
                vc.comingUserRole = .normalUser
                self.navigationController?.pushViewController(vc, animated: true)
                
            case "About Us":
                let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
                vc.comingReason = .aboutUs
                vc.comingUserRole = .normalUser
                self.navigationController?.pushViewController(vc, animated: true)
                
            case "FAQ's":
                let vc = FAQViewController.instantiate(fromAppStoryboard: .DashBoard)
                vc.comingUserRole = .normalUser
                self.navigationController?.pushViewController(vc, animated: true)
                
            case "Change Language":
                let nextVC = ChangeLanguageViewController.instantiate(fromAppStoryboard: .DashBoard)
                nextVC.comingUserRole = .normalUser
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            case "Change Currency":
                let nextVC = ChangeCurrencyViewController.instantiate(fromAppStoryboard: .DashBoard)
                nextVC.comingReason = .comingFromCurrency
                nextVC.comingUserRole = .normalUser
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            case "Change Country":
                let nextVC = ChangeCurrencyViewController.instantiate(fromAppStoryboard: .DashBoard)
                nextVC.comingReason = .comingFromCountry
                nextVC.comingUserRole = .normalUser
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            case "Cancellation Policy":
                let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
                vc.comingReason = .cancellationPolicy
                vc.comingUserRole = .normalUser
                self.navigationController?.pushViewController(vc, animated: true)
                
            case "Exchange Policy":
                let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
                vc.comingReason = .exchangePolicy
                vc.comingUserRole = .normalUser
                self.navigationController?.pushViewController(vc, animated: true)
                
            case "Support":
                let nextVC = SupportViewController.instantiate(fromAppStoryboard: .DashBoard)
                nextVC.comingUserRole = .normalUser
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            case "Become An Affiliate":
                if let userdetails = viewModel.savedUserProfile {
                    if userdetails.affiliatedUserdetails == nil {
                        let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
                        vc.comingUserRole = .affiliateUser
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let nextVC = AffiliatedUserLoginViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
                
            case "Settings":
                let nextVC = SettingsViewController.instantiate(fromAppStoryboard: .DashBoard)
                nextVC.comingUserRole = .normalUser
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            default:
                print("Unknown option selected: \(selectedItem)")
            }
            
            // Deselect the row
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}


