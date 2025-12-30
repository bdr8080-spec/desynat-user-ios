//
//  MyOrderTableCell.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit
import SDWebImage

class MyOrderTableCell: UITableViewCell {
    
    @IBOutlet weak var imgOrder: CustomImageView!
    @IBOutlet weak var lblStatus: CustomLabelFont!
    @IBOutlet weak var lblOrderId: CustomLabelFont!
    @IBOutlet weak var lblPrice: CustomLabelFont!
    @IBOutlet weak var lblModelPiece: CustomLabelFont!
    @IBOutlet weak var lblSize: CustomLabelFont!
    @IBOutlet weak var lblPlacedDate: CustomLabelFont!
    @IBOutlet weak var lblReturn: CustomLabelFont!
    @IBOutlet weak var lblReturnDate: CustomLabelFont!
    @IBOutlet weak var lblOrderDate: CustomLabelFont!
    @IBOutlet weak var viewReturn: UIView!
    @IBOutlet weak var viewExchange: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with data: OrderModel) {
        let img = data.variationDetails?.variantImage
        if let imageUrl = img?.first, let url = URL(string: imageUrl) {
            imgOrder.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgOrder.sd_imageIndicator?.startAnimatingIndicator()
            imgOrder.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            imgOrder.image = UIImage(named: "")
        }
        
        lblOrderId.text = "#\(data.id ?? 0)"
        lblPrice.text = "\(data.amount ?? "") KD"
        lblModelPiece.text = data.productDetails?.productNameEn ?? ""
        
        setColorBox(size: data.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data.quantity ?? 0)")
        
        lblPlacedDate.text = data.createdAt?.formattedOrderDate() ?? ""
        configureStatus(with: data)
    }
    
    func configureStatus(with data: OrderModel) {
        lblStatus.text = ""
        viewExchange.isHidden = true
        viewReturn.isHidden = true
        //let status = data.order?.deliveryStatus
        
        let paymentMethod = data.order?.paymentMethod
      let paymentStatus = data.paymentStatus //data.order?.paymentStatus
      let deliveryStatus = data.deliveryStatus //data.order?.deliveryStatus
        
        if paymentMethod == "1" || paymentMethod == "2" {
            if paymentStatus == "1" {
                switch deliveryStatus {
                case "1": //Pending
                    lblStatus.text = "Pending"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                  lblOrderDate.text = "Expected Delivery Date : 3-5 days"
                  
                case "2", "7": //Ongoing
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewExchange.isHidden = false
                    viewExchange.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
                    lblOrderDate.textColor = UIColor(hexString: "#FF5F1B")
                  lblOrderDate.text = "Expected Delivery Date : 3-5 days"
                  
                case "3": //Delivered
                    lblStatus.text = "Delivered"
                    lblStatus.textColor = UIColor(hexString: "#16B364")
                    viewExchange.isHidden = false
                    viewExchange.backgroundColor = UIColor(hexString: "#16B364").withAlphaComponent(0.1)
                    lblOrderDate.textColor = UIColor(hexString: "#16B364")
                    handleReturnExchange(data: data)
                  lblOrderDate.text = "Delivered On : 12 SEP 25"
                  
                case "4": //Cancelled
                    lblStatus.text = "Cancelled"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewExchange.isHidden = false
                    viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
                    lblOrderDate.textColor = UIColor(hexString: "#E70000")
                  lblOrderDate.text = "Cancelled  Date : 12 SEP 25"
                  
                default:
                    return
                }
            } else if paymentStatus == "3" {
                lblStatus.text = "Refund"
                lblStatus.textColor = UIColor(hexString: "#E70000")
                viewExchange.isHidden = false
                viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
                lblOrderDate.textColor = UIColor(hexString: "#E70000")
              lblOrderDate.text = "Pickup Date : 12 SEP 25"
              
            }
        } else if paymentMethod == "3" {
            if paymentStatus == "0" || paymentStatus == "1" {
                switch deliveryStatus {
                case "1": //Pending
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                  viewExchange.isHidden = false
                  viewExchange.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
                  lblOrderDate.textColor = UIColor(hexString: "#FF5F1B")
                  lblOrderDate.text = "Expected Delivery Date : 3-5 days"
                  
                case "2", "7": //Ongoing, Picked
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewExchange.isHidden = false
                    viewExchange.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
                    lblOrderDate.textColor = UIColor(hexString: "#FF5F1B")
                  lblOrderDate.text = "Expected Delivery Date : 3-5 days"
                    
                case "3": //Delivered
                    lblStatus.text = "Delivered"
                    lblStatus.textColor = UIColor(hexString: "#16B364")
                    viewExchange.isHidden = false
                    viewExchange.backgroundColor = UIColor(hexString: "#16B364").withAlphaComponent(0.1)
                    lblOrderDate.textColor = UIColor(hexString: "#16B364")
                    handleReturnExchange(data: data)
                  lblOrderDate.text = "Delivered On : 12 SEP 25"
                  
                case "4", "8": //Cancelled
                    lblStatus.text = "Cancelled"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewExchange.isHidden = false
                    viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
                    lblOrderDate.textColor = UIColor(hexString: "#E70000")
                  lblOrderDate.text = "Cancelled  Date : 12 SEP 25"
              
                    
                default:
                    return
                }
            } else if paymentStatus == "2" {
                lblStatus.text = "Cancelled"
                lblStatus.textColor = UIColor(hexString: "#E70000")
                viewExchange.isHidden = false
                viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
                lblOrderDate.textColor = UIColor(hexString: "#E70000")
              lblOrderDate.text = "Cancelled  Date : 12 SEP 25"
            }
        }
    }
    
    func handleReturnExchange(data: OrderModel) {
        let isReturnAllowed = data.productDetails?.productReturn == "1"
        let isExchangeAllowed = data.productDetails?.productExchangable == "1"
        
        viewReturn.isHidden = true
        
        if isReturnAllowed {
          lblStatus.text = "Return Req."
            viewReturn.isHidden = false
            lblReturn.text = "Return Request"
            lblReturnDate.text = data.variationDetails?.createdAt?.formattedOrderDate() ?? ""
        } else if isExchangeAllowed {
          lblStatus.text = "Return Req."
            viewReturn.isHidden = false
            lblReturn.text = "Exchange Request"
            lblReturnDate.text = data.variationDetails?.createdAt?.formattedOrderDate() ?? ""
        }
    }
    
}

extension UITableViewCell {
    func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        
        let fullText = "Size: \(size)  \(dot)  Color: \(coloredSquare)  \(dot)  Qnt: \(quantity)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") ?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
}

extension String {
    func formattedOrderDate() -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(abbreviation: "UTC")

        guard let date = isoFormatter.date(from: self) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h a | dd MM yy"
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }
}
