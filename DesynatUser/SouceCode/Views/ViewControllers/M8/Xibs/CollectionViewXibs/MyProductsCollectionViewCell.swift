//
//  MyProductsCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class MyProductsCollectionViewCell: UICollectionViewCell {

    var onTrackPerformanceTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func trackPerformanceDidTapped(_ sender: Any) {
        onTrackPerformanceTapped?()
    }
}
