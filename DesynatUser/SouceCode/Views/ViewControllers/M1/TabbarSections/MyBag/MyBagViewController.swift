//
//  MyBagViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class MyBagViewController: UIViewController {
  
  @IBOutlet weak var applyPromocodeButtonOutlet: UIButton!
  @IBOutlet weak var removeButtonOutlet: UIButton!
  @IBOutlet weak var coupoanStackView: UIStackView!
  @IBOutlet weak var couponDiscountTitleLabel: UILabel!
  @IBOutlet weak var totoalAmountPriceView: UIView!
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
  var selectedPromoCode: PromocodeApplied?
  var slecetedPromocodeID: Int? = 0
  var totalAmount: Double = 0.0
  var totalMRPDiscountValue: Double = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    if !isPromoCodeApplied {
            viewModel.getBagDetailsApi()
//        }
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
    nextVC.totalAmount = viewModel.bagDetails?.totalAmount ?? 0.0
    nextVC.onPromoSelected = { [weak self] selectedPromo, promocodeId in
      self?.coupoanStackView.isHidden = false
      self?.slecetedPromocodeID = promocodeId
      self?.removeButtonOutlet.isHidden = false
      self?.applyPromocodeButtonOutlet.isHidden = true
      self?.selectedPromoCode = selectedPromo
      self?.totalAmountLabel.text = self?.formatPrice(selectedPromo.finalAmount)
      self?.promocodeLabel.text = selectedPromo.discountCode
      self?.couponDiscountTitleLabel.text = "Coupon Discount (\(selectedPromo.discountCode ?? ""))"
      self?.couponDidcountLabel.text = self?.formatPrice(selectedPromo.applyDiscountValue)//"\(selectedPromo.applyDiscountValue ?? 0)"
      self?.isPromoCodeApplied = true
      self?.finalPriceLabel.text = self?.formatPrice(selectedPromo.finalAmount)
      let savingAmount = (self?.totalMRPDiscountValue ?? 0) + (selectedPromo.applyDiscountValue ?? 0)
      self?.saveAmountLAbel.text = "You will save \(self?.formatPrice(savingAmount) ?? "") KD on this"
    }
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
  @IBAction func removeDidTapped(_ sender: Any) {
    self.coupoanStackView.isHidden = true
    self.couponDidcountLabel.text = ""
    self.slecetedPromocodeID = 0
    self.totalAmountLabel.text = formatPrice(totalAmount)
    self.finalPriceLabel.text = formatPrice(totalAmount)
    self.removeButtonOutlet.isHidden = true
    self.applyPromocodeButtonOutlet.isHidden = false
    let savingAmount = (self.totalMRPDiscountValue)
    self.saveAmountLAbel.text = "You will save \(self.formatPrice(savingAmount)) KD on this"
  }
  
  @IBAction func deliveryAddressAction(_ sender: Any) {
    let nextVC = SavedAddressViewController.instantiate(fromAppStoryboard: .Profile)
    nextVC.comingFromBag = true
    nextVC.onAddressSelected = { [weak self] selectedAddress in
      self?.deliveryId = selectedAddress.id ?? 0
      let addressLine = "\(selectedAddress.name ?? "")-\(selectedAddress.houseNo ?? ""), \(selectedAddress.streetNo ?? ""), \(selectedAddress.city ?? ""), \(selectedAddress.state ?? ""), \(selectedAddress.countryName ?? "")-\(selectedAddress.postalCode ?? "")"
      self?.addressLabel.text = addressLine
    }
    self.navigationController?.pushViewController(nextVC, animated: false)
  }
  
  @IBAction func placeOrderDidTapped(_ sender: Any) {
    viewModel.placeOrderApi()
  }
  
//  func condifData(data: MyCartDetailsDataModel) {
//    totalMRPDiscountValue = data.discountOnMrp ?? 0.0
//    totalMRP.text = formatPrice(data.totalMrp)//"\(data.totalMrp ?? 0) KD"
//    dricountOnMRP.text = formatPrice(data.discountOnMrp)//"\(data.discountOnMrp ?? 0) KD"
//    couponDidcountLabel.text = formatPrice(data.discountCoupon)//"\(data.discountCoupon ?? 0) KD"
//    shippingFeeLabel.text = formatPrice(data.shippingFees)//"\(data.shippingFees ?? 0) KD"
//    taxLabel.text = formatPrice(data.tax)//"\(data.tax ?? 0) KD"
//    totalAmount = data.totalAmount ?? 0.0
//    totalAmountLabel.text = formatPrice(data.totalAmount)//"\(data.totalAmount ?? 0) KD"
//    finalPriceLabel.text = formatPrice(data.totalAmount)//"\(data.totalAmount ?? 0) KD"
//    let selectedAddress = data.userAddress
//    deliveryId = selectedAddress?.id ?? 0
//    let addressLine = "\(selectedAddress?.name ?? "") \(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
//    addressLabel.text = addressLine
//    CommonUtils.setStrikethrough(label: actualPriceLAbel, text: formatPrice(data.totalMrp))//"\(data.totalMrp ?? 0) KD")
//    let savingAmount = (data.discountOnMrp ?? 0)// - (data.totalAmount ?? 0)
//    saveAmountLAbel.text = "You will save \(formatPrice(savingAmount)) KD on this"
//  }
  
  func condifData(data: MyCartDetailsDataModel) {
    totalMRPDiscountValue = data.discountOnMrp ?? 0.0
      totalMRP.text = formatPrice(data.totalMrp)
      dricountOnMRP.text = formatPrice(data.discountOnMrp)

      // FIX: Only use API value when promo NOT applied
      if isPromoCodeApplied, let selected = selectedPromoCode {
          couponDidcountLabel.text = formatPrice(selected.applyDiscountValue)
          finalPriceLabel.text = formatPrice(selected.finalAmount)
          totalAmountLabel.text = formatPrice(selected.finalAmount)
      } else {
          couponDidcountLabel.text = formatPrice(data.discountCoupon)
          finalPriceLabel.text = formatPrice(data.totalAmount)
          totalAmountLabel.text = formatPrice(data.totalAmount)
        let savingAmount = (data.discountOnMrp ?? 0)// - (data.totalAmount ?? 0)
        saveAmountLAbel.text = "You will save \(formatPrice(savingAmount)) KD on this"
      }
    let selectedAddress = data.userAddress
    deliveryId = selectedAddress?.id ?? 0
    let addressLine = "\(selectedAddress?.name ?? "")-\(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
    addressLabel.text = addressLine
      shippingFeeLabel.text = formatPrice(data.shippingFees)
      taxLabel.text = formatPrice(data.tax)

      totalAmount = data.totalAmount ?? 0

      CommonUtils.setStrikethrough(label: actualPriceLAbel, text: formatPrice(data.totalMrp))
  }

  
  func formatPrice(_ amount: Double?, currency: String = "KD") -> String {
      guard let amount = amount else { return "0 \(currency)" }
      
      let roundedAmount = round(amount * 100) / 100   // Round to 2 decimal places
      if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
          // If whole number, show without decimal
          return "\(Int(roundedAmount)) \(currency)"
      } else {
          // Show up to 2 decimal places
          return String(format: "%.2f", roundedAmount) + " \(currency)"
      }
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
//    viewModel.singleStoresSection?.allProduct?.data?[indexPath.row].id
    nextVC.productId = productId
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    viewWillLayoutSubviews()
  }
}
