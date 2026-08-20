//
//  ProductBlurCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac2 on 20/08/26.
//

import UIKit
import SDWebImage

class ProductBlurCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var blurImaageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var imageURL: String?
    var videoURL: String?
    
    private let grayOverlay = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupBlur()
    }

    private func setupBlur() {
        guard let image = blurImaageView.image,
              let cgImage = image.cgImage else {
            return
        }

        let inputImage = CIImage(cgImage: cgImage)

        guard let filter = CIFilter(name: "CIGaussianBlur") else {
            return
        }

        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(10.0, forKey: kCIInputRadiusKey)

        guard let blurred = filter.outputImage else {
            return
        }

        var newImageSize = blurred.extent

        newImageSize.origin.x +=
            (newImageSize.size.width - image.size.width) / 2

        newImageSize.origin.y +=
            (newImageSize.size.height - image.size.height) / 2

        newImageSize.size = image.size

        let context = CIContext()

        guard let cgImg = context.createCGImage(
            blurred,
            from: newImageSize
        ) else {
            return
        }

        blurImaageView.image = UIImage(
            cgImage: cgImg,
            scale: image.scale,
            orientation: image.imageOrientation
        )

//        addGrayOverlay()
    }
    
//    private func addGrayOverlay() {
//
//        grayOverlay.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//
//        grayOverlay.translatesAutoresizingMaskIntoConstraints = false
//
//        blurImaageView.addSubview(grayOverlay)
//
//        NSLayoutConstraint.activate([
//            grayOverlay.leadingAnchor.constraint(equalTo: blurImaageView.leadingAnchor),
//            grayOverlay.trailingAnchor.constraint(equalTo: blurImaageView.trailingAnchor),
//            grayOverlay.topAnchor.constraint(equalTo: blurImaageView.topAnchor),
//            grayOverlay.bottomAnchor.constraint(equalTo: blurImaageView.bottomAnchor)
//        ])
//    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        blurImaageView.sd_cancelCurrentImageLoad()
//        
//        blurImaageView.image = nil
//    }
    
    
    func configure(mediaURL: String) {
        guard let url = URL(string: mediaURL) else {
            mainImageView.image = nil
            blurImaageView.image = nil
            playButton.isHidden = true
            return
        }
        let ext = url.pathExtension.lowercased()
        if ["mp4", "mov", "m4v", "avi"].contains(ext) {
            playButton.isHidden = false
            videoURL = mediaURL
            CommonUtils.generateThumbnail(url: url) { image in
                DispatchQueue.main.async {
                    self.mainImageView.image = image
                    self.blurImaageView.image = image
                }
            }
        } else {
            playButton.isHidden = true
            videoURL = nil
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            blurImaageView.sd_setImage(with: url)
            mainImageView.sd_setImage(with: url)
        }
    }
    
}
