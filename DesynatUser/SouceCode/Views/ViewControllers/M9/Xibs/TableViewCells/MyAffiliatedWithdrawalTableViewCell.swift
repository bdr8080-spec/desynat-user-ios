//
//  MyAffiliatedWithdrawalTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class MyAffiliatedWithdrawalTableViewCell: UITableViewCell {

    @IBOutlet weak var rejectReasonLabel: CustomLabelFont!
    @IBOutlet weak var rejectedReasonView: UIStackView!
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
    
    func configData(requestType: WithdrawRequestType, data: WithdrawRequestList?) {
        requestIdLabel.text = "#\(data?.requestID ?? "0")"
        requestedOnDateLabel.text = formatDate(data?.createdAt ?? "")
        transactionIdLabel.text = "#\(data?.requestID ?? "0")"
        accountNumberLabel.text = maskAccountNumber(data?.bankDetails?.accountNo ?? "")
        totalAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        creditedOnLabel.text = formatDate(data?.createdAt ?? "")
        rejectReasonLabel.text = data?.rejectReason
        transactionView.isHidden = true
        creditOnView.isHidden = true
        rejectedReasonView.isHidden = true
        switch requestType {
        case .upcoming:
            statusLabel.text = "Pending".localiz()
            statusLabel.textColor = UIColor(hexString: "#FE7D49")
        case .completed:
            transactionView.isHidden = false
            creditOnView.isHidden = false
            let adminVerify = data?.adminVerify ?? 1
            
            if adminVerify == 1 {
                statusLabel.text = "Credited".localiz()
                statusLabel.textColor = UIColor(hexString: "#17854C")
            } else {
                rejectedReasonView.isHidden = false
                statusLabel.text = "Rejected".localiz()
                statusLabel.textColor = .red
            }
        }
    }
    
    func maskAccountNumber(_ accountNumber: String) -> String {
        guard accountNumber.count > 8 else {
            return accountNumber
        }
        
        let firstFour = accountNumber.prefix(5)
        let lastFour = accountNumber.suffix(3)
        let maskedCount = accountNumber.count - 8
        let maskedPart = String(repeating: "X", count: maskedCount)
        
        return "\(firstFour)\(maskedPart)\(lastFour)"
    }
    
    func formatDate(_ isoDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: isoDate) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }

    
}
