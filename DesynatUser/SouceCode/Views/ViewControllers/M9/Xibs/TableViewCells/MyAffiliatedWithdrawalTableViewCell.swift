//
//  MyAffiliatedWithdrawalTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class MyAffiliatedWithdrawalTableViewCell: UITableViewCell {

    @IBOutlet weak var requestedOnDateLabel: CustomLabelFont!
    @IBOutlet weak var transactionView: UIStackView!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var creditOnView: UIStackView!
    @IBOutlet weak var requestIdLabel: CustomLabelFont!
    @IBOutlet weak var transactionIdLabel: CustomLabelFont!
    @IBOutlet weak var accountNumberLabel: CustomLabelFont!
    @IBOutlet weak var totalAmountLabel: CustomLabelFont!
    @IBOutlet weak var creditedOnLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
    
    func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = isoFormatter.date(from: isoDate) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy at hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }

    
}
