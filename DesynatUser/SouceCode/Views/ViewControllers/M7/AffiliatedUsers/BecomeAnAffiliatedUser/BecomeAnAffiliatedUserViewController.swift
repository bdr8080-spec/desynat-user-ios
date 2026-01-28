//
//  BecomeAnAffiliatedUserViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class BecomeAnAffiliatedUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func existingUserDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func newUserDidTapped(_ sender: Any) {
//        let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
//        vc.comingUserRole = .affiliateUser
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
