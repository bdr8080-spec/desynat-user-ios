//
//  MyAffiliatedWithdrawalTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class MyAffiliatedWithdrawalTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionView: UIStackView!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var creditOnView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(requestType: WithdrawRequestType) {
        transactionView.isHidden = true
        creditOnView.isHidden = true
        switch requestType {
        case .upcoming:
            statusLabel.text = "Pending"
            statusLabel.textColor = UIColor(hexString: "#FE7D49")
        case .completed:
            transactionView.isHidden = false
            creditOnView.isHidden = false
            statusLabel.text = " Credited"
            statusLabel.textColor = UIColor(hexString: "#17854C")
        }
    }
    
}
