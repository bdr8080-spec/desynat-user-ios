//
//  OrderDetailTableCell.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit
import SDWebImage

class OrderDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var customDetailsLabel: UILabel!
    @IBOutlet weak var totalQuntityLbel: UILabel!
    @IBOutlet weak var customOrderStackView: UIView!
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
    
    func configData(data: AllOtherOrderVarient?, paymentMethod: String, paymentStatus: String, deliveryStatus: String) {
        if let imageUrl = data?.variationDetails?.variantImage?.first, let url = URL(string: imageUrl) {
            imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgProduct.sd_imageIndicator?.startAnimatingIndicator()
            imgProduct.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            imgProduct.image = UIImage(named: "")
        }
        
        if data?.orderType == "2" {
            customOrderStackView.isHidden = false
            totalQuntityLbel.text = data?.chatroomRecordtable?.quantity?.description//chatdata?.quantity?.description ?? data?.quantity?.description
            customDetailsLabel.text = data?.chatroomRecordtable?.customDetails//chatdata?.customDetails
            lblReturnAvail.isHidden = true
            if AppLanguageManager.shared.currentLanguage == .ar {
                setColorBoxWithQuanity(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF")
            } else {
                setColorBoxWithQuanity(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF")
            }
            let unitPrice = Double(data?.amount ?? "") ?? 0
            lblDisPrice.text = CommonUtils.formatPrice(unitPrice)
            lblDisPrice.text = CommonUtils.formatPriceStringInput(data?.chatroomRecordtable?.totalAmount ?? "0")
            lblPrice.isHidden = true
            discountPercentageLabel.isHidden = true
        } else {
            customOrderStackView.isHidden = true
            lblReturnAvail.isHidden = false
            if AppLanguageManager.shared.currentLanguage == .ar {
                setColorBox(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data?.quantity ?? 0)")
            } else {
                setColorBox(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data?.quantity ?? 0)")
            }
            
            lblDisPrice.text = CommonUtils.formatPriceStringInput(data?.variationDetails?.finalPrice, currency: "KD")
            lblPrice.isHidden = false
            CommonUtils.updateDiscountPercentageLabel(discountPercentageLabel, actualAmountLabel: lblPrice,
                                                      discountType: data?.variationDetails?.discountType,
                                                      discountValue: data?.variationDetails?.discountValue)
        }
        
        CommonUtils.setStrikethrough(label: lblPrice, text: "\(data?.variationDetails?.actualPrice ?? "0") KD")
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            lblProductName.text = data?.productDetails?.productNameAr
        }else{
            lblProductName.text = data?.productDetails?.productNameEn
        }
        
        //lblProductName.text = data?.productDetails?.productNameEn
        
        let isReturnAllowed = data?.productDetails?.productReturn == "1"
        if isReturnAllowed {
            lblReturnAvail.text = "\(data?.productDetails?.returnDays ?? "1") \("days return available".localiz())"
        } else {
            lblReturnAvail.text = "No return available".localiz()
        }
        if data?.orderType != "2" {
            lblReturnAvail.isHidden = false
        }
        if paymentMethod == "1" || paymentMethod == "2" {
            if paymentStatus == "1" {
                switch deliveryStatus {
                case "1": //Pending
                    lblStatus.text = "Ongoing".localiz()
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    
                case "2", "7": //Ongoing
                    lblStatus.text = "Ongoing".localiz()
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    
                case "3": //Delivered
                    lblStatus.text = "Delivered".localiz()
                    lblStatus.textColor = UIColor(hexString: "#16B364")
                    if data?.returnType == "1" {
                        lblStatus.text = "Return Req.".localiz()
                        lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    }
                    
                case "4": //Cancelled
                    lblStatus.text = "Cancelled".localiz()
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    if data?.orderType != "2" {
                        lblReturnAvail.isHidden = true
                    }
                default:
                    lblStatus.text = "Confirmed".localiz()
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                }
            } else if paymentStatus == "3" {
                lblStatus.text = "Cancelled".localiz()
                lblStatus.textColor = UIColor(hexString: "#E70000")
                if data?.orderType != "2" {
                    lblReturnAvail.isHidden = true
                }
            }
        } else if paymentMethod == "3" {
            if paymentStatus == "0" || paymentStatus == "1" {
                switch deliveryStatus {
                case "1": //Pending
                    lblStatus.text = "Ongoing".localiz()
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    
                case "2", "7": //Ongoing, Picked
                    lblStatus.text = "Ongoing".localiz()
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    
                case "3": //Delivered
                    lblStatus.text = "Delivered".localiz()
                    lblStatus.textColor = UIColor(hexString: "#16B364")
                    
                    if data?.returnType == "1" {
                        lblStatus.text = "Return Req.".localiz()
                        lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    }
                    
                case "4", "8":
                    lblStatus.text = "Cancelled".localiz()
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    if data?.orderType != "2" {
                        lblReturnAvail.isHidden = true
                    }
                default:
                    lblStatus.text = "Confirmed".localiz()
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                }
            } else if paymentStatus == "2" {
                lblStatus.text = "Cancelled".localiz()
                lblStatus.textColor = UIColor(hexString: "#E70000")
                if data?.orderType != "2" {
                    lblReturnAvail.isHidden = true
                }
            }
        }
        
        
    }
    
}
