//
//  SideMenuTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: SideMenuModel) {
        titleLabel.text = data.title.localiz()
        mainImageView.image = UIImage(named: data.image)
    }
    
}


