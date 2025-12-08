//
//  MyBagViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class MyBagViewController: UIViewController {
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var promocodeLabel: UILabel!
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
  var deliveryId: Int = 0
  var isPromoCodeApplied: Bool = false
  var selectedPromoCode: GetPromoCodeListDataModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getBagDetailsApi()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    DispatchQueue.main.async {
      self.bagTableViewHeightConstraint.constant = self.bagTableView.contentSize.height
    }
  }
  
  @IBAction func applyPromocodeDidTapped(_ sender: Any) {
    let nextVC = PromoCodeListViewController.instantiate(fromAppStoryboard: .MyBag)
    nextVC.deliveryAddress = viewModel.bagDetails?.userAddress?.id ?? 0
    nextVC.totalAmount = viewModel.bagDetails?.totalAmount ?? 0
    nextVC.onPromoSelected = { [weak self] selectedPromo in
      self?.selectedPromoCode = selectedPromo
      self?.promocodeLabel.text = selectedPromo.nameEnglish
      self?.isPromoCodeApplied = true
    }
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @IBAction func deliveryAddressAction(_ sender: Any) {
    let nextVC = SavedAddressViewController.instantiate(fromAppStoryboard: .Profile)
    nextVC.onAddressSelected = { [weak self] selectedAddress in
      self?.deliveryId = selectedAddress.id ?? 0
      let addressLine = "\(selectedAddress.name ?? "") \(selectedAddress.houseNo ?? ""), \(selectedAddress.streetNo ?? ""), \(selectedAddress.city ?? ""), \(selectedAddress.state ?? ""), \(selectedAddress.countryName ?? "")-\(selectedAddress.postalCode ?? "")"
      self?.addressLabel.text = addressLine
    }
    self.navigationController?.pushViewController(nextVC, animated: false)
  }
  
  @IBAction func placeOrderDidTapped(_ sender: Any) {
    viewModel.placeOrderApi()
  }
  
  func condifData(data: MyCartDetailsDataModel) {
    totalMRP.text = "\(data.totalMrp ?? 0) KD"
    dricountOnMRP.text = "\(data.discountOnMrp ?? 0) KD"
    couponDidcountLabel.text = "\(data.discountCoupon ?? 0) KD"
    shippingFeeLabel.text = "\(data.shippingFees ?? 0) KD"
    taxLabel.text = "\(data.tax ?? 0) KD"
    totalAmountLabel.text = "\(data.totalAmount ?? 0) KD"
    finalPriceLabel.text = "\(data.totalAmount ?? 0) KD"
    let selectedAddress = data.userAddress
    deliveryId = selectedAddress?.id ?? 0
    let addressLine = "\(selectedAddress?.name ?? "") \(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
    addressLabel.text = addressLine
    CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(data.totalMrp ?? 0) KD")
    let savingAmount = (data.totalMrp ?? 0) - (data.totalAmount ?? 0)
    saveAmountLAbel.text = "You will save \(savingAmount) KD on this"
  }
  
}

extension MyBagViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.bagDetails?.cartData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyBagTableViewCell", for: indexPath) as! MyBagTableViewCell
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
    let productId = viewModel.bagDetails?.cartData?[indexPath.row].productID
    nextVC.productId = productId
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    viewWillLayoutSubviews()
  }
}
