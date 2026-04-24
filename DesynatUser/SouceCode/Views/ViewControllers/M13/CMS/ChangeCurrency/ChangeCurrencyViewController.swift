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
    
    var selectedCurrencyIndex = 0
    var comingReason: ComingReasonAtChangeCurrency = .comingFromCurrency
    var comingUserRole: UserRoleType = .normalUser
    private lazy var viewModel = ChangeCurrencyViewModel(hostVc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch comingReason {
        case .comingFromCurrency:
            titleLabel.text = "Change Currency"
            // call get currency api
        case .comingFromCountry:
            titleLabel.text = "Change Country"
            viewModel.getALlUserCountryListApi()
            // call get country api
        }
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChangeCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch comingReason{
        case .comingFromCurrency:
            return viewModel.currencyList.count
        case .comingFromCountry:
            return viewModel.getAllUSerCountryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCurrencyTableViewCell", for: indexPath) as! ChangeCurrencyTableViewCell
        if selectedCurrencyIndex == indexPath.row {
            cell.mainImageView.image = .radioSelected
            cell.mainView.borderColor = .darkBrown
        } else {
            cell.mainImageView.image = .radioUnselected
            cell.mainView.borderColor = UIColor.lightGray
        }
       // cell.configData(comingReason: comingReason)
        switch comingReason {
        case .comingFromCurrency:
            let currency = viewModel.currencyList[indexPath.row]
            cell.configureCell(comingReason: .comingFromCurrency, currency: currency)
            
        case .comingFromCountry:
            let country = viewModel.getAllUSerCountryList[indexPath.row]
            cell.configureCell(comingReason: .comingFromCountry, country: country)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCurrencyIndex = indexPath.row
        listTableView.reloadData()
    }
}

enum ComingReasonAtChangeCurrency {
    case comingFromCurrency
    case comingFromCountry
}
