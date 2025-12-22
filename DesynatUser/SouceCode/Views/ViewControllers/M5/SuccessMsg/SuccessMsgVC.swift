//
//  SuccessMsgVC.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit

class SuccessMsgVC: UIViewController {

    @IBOutlet weak var lblSuccesMsg: CustomLabelFont!
    
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSuccesMsg.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismiss(animated: true)
        }
    }
    

}
