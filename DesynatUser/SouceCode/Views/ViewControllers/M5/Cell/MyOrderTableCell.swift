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
    lblStatus.text = "Ongoing"
    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
    viewReturn.isHidden = true
    
    let paymentMethod = data.order?.paymentMethod
    let paymentStatus = data.paymentStatus //data.order?.paymentStatus
    let deliveryStatus = data.deliveryStatus //data.order?.deliveryStatus
    
    if paymentMethod == "1" || paymentMethod == "2" {
      if paymentStatus == "1" {
        switch deliveryStatus {
        case "1": //Pending
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewExchange.backgroundColor = UIColor(hexString: "#17854C").withAlphaComponent(0.1)
          lblOrderDate.textColor = UIColor(hexString: "#17854C")
          lblOrderDate.text = "Expected Delivery Date : 3-5 working days"
          
        case "2", "2.1", "7": //Ongoing
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewExchange.backgroundColor = UIColor(hexString: "#17854C").withAlphaComponent(0.1)
          lblOrderDate.textColor = UIColor(hexString: "#17854C")
          lblOrderDate.text = "Expected Delivery Date : 3-5 working days"
          
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")
          viewExchange.backgroundColor = UIColor(hexString: "#16B364").withAlphaComponent(0.1)
          lblOrderDate.textColor = UIColor(hexString: "#16B364")
          
          //                  lblOrderDate.text = "Delivered On : 12 SEP 25"
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
            lblOrderDate.text = "Delivered On : \(isoDate)"
          } else {
            lblOrderDate.text = "Delivered On : -"
          }
            if data.returnType == "1" || data.returnType == "2" {
            handleReturnExchange(data: data)
          }
          
        case "4": //Cancelled
          lblStatus.text = "Cancelled"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          //                    viewExchange.isHidden = false
          viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
          lblOrderDate.textColor = UIColor(hexString: "#E70000")
          //                  lblOrderDate.text = "Cancelled  Date : 12 SEP 25"
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
            lblOrderDate.text = "Cancelled Date : \(isoDate)"
          } else {
            lblOrderDate.text = "Cancelled Date : -"
          }
          
//        case "5": //Return Request
//          handleReturnExchange(data: data)
//          
          
        default:
          return
        }
      } else if paymentStatus == "3" {
        lblStatus.text = "Cancelled"
        lblStatus.textColor = UIColor(hexString: "#E70000")
        //                viewExchange.isHidden = false
        viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
        lblOrderDate.textColor = UIColor(hexString: "#E70000")
        lblOrderDate.text = "Pickup Expected Delivery Date : 3-5 days"
        if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
          lblOrderDate.text = "Cancelled Date : \(isoDate)"
        } else {
          lblOrderDate.text = "Cancelled Date : -"
        }
        
      }
    } else if paymentMethod == "3" {
      if paymentStatus == "0" || paymentStatus == "1" {
        switch deliveryStatus {
        case "1": //Pending
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          //                  viewExchange.isHidden = false
          viewExchange.backgroundColor = UIColor(hexString: "#17854C").withAlphaComponent(0.1)
          lblOrderDate.textColor = UIColor(hexString: "#17854C")
          lblOrderDate.text = "Expected Delivery Date : 3-5 working days"
          
        case "2","2.1", "7": //Ongoing, Picked
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          //                    viewExchange.isHidden = false
          viewExchange.backgroundColor = UIColor(hexString: "#17854C").withAlphaComponent(0.1)
          lblOrderDate.textColor = UIColor(hexString: "#17854C")
          lblOrderDate.text = "Expected Delivery Date : 3-5 working days"
          
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")
          //                    viewExchange.isHidden = false
          viewExchange.backgroundColor = UIColor(hexString: "#16B364").withAlphaComponent(0.1)
          lblOrderDate.textColor = UIColor(hexString: "#16B364")
          
          //                  lblOrderDate.text = "Delivered On : 12 SEP 25"
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
            lblOrderDate.text = "Delivered On : \(isoDate)"
          } else {
            lblOrderDate.text = "Delivered On : -"
          }
          
          
            if data.returnType == "1" || data.returnType == "2"{
            handleReturnExchange(data: data)
          }
          
        case "4", "8": //Cancelled
          lblStatus.text = "Cancelled"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          //                    viewExchange.isHidden = false
          viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
          lblOrderDate.textColor = UIColor(hexString: "#E70000")
          //                  lblOrderDate.text = "Cancelled  Date : 12 SEP 25"
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
            lblOrderDate.text = "Cancelled Date : \(isoDate)"
          } else {
            lblOrderDate.text = "Cancelled Date : -"
          }
          
//        case "5":
          
          
          
          
        default:
          return
        }
      } else if paymentStatus == "2" {
        lblStatus.text = "Cancelled"
        lblStatus.textColor = UIColor(hexString: "#E70000")
        //                viewExchange.isHidden = false
        viewExchange.backgroundColor = UIColor(hexString: "#F4DDDD")
        lblOrderDate.textColor = UIColor(hexString: "#E70000")
        //              lblOrderDate.text = "Cancelled  Date : 12 SEP 25"
        if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
          lblOrderDate.text = "Cancelled Date : \(isoDate)"
        } else {
          lblOrderDate.text = "Cancelled Date : -"
        }
        
      }
    }
  }
  
  func handleReturnExchange(data: OrderModel) {
    let isReturnAllowed = data.productDetails?.productReturn == "1"
    let isExchangeAllowed = data.productDetails?.productExchangable == "1"
    
    viewReturn.isHidden = true
    
    if isReturnAllowed {
      lblStatus.text = "Return Req."
      lblStatus.textColor = UIColor(hexString: "#FF5F1B")
      //          lblStatus.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
      viewReturn.isHidden = false
      lblReturn.text = "Return Request"
      lblReturnDate.text = data.variationDetails?.createdAt?.formattedOrderDate() ?? ""
      //          lblOrderDate.text = "Pickup Expected Delivery Date : 3-5 days"//"Pickup On : 12 SEP 25"
      if let isoDate = isoStringAddingDays(data.updatedAt, days: 6) {
        lblOrderDate.text = "Pickup Date : \(isoDate)"
      } else {
        lblOrderDate.text = "Pickup Date : -"
      }
      
      viewExchange.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
      lblOrderDate.textColor = UIColor(hexString: "#FF5F1B")
    } else if isExchangeAllowed {
      lblStatus.text = "Exchange Req."
      lblStatus.textColor = UIColor(hexString: "#FF5F1B")
      //          lblStatus.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
      viewReturn.isHidden = false
      lblReturn.text = "Exchange Request"
      lblReturnDate.text = data.variationDetails?.createdAt?.formattedOrderDate() ?? ""
      //          lblOrderDate.text = "Pickup Expected Delivery Date : 3-5 days"
      if let isoDate = isoStringAddingDays(data.updatedAt, days: 6) {
        lblOrderDate.text = "Pickup Date : \(isoDate)"
      } else {
        lblOrderDate.text = "Pickup Date : -"
      }
      viewExchange.backgroundColor = UIColor(hexString: "#FF5F1B").withAlphaComponent(0.1)
      lblOrderDate.textColor = UIColor(hexString: "#FF5F1B")
    }
      if data.returnType == "1" {
          lblStatus.text = "Return Req."
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
      } else if data.returnType == "2" {
          lblStatus.text = "Exchange Req."
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
      }
  }
  
  //  func isoStringAddingDays(_ isoString: String?, days: Int = 0) -> String? {
  //      guard let isoString = isoString else { return nil }
  //
  //      let isoFormatter = DateFormatter()
  //      isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
  //      isoFormatter.locale = Locale(identifier: "en_US_POSIX")
  //      isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
  //
  //      guard let date = isoFormatter.date(from: isoString) else { return nil }
  //
  //      let calendar = Calendar(identifier: .gregorian)
  //      let newDate = calendar.date(byAdding: .day, value: days, to: date) ?? date
  //
  //      return isoFormatter.string(from: newDate)
  //  }
  
  func isoStringAddingDays(_ isoString: String?, days: Int = 0) -> String? {
    guard let isoString = isoString else { return nil }
    
    // 1️⃣ Parse the ISO date string from API
    let isoFormatter = DateFormatter()
    isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    isoFormatter.locale = Locale(identifier: "en_US_POSIX")
    isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = isoFormatter.date(from: isoString) else { return nil }
    
    // 2️⃣ Add days if needed
    let calendar = Calendar(identifier: .gregorian)
    let newDate = calendar.date(byAdding: .day, value: days, to: date) ?? date
    
    // 3️⃣ Format to desired output: 12 SEP 25
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd MMM yy"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    outputFormatter.timeZone = TimeZone.current
    
    return outputFormatter.string(from: newDate)
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
    outputFormatter.dateFormat = "h a | dd-MM-yy"
    outputFormatter.locale = Locale.current
    outputFormatter.timeZone = TimeZone.current
    
    return outputFormatter.string(from: date)
  }
}
