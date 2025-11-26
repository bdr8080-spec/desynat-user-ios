//
//  SavedAddressTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class SavedAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var selectedRadioImageView: UIImageView!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    
    weak var delegate: SavedAddressCellDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        delegate?.didTapDelete(indexPath: indexPath)
    }
    
    
    @IBAction func editDidTapped(_ sender: Any) {
        delegate?.didTapEdit(indexPath: indexPath)
    }
    
    func configData(data: SavedAddressList) {
        nameLabel.text = data.name ?? ""
        addressLabel.text = "\(data.houseNo ?? ""), \(data.streetNo ?? ""), \(data.city ?? "")"
        addressTypeLabel.text = getAddressType(type: data.saveAddressAs ?? 0)

    }
}


protocol SavedAddressCellDelegate: AnyObject {
    func didTapEdit(indexPath: IndexPath)
    func didTapDelete(indexPath: IndexPath)
}

func getAddressType(type: Int) -> String {
    switch type {
    case 1: return "Home"
    case 0: return "Office"
    default: return "Other"
    }
}


