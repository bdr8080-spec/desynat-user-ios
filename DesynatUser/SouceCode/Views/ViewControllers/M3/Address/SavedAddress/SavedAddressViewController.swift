//
//  SavedAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class SavedAddressViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var proceedButtonView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var savedAddressTableView: UITableView! {
        didSet {
            savedAddressTableView.registerCellFromNib(cellID: "SavedAddressTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var selectedAddressIndex = 0
    private lazy var viewModel = SavedAddressViewModel(hostVC: self)
    var onAddressSelected: ((SavedAddressList) -> Void)?
    var comingFromBag: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSavedAddressListAPI()
        if comingFromBag {
            proceedButtonView.isHidden = false
        } else {
            proceedButtonView.isHidden = true
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAddressDidTapped(_ sender: Any) {
        let vc = AddAddressViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .forAddNewAddress
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func proceedDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension SavedAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedAddressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressTableViewCell", for: indexPath) as! SavedAddressTableViewCell
        let data = viewModel.savedAddressList[indexPath.row]
        cell.configData(data: data)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
}

extension SavedAddressViewController: SavedAddressCellDelegate {
    
    func didTapRadioButton(indexPath: IndexPath) {
        let selectedAddress = viewModel.savedAddressList[indexPath.row]
        let selectedAddressID = selectedAddress.id ?? 0
        viewModel.makeDefaultAddressAPI(addressID: selectedAddressID) { [weak self] success in
            guard let self = self else { return }
            if success {
                for i in 0..<self.viewModel.savedAddressList.count {
                    self.viewModel.savedAddressList[i].setAsDefault = (i == indexPath.row) ? "1" : "0"
                }
                onAddressSelected?(selectedAddress)
                self.savedAddressTableView.reloadData()
            } else {
                self.showAlert(msg: "Failed to set default address".localiz())
            }
        }
    }
    
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
        self.showConfirmationAlert(msg: "Are you sure you want to delete this address?".localiz()) { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteAddressAPI(addressID: id) { success in
                if success {
                    self.viewModel.savedAddressList.remove(at: indexPath.row)
                    self.savedAddressTableView.beginUpdates()
                    self.savedAddressTableView.deleteRows(at: [indexPath], with: .left)
                    self.savedAddressTableView.endUpdates()
                    self.noDataFoundLabel.isHidden = !self.viewModel.savedAddressList.isEmpty
                } else {
                    self.showAlert(msg: "Failed to delete address. Try again.".localiz())
                }
            }
        }
    }
    
}
