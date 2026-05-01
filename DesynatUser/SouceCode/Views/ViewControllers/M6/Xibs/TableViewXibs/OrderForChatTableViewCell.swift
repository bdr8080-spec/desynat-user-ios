//
//  OrderForChatTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import SDWebImage

class OrderForChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var waitingButtonOutlet: CustomButton!
    @IBOutlet weak var sendRequestButtonOutlet: CustomButton!
    @IBOutlet weak var viewRequestButtonOutlet: UIButton!
    @IBOutlet weak var productImageView: CustomImageView!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    var onViewRequestTap :(() -> Void)?
    var onSendRequestTap :(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewRequestDidTapped(_ sender: Any) {
        onViewRequestTap?()
    }
    
    @IBAction func sendRequestDidTapped(_ sender: Any) {
        onSendRequestTap?()
    }
    
    func configData(data: Record?) {
        if let imageUrl = data?.productVariation?.variantImage?.first, let url = URL(string: imageUrl) {
            productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            productImageView.sd_imageIndicator?.startAnimatingIndicator()
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            productImageView.image = UIImage(named: "")
        }
        productNameLabel.text = data?.productVariation?.productDetails?.productNameEn ?? ""
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariation?.discountType,discountValue: data?.productVariation?.discountValue)
        
        finalPriceLabel.text = CommonUtils.formatPriceStringInput(data?.productVariation?.finalPrice)
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: CommonUtils.formatPriceStringInput(data?.productVariation?.actualPrice))
        
        setColorBoxWithQuanity(size: data?.productVariation?.size?.name ?? "", label: productDetailsLabel, hexColor: data?.productVariation?.color?.hexCode ?? "#98ADFF")
        
        let messageType = data?.type ?? "1" // normal msg, customization send
        let requestType = data?.productRequest ?? "1"
        let actiontype = data?.action ?? "1"
        sendRequestButtonOutlet.isHidden = true
        viewRequestButtonOutlet.isHidden = true
        waitingButtonOutlet.isHidden = true
        if messageType != "1" {
            switch actiontype {
            case "0": //user sent chat for customization new
                sendRequestButtonOutlet.isHidden = false
                if requestType == "1" {
                    waitingButtonOutlet.isHidden = false
                    waitingButtonOutlet.setTitle("Waiting".localiz(), for: .normal)
                    sendRequestButtonOutlet.isHidden = true
                }
            case "1", "2", "5":
                viewRequestButtonOutlet.isHidden = false
                if actiontype == "5" {
                    let isOrderPlaced = data?.orderCreateStatus?.id != nil
                    if isOrderPlaced {
                        viewRequestButtonOutlet.isHidden = true
                        waitingButtonOutlet.isHidden = false
                        waitingButtonOutlet.setTitle("Placed".localiz(), for: .normal)
                    }
                }
            case "4":
                waitingButtonOutlet.isHidden = false
                waitingButtonOutlet.setTitle("Rejected".localiz(), for: .normal)
                
            default:
                print("")
            }
        }
    }
}
