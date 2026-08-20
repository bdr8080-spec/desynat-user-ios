//
//  PriceRangeSliderTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class PriceRangeSliderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rangeSlider: RangeSliderView!
    
    var onPriceChanged: ((Int, Int) -> Void)?
    
    // Preselected values
    var minPrice: Int = 1 {
        didSet { rangeSlider.initialValue = CGFloat(minPrice) } // left thumb
    }
    var maxPrice: Int = 1000 {
        didSet { rangeSlider.currentValue = CGFloat(maxPrice) } // right thumb
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Listen to slider changes
        rangeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc private func sliderValueChanged() {
        onPriceChanged?(Int(rangeSlider.initialValue), Int(rangeSlider.currentValue))
    }
}
