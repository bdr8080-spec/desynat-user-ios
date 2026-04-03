//
//  StoresDetailsCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage

class StoresDetailsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var lblTitle: UILabel!
    
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: GetHighLightsList?){
            let fileString = data?.file ?? ""
            let thumbnailString = data?.thumbnail ?? ""
     
            // Detect video
            let isVideo = fileString.lowercased().contains(".mp4")
     
            // Decide which URL to load
            let finalURLString = isVideo ? thumbnailString : fileString
            let url = URL(string: finalURLString)
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
     
            // Set image
            mainImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder")
            )
            lblTitle.text = data?.title
        }

}
