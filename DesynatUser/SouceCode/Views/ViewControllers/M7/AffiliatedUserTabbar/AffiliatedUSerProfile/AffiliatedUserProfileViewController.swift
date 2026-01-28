//
//  AffiliatedUserProfileViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserProfileViewController: UIViewController {

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
        SideMenuModel(title: "My Withdrawals", image: "myWithdroawsl"),
        SideMenuModel(title: "Terms & Condition", image: "terms"),
        SideMenuModel(title: "About Us", image: "aboutus"),
        SideMenuModel(title: "FAQ's", image: "faq"),
        SideMenuModel(title: "Change Language", image: "changeLanguage"),
        SideMenuModel(title: "Change Currency", image: "currency"),
        SideMenuModel(title: "Change Country", image: "countryChange"),
        SideMenuModel(title: "Cancellation Policy", image: "cancellation"),
        SideMenuModel(title: "Support", image: "support"),
        SideMenuModel(title: "Settings", image: "settings")]
    
    private lazy var viewModel = AffilatedUserProfileViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//            viewModel.getUserData()
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
            self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
                guard let self = self else { return }
                self.viewModel.logoutAPI()
            }
    }
    
    
    @IBAction func pencilButtonAction(_ sender: Any) {
//            let vc = ProfileDetailsViewController.instantiate(fromAppStoryboard: .Profile)
//            self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

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
                print("✅ Selected: My Wallet")
                
            case "Terms & Condition":
                print("✅ Selected: Terms & Condition")
                
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
                
            case "Support":
                print("✅ Selected: Support")
                
            case "Settings":
                print("✅ Selected: Settings")
                
            default:
                print("⚠️ Unknown option selected: \(selectedItem)")
            }
            
            // Deselect the row
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



