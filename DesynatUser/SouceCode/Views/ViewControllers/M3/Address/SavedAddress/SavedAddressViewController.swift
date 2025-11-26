//
//  SavedAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class SavedAddressViewController: UIViewController {

    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var savedAddressTableView: UITableView! {
        didSet {
            savedAddressTableView.registerCellFromNib(cellID: "SavedAddressTableViewCell")
        }
    }
    private var selectedAddressIndex = 0
    private lazy var viewModel = SavedAddressViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSavedAddressListAPI()
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
        return viewModel.savedAddressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressTableViewCell", for: indexPath) as! SavedAddressTableViewCell
        let data = viewModel.savedAddressList[indexPath.row]
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
        let selectedAddress = viewModel.savedAddressList[indexPath.row]
        let vc = AddAddressViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .forEditAddress
        vc.editAddressID = selectedAddress.id
        vc.addressData = selectedAddress
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didTapDelete(indexPath: IndexPath) {

        let address = viewModel.savedAddressList[indexPath.row]
        let id = address.id ?? 0

        self.showConfirmationAlert(msg: "Are you sure you want to delete this address?") { [weak self] in
            guard let self = self else { return }

            self.viewModel.deleteAddressAPI(addressID: id) { success in
                if success {

                    // Remove locally
                    self.viewModel.savedAddressList.remove(at: indexPath.row)

                    // Animate deletion
                    self.savedAddressTableView.beginUpdates()
                    self.savedAddressTableView.deleteRows(at: [indexPath], with: .left)
                    self.savedAddressTableView.endUpdates()

                    // Show "No Data"
                    self.noDataFoundLabel.isHidden = !self.viewModel.savedAddressList.isEmpty
                } else {
                    self.showAlert(msg: "Failed to delete address. Try again.")
                }
            }
        }
    }



}
