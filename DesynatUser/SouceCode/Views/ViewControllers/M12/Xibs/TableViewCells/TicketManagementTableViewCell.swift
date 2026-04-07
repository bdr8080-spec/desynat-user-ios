//
//  TicketManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class TicketManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var raisedOnDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resolvedOnDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: SupportList?) {
        
    }
    
}
