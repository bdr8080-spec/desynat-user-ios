//
//  AffiliatedProductsCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit

class AffiliatedProductsCollectionViewCell: UICollectionViewCell {

    var onGetLinkTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func getLinkDidTapped(_ sender: Any) {
        onGetLinkTapped?()
    }
}
