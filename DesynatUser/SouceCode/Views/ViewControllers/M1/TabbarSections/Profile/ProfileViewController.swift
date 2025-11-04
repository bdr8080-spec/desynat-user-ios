//
//  ProfileViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnTapLogout(_ sender: UIButton) {
        kSharedSceneDelegate.navigateToLoginVc()
        UserDefaults.standard.setValue("No", forKey:"isLogin")
    }
   
}
