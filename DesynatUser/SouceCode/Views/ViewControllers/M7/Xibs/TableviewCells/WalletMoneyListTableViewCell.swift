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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: WalletMoneyHistoryList?) {
        
        transactionIdLabel.text = data?.transactionID
        orderIdLabel.text = "#\(data?.orderId ?? "0")"
        creditDateLabel.text = formatDate(data?.createdAt ?? "")
//        1 credit 2 debit 3 redeem
        
        let type = data?.type ?? 1
        switch  type {
        case 1:
            statusLabel.text = "Credit".localiz()
            statusLabel.textColor = UIColor(hexString: "#17854C")
            creditedOnLabel.text = "Credited On".localiz()
            orderIdStackView.isHidden = true
            transactiontitleLabel.text = "Transaction Id".localiz()
            amountLabel.text = "+\(CommonUtils.formatPriceStringInput(data?.amount, currency: "KD"))"
        case 2:
            statusLabel.text = "Debit".localiz()
            statusLabel.textColor = .red
            creditedOnLabel.text = "Debited On".localiz()
            orderIdStackView.isHidden = false
            transactiontitleLabel.text = "Transaction Id".localiz()
            amountLabel.text = "-\(CommonUtils.formatPriceStringInput(data?.amount, currency: "KD"))"
        case 3:
            statusLabel.text = "Redeemed Gift Card".localiz()
            statusLabel.textColor = UIColor(hexString: "#17854C")
            creditedOnLabel.text = "Redeemed On".localiz()
            orderIdStackView.isHidden = true
            transactiontitleLabel.text = "Gift Card No.".localiz()
            transactionIdLabel.text = data?.giftcardno
            amountLabel.text = "+\(CommonUtils.formatPriceStringInput(data?.amount, currency: "KD"))"
        default:
            statusLabel.text = "Credit".localiz()
            statusLabel.textColor = UIColor(hexString: "#17854C")
            creditedOnLabel.text = "Credited On".localiz()
            orderIdStackView.isHidden = true
            transactiontitleLabel.text = "Transaction Id".localiz()
            amountLabel.text = "+\(CommonUtils.formatPriceStringInput(data?.amount, currency: "KD"))"
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
