//
//  LiveUsersCell.swift
//  DesynatUser
//
//  Created by Riya Mac on 01/04/26.
//

import UIKit
import SDWebImage

class LiveUsersCell: UITableViewCell {

    @IBOutlet weak var watchLiveButton: CustomButton!
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
            joinedOnLabel.text = "\("Joined on".localiz()) \(result)"
            let liveDateresult = convertDate(data?.timeslotDetails?.date ?? "")
            
            let fromtime = customizeChangeDateFormatZone(
                inputDate: data?.timeslotDetails?.from ?? "",
                inputFormat: "hh:mm a",
                outputFormat: "h:mm a"
            )
            
           // let liveDateresult = convertDate(data?.timeslotDetails?.date ?? "")
            liveDateLabel.text = "\("Live Timing".localiz()) \(liveDateresult)"
            livetimeLabel.text = fromtime
//            liveDateLabel.text = "Live Timing \(liveDateresult)"
//            livetimeLabel.text = data?.timeslotDetails?.from ?? ""
            countryNameLabel.text = data?.timeslotDetails?.countryInfo?.name ?? ""
            
            let isLive = isEventLive(
                            dateString: data?.timeslotDetails?.date,
                            fromTime: data?.timeslotDetails?.from,
                            toTime: data?.timeslotDetails?.to
                        )
                        
                        watchLiveButton.isUserInteractionEnabled = isLive
                        watchLiveButton.alpha = isLive ? 1.0 : 0.5   // dim when disabled
        }
        
    func customizeChangeDateFormatZone(
        inputDate: String,
        inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        outputFormat: String = "hh:mm a"
    ) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        
        guard let date = inputFormatter.date(from: inputDate) else {
            print("❌ Parse failed: \(inputDate)")
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Local timezone
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date)
    }
    
    func isEventLive(dateString: String?, fromTime: String?, toTime: String?) -> Bool {
        guard let dateString = dateString,
              let fromTime = fromTime,
              let toTime = toTime else { return false }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        formatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"

        let startString = "\(dateString) \(fromTime)"
        let endString = "\(dateString) \(toTime)"

        guard let startDate = formatter.date(from: startString),
              let endDate = formatter.date(from: endString) else {
            print("Parsing failed:", startString, endString)
            return false
        }

        let now = Date() // local time but comparable correctly via absolute Date

        return now >= startDate && now <= endDate
    }
    
    func convertDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: input) else {
            return input
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Local timezone
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "dd/MM/yyyy"

        return outputFormatter.string(from: date)
    }
    
    private func convertISOToDMY(_ isoString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current   // ✅ LOCAL TIME
        outputFormatter.dateFormat = "dd/MM/yyyy"

        return outputFormatter.string(from: date)
    }

    }

