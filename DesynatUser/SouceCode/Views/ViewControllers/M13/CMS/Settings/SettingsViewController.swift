//
//  SettingsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var pushNotificationToggleImageView: UIImageView!
    @IBOutlet weak var inAppToggleImageView: UIImageView!
    
    var comingUserRole: UserRoleType = .normalUser
    private lazy var viewModel = SettingsViewModel(hostVC: self)
    var isAppNotification = false
    var isPushNotification = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch comingUserRole {
            case .normalUser:
                viewModel.getProfile()
        case .affilaiteUser:
            viewModel.affiliateUserGetProfile()
        }
        
    }
    
    @IBAction func inappDidTapped(_ sender: Any) {
        switch comingUserRole {
            case .normalUser:
            viewModel.updateInAppNotificationSettingRequest()
        case .affilaiteUser:
            viewModel.affiliateUserInAppNotificationSettingRequest()
        }
    }
    
    @IBAction func pushDidTapped(_ sender: Any) {
        switch comingUserRole {
            case .normalUser:
            viewModel.updatePushNotificationSettingRequest()
        case .affilaiteUser:
            viewModel.affiliateUserPushNotificationSettingRequest()
        }
    }
    
    @IBAction func deleteAccountDidTapped(_ sender: Any) {
        let nextVC = DeleteAccountViewController.instantiate(fromAppStoryboard: .DashBoard)
        nextVC.onYesTapped = { [weak self] in
            guard let self = self else { return }
            self.deleteAccountRequest()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteAccountRequest(){
        //        WebService.sharedInstance.logoutService() { (response) in
        //            kSharedSceneDelegate.logoutUser()
        //            kSharedSceneDelegate.navigateToLoginVc()
        //            UserDefaults.standard.setValue("No", forKey:"isLogin")
        //        }
    }
    // MARK: - UI Update
    func updateAppNotificationUI() {
        let imageName = isAppNotification ? "toggleOn" : "toggleOff"
        inAppToggleImageView.image = UIImage(named: imageName)
    }
    
    func updatePushNotificationUI() {
        let imageName = isPushNotification ? "toggleOn" : "toggleOff"
        pushNotificationToggleImageView.image = UIImage(named: imageName)
    }
    
}
