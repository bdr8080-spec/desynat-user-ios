//
//  MyBagForCustomOrderTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/02/26.
//

import UIKit
import SDWebImage

class MyBagForCustomOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: CustomButton!
    @IBOutlet weak var plusButton: CustomButton!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    var onIncrement: (() -> Void)?
    var onDecrement: (() -> Void)?
    var onCustomDetailsTap: (() -> Void)?
    var onRemoveTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusDidTapped(_ sender: Any) {
//      onDecrement?()
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
//      onIncrement?()
    }
    
    @IBAction func customOrderDidTapped(_ sender: Any) {
        onCustomDetailsTap?()
    }
    
    @IBAction func removeDidTapped(_ sender: Any) {
        onRemoveTap?()
    }
    
    func configData(data: CartItemList) {
      if let imageUrlString = data.productVariants?.variantImage?.first,
         let url = URL(string: imageUrlString) {
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()
        mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
      } else {
        mainImageView.image = UIImage(named: "")
      }
      countLabel.text = "\(data.quantity)"
      productNameLabel.text = data.product?.productNameEn
      sellerNameLabel.text = "\(data.product?.sellerDetails?.firstName ?? "") \(data.product?.sellerDetails?.lastName ?? "")"
        let unitPrice = Double(data.amount ?? "") ?? 0
        let totalPriceforCustom = unitPrice * Double(data.quantity)
        let DetailForcustomName = "(\(CommonUtils.formatPrice(Double(unitPrice))) X \(data.quantity))"
        let totalamount = CommonUtils.formatPrice(Double(totalPriceforCustom))
//        finalPriceLabel.text = "Item Price \(DetailForcustomName) = \(totalamount)"
        finalPriceLabel.text = totalamount
        setColorBoxWithQuanity(size: data.productVariants?.size?.name ?? "M", label: detailsLabel, hexColor: data.productVariants?.color?.hexCode ?? "#98ADFF")
    }
    
}
