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
    @IBOutlet weak var lblReturnDate: CustomLabelFont!
    @IBOutlet weak var lblOrderDate: CustomLabelFont!
    @IBOutlet weak var viewReturn: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with data: OrderModel) {
        //        let img = data.orderDetails?.first?.variationDetails?.variantImage
        //        if let imageUrl = img, let url = URL(string: imageUrl) {
        //            imgOrder.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //            imgOrder.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        //        } else {
        //            imgOrder.image = UIImage(named: "")
        //        }
        
        lblOrderId.text = data.orderID ?? ""
        //lblPrice.text = data.p
    }
    
}
