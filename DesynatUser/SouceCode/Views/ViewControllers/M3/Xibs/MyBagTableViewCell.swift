//
//  MyBagTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class MyBagTableViewCell: UITableViewCell {

    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var shopMoreButtonOutlet: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        setColorBox(label: detailsLabel, hexColor: "#6E4527")
        setColorBox(size: "M", label: detailsLabel, hexColor: "#98ADFF", quantity: "2")

    }
    
//    func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
//        let box = "⬛"                                    // the square
//        let dot = "●"
//        let text = "Size: \(size) ● Color: \(box) ● Qnt: \(quantity)"
//
//        let attributedString = NSMutableAttributedString(string: text)
//
//        // Color
//            if let color = UIColor(hexStringcolour: hexColor) {
//                let range = (text as NSString).range(of: box)
//                attributedString.addAttribute(.foregroundColor, value: color, range: range)
//
//                // ⬇️ Reduce the box size (smaller font for only that character)
//                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: range)
//            }
//
//        label.attributedText = attributedString
//    }
    
    func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
        let box = "⬛"
        let dot = "●"
        let text = "Size: \(size) \(dot) Color: \(box) \(dot) Qnt: \(quantity)"

        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [.font: label.font as Any]
        )

        // 1️⃣ Apply Light Gray Color to all "●"
        let grayColor = UIColor(hexString: "#D9D9D9")
        let nsText = text as NSString
        var searchRange = NSRange(location: 0, length: nsText.length)

        while true {
            let foundRange = nsText.range(of: dot, options: [], range: searchRange)
            if foundRange.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: foundRange)

            // Move search range forward
            let nextLocation = foundRange.location + foundRange.length
            searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
        }

        // 2️⃣ Apply actual color for the square box
        if let color = UIColor(hexStringcolour: hexColor) {
            let boxRange = nsText.range(of: box)
            attributedString.addAttribute(.foregroundColor, value: color, range: boxRange)

            // Make the square smaller
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: boxRange)
        }

        label.attributedText = attributedString
    }

    
}
