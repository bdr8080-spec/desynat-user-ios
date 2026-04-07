//
//  TicketDetailViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit

class TicketDetailViewController: UIViewController {

    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var raisedOnDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    var comingUserRole: UserRoleType = .normalUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

}
