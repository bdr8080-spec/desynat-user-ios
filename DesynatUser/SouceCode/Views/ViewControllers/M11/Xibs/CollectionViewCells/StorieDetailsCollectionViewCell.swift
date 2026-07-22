//
//  StorieDetailsCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import UIKit

class StorieDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addTagLabel: UILabel!
    @IBOutlet weak var addTagView: CustomView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTagLabel.text = "Ad".localiz()
    }

}
