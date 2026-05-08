//
//  NotificationsListTableViewCell.swift
//  DesynatAdmin
//
//  Created by Geetam   on 09/03/26.
//

import UIKit

class NotificationsListTableViewCell: UITableViewCell {

    @IBOutlet weak var hoursAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var sentTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: NotificationsList?) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data?.titleArabic
            descriptionLabel.text = data?.descriptionArabic
        }else{
            titleLabel.text = data?.titleEnglish
            descriptionLabel.text = data?.descriptionEnglish
        }
        
        if data?.isRead == 1 {
            mainImageView.image = .unselectedBellIcon
        } else {
            mainImageView.image = .selectedBellIcon
        }
        sentTimeLabel.text = formatISODateToDayMonthYear(data?.createdAt ?? "")
    }
    
    private func formatISODateToDayMonthYear(_ isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: isoDateString) else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter.string(from: date)
    }
    
}
