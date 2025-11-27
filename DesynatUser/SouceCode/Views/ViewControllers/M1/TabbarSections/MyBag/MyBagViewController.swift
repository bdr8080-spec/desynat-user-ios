//
//  MyBagViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class MyBagViewController: UIViewController {

    @IBOutlet weak var actualPriceLAbel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var saveAmountLAbel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var shippingFeeLabel: UILabel!
    @IBOutlet weak var couponDidcountLabel: UILabel!
    @IBOutlet weak var dricountOnMRP: UILabel!
    @IBOutlet weak var totalMRP: UILabel!
    @IBOutlet weak var bagDetailsView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var bagTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bagTableView: UITableView! {
        didSet {
            bagTableView.registerCellFromNib(cellID: "MyBagTableViewCell")
        }
    }
    private lazy var viewModel = MyBagViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.gteBagDetailsApi()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.bagTableViewHeightConstraint.constant = self.bagTableView.contentSize.height
        }
    }
    
    func condifData(data: MyCartDetailsDataModel) {
        totalMRP.text = "\(data.totalMrp ?? 0) KD"
        dricountOnMRP.text = "\(data.discountOnMrp ?? 0) KD"
        couponDidcountLabel.text = "\(data.discountCoupon ?? 0) KD"
        shippingFeeLabel.text = "\(data.shippingFees ?? 0) KD"
        taxLabel.text = "\(data.tax ?? 0) KD"
        totalAmountLabel.text = "\(data.totalAmount ?? 0) KD"
//        saveAmountLAbel.text = "\(data.s ?? 0)"
        finalPriceLabel.text = "\(data.totalAmount ?? 0) KD"
        CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(data.totalMrp ?? 0) KD")
    }

}

extension MyBagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bagDetails?.cartData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBagTableViewCell", for: indexPath) as! MyBagTableViewCell
        let data = viewModel.bagDetails?.cartData?[indexPath.row]
        if let data = viewModel.bagDetails?.cartData?[indexPath.row] {
                cell.configData(data: data)
            }
        if indexPath.row == 1 {
            cell.shopMoreButtonOutlet.isHidden = false
            cell.borderLabel.isHidden = true
        } else{
            cell.shopMoreButtonOutlet.isHidden = true
            cell.borderLabel.isHidden = false
        }
        
        let cartItem = viewModel.bagDetails?.cartData?[indexPath.row]

            cell.onIncrement = { [weak self] in
                guard let cartID = cartItem?.id else { return }
                self?.viewModel.handleIncrementDecrement(cartID: cartID, type: "increment", index: indexPath.row)
            }

            cell.onDecrement = { [weak self] in
                guard let cartID = cartItem?.id else { return }
                self?.viewModel.handleIncrementDecrement(cartID: cartID, type: "decrement", index: indexPath.row)
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}
