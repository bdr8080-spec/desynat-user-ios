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
    
    func configData(data: OrdersDataAffilaitedPaymentList?) {
      // Pending #FE7D49 (Orange)
        //Credited #17854C (Green)
        //Cancelled #D53B36 (Red)
        transactionIdLabel.text = "#\(data?.id ?? 0)"
        myEarningLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        purchasedLabel.text = data?.userDetails?.fullName
        productNameLabel.text = data?.productDetails?.productNameEn
        categoryNameLabel.text = data?.productDetails?.category?.name
        quantityLabel.text = "\(data?.quantity ?? 0)"
        totalAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        purchasedOnLabel.text = formatDate(data?.createdAt ?? "")
        let deliveryStatus = data?.deliveryStatus ?? "1"
        let paymentStatus = data?.paymentStatus ?? "1"

        if paymentStatus == "2" || paymentStatus == "3" {
            orderStatusLabel.text = "Cancelled"
            orderStatusLabel.textColor = UIColor(hexString: "#D53B36")
        } else {
            switch deliveryStatus {
            case "1":
                orderStatusLabel.text = "Pending"
                orderStatusLabel.textColor = UIColor(hexString: "#FE7D49")
            case "3":
                orderStatusLabel.text = "Completed"
                orderStatusLabel.textColor = UIColor(hexString: "#17854C")
            case "4":
                orderStatusLabel.text = "Cancelled"
                orderStatusLabel.textColor = UIColor(hexString: "#D53B36")
            default:
                orderStatusLabel.text = "Ongoing"
                orderStatusLabel.textColor = UIColor(hexString: "#FE7D49")
            }
        }
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
