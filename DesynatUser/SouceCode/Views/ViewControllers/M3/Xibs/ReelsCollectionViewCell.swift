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
    
    func configData(data: GetMyReelsList?) {

        // Reset state
        mainImageView.image = nil
        playButton.isHidden = true
        currentVideoURL = nil

        guard let fileURLString = data?.file else {
            mainImageView.image = UIImage(named: "placeholder")
            return
        }

        let isVideo = fileURLString.lowercased().contains(".mp4")
        let fileURL = URL(string: fileURLString)

        // ----- VIDEO CASE -----
        if isVideo {

            currentVideoURL = fileURL
            playButton.isHidden = false  // Show play icon

            // Show placeholder first
            mainImageView.image = UIImage(named: "placeholder")

            // Load THUMBNAIL
            if let thumbString = data?.thumbnail,
               let thumbURL = URL(string: thumbString) {

                mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                mainImageView.sd_setImage(
                    with: thumbURL,
                    placeholderImage: UIImage(named: "placeholder"),
                    options: [.retryFailed, .scaleDownLargeImages]
                )
            }

        }
        else {
            // ----- IMAGE CASE -----
            playButton.isHidden = true

            if let url = fileURL {
                mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                mainImageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "placeholder"),
                    options: [.retryFailed, .scaleDownLargeImages]
                )
            }
        }

        // ----- LIKE BUTTON -----
        if data?.isWhishlisted == 1 {
            likeButton.setImage(.selectedHeart, for: .normal)
        } else {
            likeButton.setImage(.besSellLike, for: .normal)
        }
    }
    
}
