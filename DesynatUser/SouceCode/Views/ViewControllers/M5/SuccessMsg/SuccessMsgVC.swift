//
//  SuccessMsgVC.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit

class SuccessMsgVC: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var lblSuccesMsg: CustomLabelFont!
    
    // MARK: - Property Decalaration
    var message: String = ""
    var OnDismiss: (()->())?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSuccesMsg.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dismiss(animated: true) {
                self.OnDismiss?()
            }
        }
    }
    
}
