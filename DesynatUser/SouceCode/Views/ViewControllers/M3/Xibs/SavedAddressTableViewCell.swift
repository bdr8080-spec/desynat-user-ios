//
//  SavedAddressTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class SavedAddressTableViewCell: UITableViewCell {

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
}


protocol SavedAddressCellDelegate: AnyObject {
    func didTapEdit(indexPath: IndexPath)
    func didTapDelete(indexPath: IndexPath)
}
