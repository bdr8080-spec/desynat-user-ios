//
//  LiveUsersCell.swift
//  DesynatUser
//
//  Created by Riya Mac on 01/04/26.
//

import UIKit
import SDWebImage

class LiveUsersCell: UITableViewCell {

        @IBOutlet weak var userProfileImageView: CustomImageView!
        @IBOutlet weak var usernameLabel: UILabel!
        @IBOutlet weak var countryNameLabel: UILabel!
        @IBOutlet weak var joinedOnLabel: UILabel!
        @IBOutlet weak var liveDateLabel: UILabel!
        @IBOutlet weak var livetimeLabel: UILabel!
        
        var onWatchLiveSelect: (() -> Void)?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        @IBAction func watchLiveDidTapped(_ sender: Any) {
            onWatchLiveSelect?()
        }
        
        func configData(data: LiveStramingDataModel?) {
            usernameLabel.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
            if let imageUrlString = data?.sellerDetails?.profilePic,
               let url = URL(string: imageUrlString) {
                userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
            } else {
                userProfileImageView.image = UIImage(named: "userProfile")
            }
            let result = convertISOToDMY(data?.createdAt ?? "") ?? ""
            joinedOnLabel.text = "Joined on \(result)"
            let liveDateresult = convertDate(data?.timeslotDetails?.date ?? "")
            liveDateLabel.text = "Live Timing \(liveDateresult)"
            livetimeLabel.text = data?.timeslotDetails?.from ?? ""
            countryNameLabel.text = data?.timeslotDetails?.countryInfo?.name ?? ""
        }
        
        private func convertISOToDMY(_ isoString: String) -> String? {
            // ISO8601 parser
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Parse to Date
            guard let date = isoFormatter.date(from: isoString) else {
                return nil
            }
            
            // Output formatter
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            
            return outputFormatter.string(from: date)
        }
        
        func convertDate(_ input: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "M/dd/yy"  // → 2/08/25 format

            if let date = inputFormatter.date(from: input) {
                return outputFormatter.string(from: date)
            }

            return input  // fallback
        }

    }

