//
//  PaymentMethodsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PaymentMethodsTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var radioButonOutlet: UIButton!
  @IBOutlet weak var paymentMethodImageView: UIImageView!
  @IBOutlet weak var descriptionLable: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  func configData(data: PaymentMethod) {
    titleLabel.text = data.paymentMethodTitle
    paymentMethodImageView.image = UIImage(named: data.paymentMethodImage)
    descriptionLable.isHidden = data.showDescription
  }
    
}
