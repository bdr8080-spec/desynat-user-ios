//
//  PaymentsHistoryTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/03/26.
//

import UIKit

class PaymentsHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionIdLabel: CustomLabelFont!
    @IBOutlet weak var myEarningLabel: CustomLabelFont!
    @IBOutlet weak var purchasedLabel: CustomLabelFont!
    @IBOutlet weak var productNameLabel: CustomLabelFont!
    @IBOutlet weak var categoryNameLabel: CustomLabelFont!
    @IBOutlet weak var quantityLabel: CustomLabelFont!
    @IBOutlet weak var totalAmountLabel: CustomLabelFont!
    @IBOutlet weak var purchasedOnLabel: CustomLabelFont!
    @IBOutlet weak var orderStatusLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configData() {
      // Pending #FE7D49 (Orange)
        //Credited #17854C (Green)
        //Cancelled #D53B36 (Red)
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
