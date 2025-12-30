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
  
  func configData(data: AllOtherOrderVarient?) {
    if let imageUrl = data?.variationDetails?.variantImage?.first, let url = URL(string: imageUrl) {
      imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
      imgProduct.sd_imageIndicator?.startAnimatingIndicator()
      imgProduct.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      imgProduct.image = UIImage(named: "")
    }
    
    //lblDisPrice.text = data.am
    lblDisPrice.text = "\(data?.variationDetails?.finalPrice ?? "") KD"
    CommonUtils.setStrikethrough(label: lblPrice, text: "\(data?.variationDetails?.actualPrice ?? "0") KD")
    lblProductName.text = data?.productDetails?.productNameEn
    setColorBox(size: data?.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data?.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data?.quantity ?? 0)")
  }
}
