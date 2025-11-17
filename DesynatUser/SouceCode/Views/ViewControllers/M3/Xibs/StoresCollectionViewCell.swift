//
//  StoresCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class StoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var statusView: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
