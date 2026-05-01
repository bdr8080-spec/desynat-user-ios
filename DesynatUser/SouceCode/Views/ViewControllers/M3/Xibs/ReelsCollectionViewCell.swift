//
//  ReelsCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage

class ReelsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var currentVideoURL: URL?
    var onshareTapped: (()-> Void)?
    var onPlayTapped: (()-> Void)?
    var onLikeTapped: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        onLikeTapped?()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        onshareTapped?()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        onPlayTapped?()
    }
    
    func configData(data: GetMyReelsList?){
        let fileString = data?.file ?? ""
        let thumbnailString = data?.thumbnail ?? ""
        
        // Detect video
        let isVideo = fileString.lowercased().contains(".mp4")
        playButton.isHidden = !isVideo
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
        //            lblTitle.text = data?.title
        
        // ----- LIKE BUTTON -----
        if data?.isWhishlisted == 1 {
            likeButton.setImage(.selectedHeart, for: .normal)
        } else {
            likeButton.setImage(.besSellLike, for: .normal)
        }
    }
    
}
