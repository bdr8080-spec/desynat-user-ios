//
//  WalletMoneyListViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import UIKit

class WalletMoneyListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var totalamountLabel: UILabel!
    @IBOutlet weak var walletTableView: UITableView! {
        didSet {
            walletTableView.registerCellFromNib(cellID: "WalletMoneyListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = WalletMoneyListViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWalletHistory()
    }
    
    // MARK: - Button's Action
    @IBAction func addMoneyDidTapped(_ sender: Any) {
        let nextVC = AddMoneyViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func reedemGiftDidTapped(_ sender: Any) {
        let nextVC = RedeemGiftCardViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
    func setData() {
        totalamountLabel.text = CommonUtils.formatPriceStringInput(viewModel.walletData?.walletBalance, currency: "KD")
    }
    
}

// MARK: - TABLE VIEW METHODS
extension WalletMoneyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.walletData?.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletMoneyListTableViewCell", for: indexPath) as! WalletMoneyListTableViewCell
        let data = viewModel.walletData?.history?[indexPath.row]
        cell.configData(data: data)
        return cell
    }
}
