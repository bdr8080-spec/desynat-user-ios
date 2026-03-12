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
        myEarningLabel.text = CommonUtils.formatPriceStringInput(data?.affiliateCommission)
        purchasedLabel.text = data?.userDetails?.fullName
        productNameLabel.text = data?.productDetails?.productNameEn
        categoryNameLabel.text = data?.productDetails?.category?.name
        quantityLabel.text = "\(data?.quantity ?? 0)"
        totalAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        purchasedOnLabel.text = formatDate(data?.createdAt ?? "")
//        let deliveryStatus = data?.deliveryStatus ?? "1"
//        let paymentStatus = data?.paymentStatus ?? "1"
//        
//        if paymentStatus == "2" || paymentStatus == "3" {
//            orderStatusLabel.text = "Cancelled"
//            orderStatusLabel.textColor = UIColor(hexString: "#D53B36") //(Red)
//        } else {
//            switch deliveryStatus {
//            case "1":
//                orderStatusLabel.text = "Pending"
//                orderStatusLabel.textColor = UIColor(hexString: "#FE7D49") //(Orange)
//            case "3":
//                orderStatusLabel.text = "Completed"
//                orderStatusLabel.textColor = UIColor(hexString: "#17854C") //(Green)
//            case "4":
//                orderStatusLabel.text = "Cancelled"
//                orderStatusLabel.textColor = UIColor(hexString: "#D53B36") //(Red)
//            default:
//                orderStatusLabel.text = "Pending"
//                orderStatusLabel.textColor = UIColor(hexString: "#FE7D49") //(Orange)
//            }
//        }
        configureStatus(with: data)
    }
    
    func configureStatus(with data: OrdersDataAffilaitedPaymentList?) {
        orderStatusLabel.text = "Pending"
        guard let data = data else { return }
        let paymentMethod = data.order?.paymentMethod
        let paymentStatus = data.paymentStatus //data.order?.paymentStatus
        let deliveryStatus = data.deliveryStatus //data.order?.deliveryStatus
        
        if paymentMethod == "1" || paymentMethod == "2" {
            if paymentStatus == "1" {
                switch deliveryStatus {
                case "1": //Pending
                    orderStatusLabel.text = "Pending"
                    orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
                    if data.returnType == "1" || data.returnType == "2" {
                        let approveType = data.rEApprove ?? "1"
                        if approveType == "1" {
                            orderStatusLabel.text = "Return Req."
                        }
                    }
                    
                case "2", "2.1", "7": //Pending
                    orderStatusLabel.text = "Pending"
                    orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
                    if data.deliveryStatus == "7" && (data.returnType == "1" || data.returnType == "2") {
                        let approveType = data.rEApprove ?? "1"
                        if approveType == "1" {
                            orderStatusLabel.text = "Return Req."
                        }
                    }
                    
                case "3": //Delivered
                    orderStatusLabel.text = "Completed"
                    orderStatusLabel.textColor = UIColor(hexString: "#16B364")
                    if data.returnType == "1" || data.returnType == "2" {
                        handleReturnExchange(data: data)
                    }
                case "4": //Cancelled
                    orderStatusLabel.text = "Cancelled"
                    orderStatusLabel.textColor = UIColor(hexString: "#E70000")
                default:
                    return
                }
            } else if paymentStatus == "3" {
                orderStatusLabel.text = "Cancelled"
                orderStatusLabel.textColor = UIColor(hexString: "#E70000")
            }
        } else if paymentMethod == "3" {
            if paymentStatus == "0" || paymentStatus == "1" {
                switch deliveryStatus {
                case "1": //Pending
                    orderStatusLabel.text = "Pending"
                    orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
                    if data.returnType == "1" || data.returnType == "2" {
                        let approveType = data.rEApprove ?? "1"
                        if approveType == "1" {
                            orderStatusLabel.text = "Return Req."
                        }
                    }
                    
                case "2","2.1", "7": //Pending, Picked
                    orderStatusLabel.text = "Pending"
                    orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
                    if data.deliveryStatus == "7" && (data.returnType == "1" || data.returnType == "2") {
                        let approveType = data.rEApprove ?? "1"
                        if approveType == "1" {
                            orderStatusLabel.text = "Return Req."
                        }
                    }
                    
                case "3": //Delivered
                    orderStatusLabel.text = "Completed"
                    orderStatusLabel.textColor = UIColor(hexString: "#16B364")
                    if data.returnType == "1" || data.returnType == "2"{
                        handleReturnExchange(data: data)
                    }
                    
                case "4", "8": //Cancelled
                    orderStatusLabel.text = "Cancelled"
                    orderStatusLabel.textColor = UIColor(hexString: "#E70000")
                default:
                    return
                }
            } else if paymentStatus == "2" {
                orderStatusLabel.text = "Cancelled"
                orderStatusLabel.textColor = UIColor(hexString: "#E70000")
            }
        }
    }
    
    func handleReturnExchange(data: OrdersDataAffilaitedPaymentList) {
        let isReturnAllowed = data.productDetails?.productReturn == "1"
        let isExchangeAllowed = data.productDetails?.productExchangable == "1"
        
        if isReturnAllowed {
            orderStatusLabel.text = "Return Req."
            orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
        } else if isExchangeAllowed {
            orderStatusLabel.text = "Exchange Req."
            orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
        }
        if data.returnType == "1" {
            orderStatusLabel.text = "Return Req."
            orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
            if data.rEApprove == "1" {
                if data.deliveryStatus == "3"{
                    orderStatusLabel.text = "Returned"
                    orderStatusLabel.textColor = UIColor(hexString: "#16B364")
                }
            } else if data.rEApprove == "2" {
                orderStatusLabel.text = "Completed"
                orderStatusLabel.textColor = UIColor(hexString: "#16B364")
            }
        } else if data.returnType == "2" {
            orderStatusLabel.text = "Exchange Req."
            orderStatusLabel.textColor = UIColor(hexString: "#FF5F1B")
            if data.rEApprove == "1" {
                if data.deliveryStatus == "3"{
                    orderStatusLabel.text = "Exchange Req."
                }
            } else if data.rEApprove == "2" {
                orderStatusLabel.text = "Completed"
                orderStatusLabel.textColor = UIColor(hexString: "#16B364")
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
