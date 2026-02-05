//
//  MyBagTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit
import SDWebImage

class MyBagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var discountPercentageLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: CustomButton!
    @IBOutlet weak var plusButton: CustomButton!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var shopMoreButtonOutlet: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var returnavaiableLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var actaulPriceLabel: CustomLabelFont!
    
    var onIncrement: (() -> Void)?
    var onDecrement: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func minusDidTapped(_ sender: Any) {
        onDecrement?()
    }
    
    
    @IBAction func plusDidTapped(_ sender: Any) {
        onIncrement?()
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
        finalPriceLabel.text = "\(data.productVariants?.finalPrice ?? "0") KD"
        CommonUtils.setStrikethrough(label: actaulPriceLabel, text: "\(data.productVariants?.actualPrice ?? "0") KD")
        setColorBox(size: data.productVariants?.size?.name ?? "M", label: detailsLabel, hexColor: data.productVariants?.color?.hexCode ?? "#98ADFF", quantity: "\(data.quantity)")
        let returnabaiavle = data.product?.productReturn ?? "1"
        if returnabaiavle == "1" {
            returnavaiableLabel.text = "\(data.product?.returnDays ?? "1") days return available"
        } else {
            returnavaiableLabel.text = "Non returnable"
        }
        let discountType = data.productVariants?.discountType ?? "1"
        if discountType == "1" {
            discountPercentageLabel.text = "\(data.productVariants?.discountValue ?? "")% Off"
        } else {
            discountPercentageLabel.text = "\(data.productVariants?.discountValue ?? "") KD Off"
        }
    }
    
}

extension UIColor {
    convenience init?(hexStringBox: String) {
        var hexFormatted = hexStringBox.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
