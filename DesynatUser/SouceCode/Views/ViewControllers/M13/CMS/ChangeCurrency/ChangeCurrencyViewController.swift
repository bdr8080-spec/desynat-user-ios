//
//  ChangeCurrencyViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class ChangeCurrencyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "ChangeCurrencyTableViewCell")
        }
    }
    
    var selectedId = 89 // kuwait
    var comingReason: ComingReasonAtChangeCurrency = .comingFromCurrency
    var comingUserRole: UserRoleType = .normalUser
    private lazy var viewModel = ChangeCurrencyViewModel(hostVc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch comingReason {
        case .comingFromCurrency:
            titleLabel.text = "Change Currency".localiz()
            viewModel.getAllUsersCurrencyList()
        case .comingFromCountry:
            titleLabel.text = "Change Country".localiz()
            viewModel.getALlUserCountryListApi()
        }
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveDidTapped(_ sender: Any) {
        switch comingReason {
        case .comingFromCurrency:
            guard selectedId != -1 else {
                CommonUtils.showToast(message: "Please select country".localiz())
                return
            }
            switch comingUserRole {
            case .normalUser:
                viewModel.updateCurrency()
            case .affilaiteUser:
                viewModel.updateAffiliateCurrency()
            }
        case .comingFromCountry:
            guard selectedId != -1 else {
                CommonUtils.showToast(message: "Please select country".localiz())
                return
            }
            switch comingUserRole {
            case .normalUser:
                viewModel.updateCountry()
            case .affilaiteUser:
                viewModel.updateAffiliateCountry()
            }
        }
    }
}

extension ChangeCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch comingReason{
        case .comingFromCurrency:
            return viewModel.getAllUSerCountryList.count
        case .comingFromCountry:
            return viewModel.getAllUSerCountryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCurrencyTableViewCell", for: indexPath) as! ChangeCurrencyTableViewCell
        let country = viewModel.getAllUSerCountryList[indexPath.row]
        switch comingReason {
        case .comingFromCurrency:
            cell.configureCell(comingReason: .comingFromCurrency, country: country)
            if selectedId == country.id {
                cell.mainImageView.image = .radioSelected
                cell.mainView.borderColor = .darkBrown
            } else {
                cell.mainImageView.image = .radioUnselected
                cell.mainView.borderColor = UIColor.lightGray
            }
        case .comingFromCountry:
            cell.configureCell(comingReason: .comingFromCountry, country: country)
            if selectedId == country.id {
                cell.mainImageView.image = .radioSelected
                cell.mainView.borderColor = .darkBrown
            } else {
                cell.mainImageView.image = .radioUnselected
                cell.mainView.borderColor = UIColor.lightGray
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch comingReason {
        case .comingFromCurrency:
            selectedId = viewModel.getAllUSerCountryList[indexPath.row].id ?? 1
        case .comingFromCountry:
            selectedId = viewModel.getAllUSerCountryList[indexPath.row].id ?? 1
        }
        listTableView.reloadData()
    }
}

enum ComingReasonAtChangeCurrency {
    case comingFromCurrency
    case comingFromCountry
}
