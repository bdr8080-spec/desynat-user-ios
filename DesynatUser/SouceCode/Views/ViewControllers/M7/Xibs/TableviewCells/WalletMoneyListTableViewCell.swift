//
//  WalletMoneyListTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import UIKit

class WalletMoneyListTableViewCell: UITableViewCell {

    @IBOutlet weak var transactiontitleLabel: UILabel!
    @IBOutlet weak var orderIdStackView: UIStackView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var creditedOnLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var creditDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: WalletMoneyHistoryList?) {
        amountLabel.text = CommonUtils.formatPriceStringInput(data?.amount, currency: "KD")
        transactionIdLabel.text = data?.transactionID
        creditDateLabel.text = formatDate(data?.createdAt ?? "")
//        1 credit 2 debit 3 redeem
        
        let type = data?.type ?? 1
        switch  type {
        case 1:
            statusLabel.text = "Credit"
            statusLabel.textColor = .red
            creditedOnLabel.text = "Credited On"
            orderIdStackView.isHidden = true
            transactiontitleLabel.text = "Transaction Id"
        case 2:
            statusLabel.text = "Debit"
            statusLabel.textColor = UIColor(hexString: "#17854C")
            creditedOnLabel.text = "Debited On"
            orderIdStackView.isHidden = false
            transactiontitleLabel.text = "Transaction Id"
        case 3:
            statusLabel.text = "Redeemed Gift Card"
            statusLabel.textColor = UIColor(hexString: "#17854C")
            creditedOnLabel.text = "Redeemed On"
            orderIdStackView.isHidden = true
            transactiontitleLabel.text = "Gift Card No."
            transactionIdLabel.text = data?.giftcardno
        default:
            statusLabel.text = "Credit"
            statusLabel.textColor = .red
            creditedOnLabel.text = "Credited On"
            orderIdStackView.isHidden = true
            transactiontitleLabel.text = "Transaction Id"
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
        outputFormatter.dateFormat = "dd/MM/yyyy,hh:mma"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }

    
}
