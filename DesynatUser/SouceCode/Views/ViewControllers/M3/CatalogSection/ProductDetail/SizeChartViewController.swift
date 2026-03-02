//
//  SizeChartViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//


import UIKit
import SDWebImage

class SizeChartViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var mainImageView: CustomImageView!
    
    // MARK: - Property Decalaration
    var sizeChartUrl: String? = ""
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.clipsToBounds = true
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func configData() {
        if let imageUrlString = sizeChartUrl,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
    }
    
}
