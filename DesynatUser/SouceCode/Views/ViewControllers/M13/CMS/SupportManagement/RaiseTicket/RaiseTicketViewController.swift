//
//  RaiseTicketViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class RaiseTicketViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    
    var comingUserRole: UserRoleType = .normalUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Navigation
    
    @IBAction func crossBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setUpUI(){
        titleView.layer.cornerRadius = 24
        titleView.layer.maskedCorners = [
            .layerMinXMinYCorner, // top-left
            .layerMaxXMinYCorner  // top-right
        ]
        titleView.clipsToBounds = true
    }
    
}
