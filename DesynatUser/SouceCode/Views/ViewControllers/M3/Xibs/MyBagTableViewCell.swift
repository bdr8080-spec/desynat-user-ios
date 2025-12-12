//
//  MyBagTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit
import SDWebImage

class MyBagTableViewCell: UITableViewCell {
  
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
    
    //        setColorBox(label: detailsLabel, hexColor: "#6E4527")
    
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
    
  }
  
//  func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
//      // Use ■ (U+25A0) – this is a plain black square that CAN be colored
//      let coloredSquare = "■"
//      let dot = "●" // Better than ● for consistency and smaller size
//      let text = "Size: \(size)  \(dot)  Color: \(coloredSquare)  \(dot)  Qnt: \(quantity)"
//
//      let attributedString = NSMutableAttributedString(
//          string: text,
//          attributes: [.font: UIFont.systemFont(ofSize: label.font.pointSize)]
//      )
//
//      let grayColor = UIColor(hexString: "#D9D9D9") ?? UIColor.gray
//
//      let nsText = text as NSString
//      var searchRange = NSRange(location: 0, length: nsText.length)
//
//      // Color all dots gray
//      while true {
//          let foundRange = nsText.range(of: dot, options: [], range: searchRange)
//          if foundRange.location == NSNotFound { break }
//          attributedString.addAttribute(.foregroundColor, value: grayColor, range: foundRange)
//          
//          let nextLocation = foundRange.location + foundRange.length
//          searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
//      }
//
//      // Apply actual product color to the square ■
//      if let productColor = UIColor(hexStringBox: hexColor) {
//          let squareRange = nsText.range(of: coloredSquare)
//          if squareRange.location != NSNotFound {
//              attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
//              // Make square slightly larger for visibility
//              attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .medium), range: squareRange)
//          }
//      }
//
//      label.attributedText = attributedString
//  }
  
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
  
//  func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
//    let box = "⬛"
//    let dot = "●"
//    let text = "Size: \(size) \(dot) Color: \(box) \(dot) Qnt: \(quantity)"
//    
//    let attributedString = NSMutableAttributedString(
//      string: text,
//      attributes: [.font: label.font as Any]
//    )
//    let grayColor = UIColor(hexString: "#D9D9D9")
//    let nsText = text as NSString
//    var searchRange = NSRange(location: 0, length: nsText.length)
//    
//    while true {
//      let foundRange = nsText.range(of: dot, options: [], range: searchRange)
//      if foundRange.location == NSNotFound { break }
//      attributedString.addAttribute(.foregroundColor, value: grayColor, range: foundRange)
//      
//      // Move search range forward
//      let nextLocation = foundRange.location + foundRange.length
//      searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
//    }
//    
//    // 2️⃣ Apply actual color for the square box
//    if let color = UIColor(hexStringcolour: hexColor) {
//      let boxRange = nsText.range(of: box)
//      attributedString.addAttribute(.foregroundColor, value: color, range: boxRange)
//      //          let dotRange = nsText.range(of: dot)
//      // Make the square smaller
//      attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: boxRange)
//      //            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: dotRange)
//    }
//    
//    label.attributedText = attributedString
//  }
  
  
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
