//
//  ChatInboxTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import SDWebImage

class ChatInboxTableViewCell: UITableViewCell {

  @IBOutlet weak var messageTypeStatusView: CustomView!
  @IBOutlet weak var messageTypeLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userProfileImageView: CustomImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
//    messageLabel.text = data?.lastChat ?? "Sent an attachment"
    if data?.messageType == "1" {
      messageLabel.text = "Sent an attachment"
    } else {
      messageLabel.text = data?.lastChat ?? "Sent an attachment"
    }
    timeLabel.text = formattedChatTime(from: data?.updatedAt ?? "")
    let messageType = data?.type ?? "1" // normal msg, customization send
//    let productRequest = data?.productRequest ?? "1"
      
//      if messageType != "1" {
//        switch actiontype {
//        case "0": //user sent chat for customization new
//          sendRequestButtonOutlet.isHidden = false
//          if requestType == "1" {
//            waitingButtonOutlet.isHidden = false
//            waitingButtonOutlet.setTitle("Waiting", for: .normal)
//            sendRequestButtonOutlet.isHidden = true
//          }
//        case "2", "5":
//          viewRequestButtonOutlet.isHidden = false
//          if actiontype == "5" {
//            let isOrderPlaced = data?.orderCreateStatus?.id != nil
//            if isOrderPlaced {
//              viewRequestButtonOutlet.isHidden = true
//              waitingButtonOutlet.isHidden = false
//              waitingButtonOutlet.setTitle("Placed", for: .normal)
//            }
//          }
//        case "4":
//          waitingButtonOutlet.isHidden = false
//          waitingButtonOutlet.setTitle("Rejected", for: .normal)
//        default:
//          print("")
//        }
      
      
      
      
      
      
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
        messageTypeLabel.text = "Quotation Sent"
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
      default:
        messageTypeStatusView.isHidden = true
      }
    }
  }
  
  func formattedChatTime(from isoString: String) -> String {
      
      // 1️⃣ Parse ISO string
      let isoFormatter = ISO8601DateFormatter()
      isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      
      guard let date = isoFormatter.date(from: isoString) else {
          return ""
      }
      
      let calendar = Calendar.current
//      let now = Date()
      
      // 2️⃣ Time formatter
      let timeFormatter = DateFormatter()
      timeFormatter.locale = Locale.current
      timeFormatter.timeZone = .current
      timeFormatter.dateFormat = "h:mm a"
      
      // 3️⃣ Date formatter (fallback)
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale.current
      dateFormatter.timeZone = .current
      dateFormatter.dateFormat = "dd/MM/yy, h:mm a"
      
      // 4️⃣ Today
      if calendar.isDateInToday(date) {
          return "Today \(timeFormatter.string(from: date))"
      }
      
      // 5️⃣ Yesterday
      if calendar.isDateInYesterday(date) {
          return "Yesterday \(timeFormatter.string(from: date))"
      }
      
      // 6️⃣ Older dates
      return dateFormatter.string(from: date)
  }
    
}
