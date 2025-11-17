//
//  PriceRangeSliderTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class PriceRangeSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var rangeSlider: RangeSliderView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rangeSlider.minValue = 0
        rangeSlider.maxValue = 100
        rangeSlider.currentValue = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
