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
        let img = data.variationDetails?.variantImage
        if let imageUrl = img?.first, let url = URL(string: imageUrl) {
            imgOrder.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgOrder.sd_imageIndicator?.startAnimatingIndicator()
            imgOrder.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            imgOrder.image = UIImage(named: "")
        }
        
        lblOrderId.text = "\(data.orderID ?? 0)"
        lblPrice.text = "\(data.amount ?? "") KD"
        lblModelPiece.text = data.productDetails?.productNameEn ?? ""
        
        setColorBox(size: data.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data.quantity ?? 0)")
        
        lblPlacedDate.text = data.createdAt?.formattedOrderDate() ?? ""
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
