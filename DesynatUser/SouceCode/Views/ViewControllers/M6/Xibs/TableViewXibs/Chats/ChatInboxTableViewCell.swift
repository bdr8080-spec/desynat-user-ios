//
//  ChatInboxTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import SDWebImage

class ChatInboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var messagecountView: CustomView!
    @IBOutlet weak var messageTypeStatusView: CustomView!
    @IBOutlet weak var messageTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configData(data: ChatInboxListModel?) {
        if let imageUrlString = data?.sellerDetails?.profilePic,
           let url = URL(string: imageUrlString) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            userProfileImageView.image = UIImage(named: "userProfile")
        }
        usernameLabel.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
        if data?.messageType == "1" {
            messageLabel.text = "Sent an attachment"
        } else {
            messageLabel.text = data?.lastChat ?? ""
        }
        timeLabel.text = formattedChatTime(from: data?.updatedAt ?? "")
        let unreadMesageCount = data?.unreadCount ?? 0
        if unreadMesageCount > 0 {
            messagecountView.isHidden = false
            messageCountLabel.text = unreadMesageCount.description
        } else {
            messagecountView.isHidden = true
        }
        let messageType = data?.type ?? "1"
        
        let requestType = data?.productRequest ?? "1"
        let actiontype = data?.action ?? "1"
        if messageType == "1" {
            messageTypeStatusView.isHidden = true
        } else {
            messageTypeStatusView.isHidden = false
            switch actiontype {
            case "0":
                messageTypeStatusView.isHidden = true
                if requestType == "1" {
                    messageTypeStatusView.isHidden = false
                    messageTypeLabel.text = "Waiting"
                    messageTypeLabel.textColor = UIColor(hex: "#EA9413") // orange
                    messageTypeStatusView.backgroundColor = UIColor(hex: "#EA9413").withAlphaComponent(0.15)
                }
            case "1":
                messageTypeLabel.text = "Quotation Received"
                messageTypeLabel.textColor = UIColor(hex: "#172B85") // dark blue
                messageTypeStatusView.backgroundColor = UIColor(hex: "#172B85").withAlphaComponent(0.15)
            case "2":
                messageTypeLabel.text = "Quotation Received"
                messageTypeLabel.textColor = UIColor(hex: "#172B85") // dark blue
                messageTypeStatusView.backgroundColor = UIColor(hex: "#172B85").withAlphaComponent(0.15)
            case "4":
                messageTypeLabel.text = "Rejected"
                messageTypeLabel.textColor = UIColor(hex: "#EA9413") // red
                messageTypeStatusView.backgroundColor = UIColor(hex: "#EA9413").withAlphaComponent(0.15)
            case "5":
                messageTypeLabel.text = "Quotation Accepted"
                messageTypeLabel.textColor = UIColor(hex: "#17854C") // green
                messageTypeStatusView.backgroundColor = UIColor(hex: "#17854C").withAlphaComponent(0.15)
                let isOrderPlaced = data?.orderCreateStatus?.id != nil
                if isOrderPlaced {
                    messageTypeLabel.text = "Placed"
                    messageTypeLabel.textColor = UIColor(hex: "#EA9413") // red
                    messageTypeStatusView.backgroundColor = UIColor(hex: "#EA9413").withAlphaComponent(0.15)
                }
                if data?.productBuyStatus == "1" {
                    messageTypeLabel.text = "Placed"
                    messageTypeLabel.textColor = UIColor(hex: "#EA9413") // red
                    messageTypeStatusView.backgroundColor = UIColor(hex: "#EA9413").withAlphaComponent(0.15)
                }
            default:
                messageTypeStatusView.isHidden = true
            }
        }
    }
    
    func formattedChatTime(from isoString: String) -> String {
        
        // Parse ISO string
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: isoString) else {
            return ""
        }
        
        let calendar = Calendar.current
        //      let now = Date()
        
        // Time formatter
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = .current
        timeFormatter.dateFormat = "h:mm a"
        
        // Date formatter (fallback)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd/MM/yy, h:mm a"
        
        // Today
        if calendar.isDateInToday(date) {
            return "Today \(timeFormatter.string(from: date))"
        }
        
        // Yesterday
        if calendar.isDateInYesterday(date) {
            return "Yesterday \(timeFormatter.string(from: date))"
        }
        
        // Older dates
        return dateFormatter.string(from: date)
    }
    
}
