//
//  AffiliatedUserProfileViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserProfileViewController: UIViewController {
    
    // MARK: - IBOutlet's
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
        SideMenuModel(title: "My Withdrawals", image: "myWithdroawsl"),
        SideMenuModel(title: "Terms & Condition", image: "terms"),
        SideMenuModel(title: "About Us", image: "aboutus"),
        SideMenuModel(title: "FAQ's", image: "faq"),
        SideMenuModel(title: "Change Language", image: "changeLanguage"),
        SideMenuModel(title: "Change Currency", image: "currency"),
        SideMenuModel(title: "Change Country", image: "countryChange"),
//        SideMenuModel(title: "Cancellation Policy", image: "cancellation"),
        SideMenuModel(title: "Support", image: "support"),
        SideMenuModel(title: "Settings", image: "settings")]
    private lazy var viewModel = AffilatedUserProfileViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight()
    }
    
    // MARK: - Button's Action
    @IBAction func btnTapLogout(_ sender: UIButton) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?".localiz()){ [weak self] in
            guard let self = self else { return }
            self.viewModel.logoutAPI()
        }
    }
    
    @IBAction func pencilButtonAction(_ sender: Any) {
        let vc = AffiliatedProfileDetailsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: Function's declaration
    private func updateTableHeight() {
        DispatchQueue.main.async {
            self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
        }
    }
    
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedUserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let selectedItem = sideMenuData[indexPath.row].title
        
        switch selectedItem {
        case "My Withdrawals":
            let nextVC = MyAffiliatedWithdrawalViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "Terms & Condition":
            let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
            vc.comingReason = .termsAndConditions
            vc.comingUserRole = .affilaiteUser
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "About Us":
            let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
            vc.comingReason = .aboutUs
            vc.comingUserRole = .affilaiteUser
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "FAQ's":
            let vc = FAQViewController.instantiate(fromAppStoryboard: .DashBoard)
            vc.comingUserRole = .affilaiteUser
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Change Language":
            let nextVC = ChangeLanguageViewController.instantiate(fromAppStoryboard: .DashBoard)
            nextVC.comingUserRole = .affilaiteUser
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "Change Currency":
            let nextVC = ChangeCurrencyViewController.instantiate(fromAppStoryboard: .DashBoard)
            nextVC.comingReason = .comingFromCurrency
            nextVC.comingUserRole = .affilaiteUser
            nextVC.selectedId = viewModel.savedUserProfile?.selectedCurrency ?? 1
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "Change Country":
            let nextVC = ChangeCurrencyViewController.instantiate(fromAppStoryboard: .DashBoard)
            nextVC.comingReason = .comingFromCountry
            nextVC.comingUserRole = .affilaiteUser
            nextVC.selectedId = viewModel.savedUserProfile?.selectedCountry ?? 1
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "Support":
            let nextVC = SupportViewController.instantiate(fromAppStoryboard: .DashBoard)
            nextVC.comingUserRole = .affilaiteUser
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "Settings":
            let nextVC = SettingsViewController.instantiate(fromAppStoryboard: .DashBoard)
            nextVC.comingUserRole = .affilaiteUser
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        default:
            print("Unknown option selected: \(selectedItem)")
        }
        
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
