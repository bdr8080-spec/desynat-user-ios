//
//  OrderDetailTableCell.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit
import SDWebImage

class OrderDetailTableCell: UITableViewCell {
  
  @IBOutlet weak var imgProduct: CustomImageView!
  @IBOutlet weak var lblProductName: CustomLabelFont!
  @IBOutlet weak var lblSize: CustomLabelFont!
  @IBOutlet weak var lblDisPrice: CustomLabelFont!
  @IBOutlet weak var lblPrice: CustomLabelFont!
  @IBOutlet weak var lblReturnAvail: CustomLabelFont!
  @IBOutlet weak var viewReturnDays: UIView!
  @IBOutlet weak var viewCancel: UIView!
  @IBOutlet weak var viewRate: UIView!
  @IBOutlet weak var viewReturnEx: UIView!
  @IBOutlet weak var viewLine: UIView!
  @IBOutlet weak var line: UIView!
  @IBOutlet weak var viewCustom: UIView!
  @IBOutlet weak var lblTotalQuantity: CustomLabelFont!
  @IBOutlet weak var lblAddress: CustomLabelFont!
  @IBOutlet weak var lblDetails: CustomLabelFont!
  @IBOutlet weak var lblStatus: CustomLabelFont!
  @IBOutlet weak var discountPercentageLabel: UILabel!
  
  var onTapCancel: (()->())?
  var onTapExchange: (()->())?
  var onTapReturn: (()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  @IBAction func btnCancel(_ sender: Any) {
    onTapCancel?()
  }
  
  @IBAction func btnExchange(_ sender: Any) {
    onTapExchange?()
  }
  
  @IBAction func btnReturn(_ sender: Any) {
    onTapReturn?()
  }
  
  func configData(data: AllOtherOrderVarient?, paymentMethod: String, paymentStatus: String, deliveryStatus: String, isCustomOrder: Bool) {
    if let imageUrl = data?.variationDetails?.variantImage?.first, let url = URL(string: imageUrl) {
      imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
      imgProduct.sd_imageIndicator?.startAnimatingIndicator()
      imgProduct.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      imgProduct.image = UIImage(named: "")
    }
    
    let discountType = data?.variationDetails?.discountType ?? "1"
    if discountType == "1" {
      discountPercentageLabel.text = "\(data?.variationDetails?.discountValue ?? "")% Off"
    } else {
      discountPercentageLabel.text = "\(data?.variationDetails?.discountValue ?? "") KD Off"
    }
    
    //lblDisPrice.text = data.am
    lblDisPrice.text = "\(data?.variationDetails?.finalPrice ?? "") KD"
    CommonUtils.setStrikethrough(label: lblPrice, text: "\(data?.variationDetails?.actualPrice ?? "0") KD")
    lblProductName.text = data?.productDetails?.productNameEn
    if isCustomOrder {
      setColorBoxWithQuanity(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF")
    } else {
      setColorBox(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data?.quantity ?? 0)")
    }
    let isReturnAllowed = data?.productDetails?.productReturn == "1"
    if isReturnAllowed {
      lblReturnAvail.text = "\(data?.productDetails?.returnDays ?? "1") days return available"
    } else {
      lblReturnAvail.text = "No return available"
    }
    lblReturnAvail.isHidden = false
    if paymentMethod == "1" || paymentMethod == "2" {
      if paymentStatus == "1" {
        switch deliveryStatus {
        case "1": //Pending
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          
        case "2", "7": //Ongoing
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")
          if data?.returnType == "1" {
            lblStatus.text = "Return Req."
            lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          }
          
        case "4": //Cancelled
          lblStatus.text = "Cancelled"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          lblReturnAvail.isHidden = true
        default:
          return
        }
      } else if paymentStatus == "3" {
        lblStatus.text = "Cancelled"
        lblStatus.textColor = UIColor(hexString: "#E70000")
        lblReturnAvail.isHidden = true
      }
    } else if paymentMethod == "3" {
      if paymentStatus == "0" || paymentStatus == "1" {
        switch deliveryStatus {
        case "1": //Pending
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          
        case "2", "7": //Ongoing, Picked
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
         
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")

          if data?.returnType == "1" {
            lblStatus.text = "Return Req."
            lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          }
          
        case "4", "8": //Cancelled
          lblStatus.text = "Cancelled"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          lblReturnAvail.isHidden = true
        default:
          return
        }
      } else if paymentStatus == "2" {
        lblStatus.text = "Cancelled"
        lblStatus.textColor = UIColor(hexString: "#E70000")
        lblReturnAvail.isHidden = true
      }
    }
  }
  
}
