//
//  SavedAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class SavedAddressViewController: UIViewController {

    @IBOutlet weak var savedAddressTableView: UITableView! {
        didSet {
            savedAddressTableView.registerCellFromNib(cellID: "SavedAddressTableViewCell")
        }
    }
    private var selectedAddressIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAddressDidTapped(_ sender: Any) {
        let vc = AddAddressViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .forAddNewAddress
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension SavedAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressTableViewCell", for: indexPath) as! SavedAddressTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        if selectedAddressIndex == indexPath.row {
            cell.selectedRadioImageView.image = UIImage(named: "radioSelected")
        } else {
            cell.selectedRadioImageView.image = UIImage(named: "radioUnselected")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAddressIndex = indexPath.row
        savedAddressTableView.reloadData()
    }
    
}


extension SavedAddressViewController: SavedAddressCellDelegate {
    
    func didTapEdit(indexPath: IndexPath) {
        print("Edit tapped at row \(indexPath.row)")
        // Navigate to Edit Screen or open popup
        let vc = AddAddressViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .forEditAddress
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
//    func didTapDelete(indexPath: IndexPath) {
//        print("Delete tapped at row \(indexPath.row)")
//        
//        // 1. Remove data from array
////        savedAddresses.remove(at: indexPath.row)
//        
//        // 2. Delete row with animation
//        savedAddressTableView.beginUpdates()
//        savedAddressTableView.deleteRows(at: [indexPath], with: .fade)
//        savedAddressTableView.endUpdates()
//        
//        
//    }
    
    func didTapDelete(indexPath: IndexPath) {
        
        self.showConfirmationAlert(msg: "Are you sure you want to delete this address?") { [weak self] in
            guard let self = self else { return }

            print("Confirmed delete at row \(indexPath.row)")

            // 1. Remove data from array
//            self.savedAddresses.remove(at: indexPath.row)

            // 2. Delete row with animation
            self.savedAddressTableView.beginUpdates()
            self.savedAddressTableView.deleteRows(at: [indexPath], with: .fade)
            self.savedAddressTableView.endUpdates()
        }
    }


}
