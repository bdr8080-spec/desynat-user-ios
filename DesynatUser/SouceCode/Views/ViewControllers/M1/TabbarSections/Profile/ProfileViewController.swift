//
//  ProfileViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
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
    
    private func updateTableHeight() {
        DispatchQueue.main.async {
            self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
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
          UserDefaults.standard.setValue("false", forKey:"isGuestLogin")
            kSharedSceneDelegate.navigateToLoginVc()
        } else {
            let vc = ProfileDetailsViewController.instantiate(fromAppStoryboard: .Profile)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func savedAddressDidTapped(_ sender: Any) {
        let vc = SavedAddressViewController.instantiate(fromAppStoryboard: .Profile)
      vc.comingFromBag = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
  
  @IBAction func giftCardsDidTapped(_ sender: Any) {
    let vc = GiftCardsListViewController.instantiate(fromAppStoryboard: .Profile)
    self.navigationController?.pushViewController(vc, animated: false)
  }
    
    @IBAction func btnMyOrder(_ sender: Any) {
        let vc = MyOrderVC.instantiate(fromAppStoryboard: .MyOrder)
      vc.comingFromOrderTracking = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

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
            kSharedSceneDelegate.navigateToLoginVc()
        } else {
            
            let selectedItem = sideMenuData[indexPath.row].title
            
            switch selectedItem {
            case "My Wallet":
                print("✅ Selected: My Wallet")
                
            case "Terms & Condition":
                print("✅ Selected: Terms & Condition")
                
            case "Return Policy":
                print("✅ Selected: Return Policy")
                
            case "About Us":
                print("✅ Selected: About Us")
                
            case "FAQ's":
                print("✅ Selected: FAQ's")
                
            case "Change Language":
                print("✅ Selected: Change Language")
                
            case "Change Currency":
                print("✅ Selected: Change Currency")
                
            case "Change Country":
                print("✅ Selected: Change Country")
                
            case "Cancellation Policy":
                print("✅ Selected: Cancellation Policy")
                
            case "Exchange Policy":
                print("✅ Selected: Exchange Policy")
                
            case "Support":
                print("✅ Selected: Support")
                
            case "Become An Affiliate":
                print("✅ Selected: Become An Affiliate")
                
            case "Settings":
                print("✅ Selected: Settings")
                
            default:
                print("⚠️ Unknown option selected: \(selectedItem)")
            }
            
            // Deselect the row
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}


