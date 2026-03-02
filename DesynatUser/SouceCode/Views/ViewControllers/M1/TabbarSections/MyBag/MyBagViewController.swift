//
//  MyBagViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class MyBagViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var discountOnMrpStackView: UIStackView!
    @IBOutlet weak var totalMRPStackView: UIStackView!
    @IBOutlet weak var customPriceStackView: UIStackView!
    @IBOutlet weak var customOrderPriceLabel: UILabel!
    @IBOutlet weak var customOrderTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customOrderTitleLabel: UILabel!
    @IBOutlet weak var cutomOrderTableView: UITableView! {
        didSet {
            cutomOrderTableView.registerCellFromNib(cellID: "MyBagForCustomOrderTableViewCell")
        }
    }
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
    
    // MARK: - Property Decalaration
    private lazy var viewModel = MyBagViewModel(hostVC: self)
    var deliveryId: Int = 0
    var isPromoCodeApplied: Bool = false
    var selectedPromoCode: PromocodeApplied?
    var slecetedPromocodeID: Int? = 0
    var totalAmount: Double = 0.0
    var totalMRPDiscountValue: Double = 0.0
    var isAnyItemRemovedFromCart: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            viewModel.getBagDetailsApi()
        } else {
            guestLoginUIHandle()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.bagTableViewHeightConstraint.constant = self.bagTableView.contentSize.height
            self.customOrderTableViewHeightConstraint.constant = self.cutomOrderTableView.contentSize.height
        }
    }
    
    // MARK: - Button's Action
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
            self?.actualPriceLAbel.isHidden = false
            self?.isPromoCodeApplied = true
            self?.finalPriceLabel.text = self?.formatPrice(selectedPromo.finalAmount)
            let savingAmount = (self?.totalMRPDiscountValue ?? 0) + (selectedPromo.applyDiscountValue ?? 0)
            self?.saveAmountLAbel.text = "You will save \(self?.formatPrice(savingAmount) ?? "") on this"
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func removeDidTapped(_ sender: Any) {
        self.coupoanStackView.isHidden = true
        self.couponDidcountLabel.text = ""
        self.slecetedPromocodeID = 0
        isPromoCodeApplied = false
        self.totalAmountLabel.text = formatPrice(totalAmount)
        self.finalPriceLabel.text = formatPrice(totalAmount)
        self.removeButtonOutlet.isHidden = true
        self.applyPromocodeButtonOutlet.isHidden = false
        let savingAmount = (self.totalMRPDiscountValue)
        self.saveAmountLAbel.text = "You will save \(self.formatPrice(savingAmount)) on this"
        promocodeLabel.text = "Apply PromoCode"
        let normalOrderCount = viewModel.normalOrders.count
        if normalOrderCount == 0 {
            actualPriceLAbel.isHidden = true
            let totalPrice = viewModel.customOrders
                .compactMap { $0.chatroomData?.totalAmount }
                .compactMap { amount -> Double? in
                    let cleaned = amount
                        .replacingOccurrences(of: ",", with: "") // remove thousand separators
                        .filter { "0123456789.".contains($0) }
                    
                    return Double(cleaned)
                }
                .reduce(0.0, +)
            let finalAmountForCustomOrderOnly = max(0, (totalPrice) + (viewModel.bagDetails?.shippingFees ?? 0) + (viewModel.bagDetails?.tax ?? 0))
            totalAmountLabel.text = formatPrice(finalAmountForCustomOrderOnly)
            finalPriceLabel.text = formatPrice(finalAmountForCustomOrderOnly)
        }
        let customOrderCount = viewModel.customOrders.count
        if normalOrderCount != 0 && customOrderCount != 0 {
            let totalPrice = viewModel.customOrders.compactMap { $0.chatroomData?.totalAmount }.compactMap { amount -> Double? in
                let cleaned = amount
                    .replacingOccurrences(of: ",", with: "") // remove thousand separators
                    .filter { "0123456789.".contains($0) }
                
                return Double(cleaned)
            }
                .reduce(0.0, +)
            let finalAmount = max(0, (viewModel.bagDetails?.totalAmount ?? 0) + (totalPrice))
            totalAmountLabel.text = formatPrice(finalAmount)
            finalPriceLabel.text = formatPrice(finalAmount)
            let actualPriceWithputDiscount = max(0, (viewModel.bagDetails?.totalMrp ?? 0) + (totalPrice))
            CommonUtils.setStrikethrough(label: actualPriceLAbel, text: formatPrice(actualPriceWithputDiscount))
        }
    }
    
    @IBAction func deliveryAddressAction(_ sender: Any) {
        let nextVC = SavedAddressViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.comingFromBag = true
        nextVC.onAddressSelected = { [weak self] selectedAddress in
            self?.deliveryId = selectedAddress.id ?? 0
            self?.addressLabel.text = self?.formattedAddress(from: selectedAddress)
        }
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @IBAction func placeOrderDidTapped(_ sender: Any) {
        viewModel.placeOrderApi()
    }
    
    func condifData(data: MyCartDetailsDataModel) {
        totalMRPDiscountValue = data.discountOnMrp ?? 0.0
        totalMRP.text = formatPrice(data.totalMrp)
        dricountOnMRP.text = formatPrice(data.discountOnMrp)
        
        // FIX: Only use API value when promo NOT applied
        if isPromoCodeApplied, let selected = selectedPromoCode {
            couponDidcountLabel.text = formatPrice(selected.applyDiscountValue)
            finalPriceLabel.text = formatPrice(selected.finalAmount)
            totalAmountLabel.text = formatPrice(selected.finalAmount)
            if isAnyItemRemovedFromCart {
                let finalAmount = max(0, (data.totalAmount ?? 0) - (selected.applyDiscountValue ?? 0))
                finalPriceLabel.text = formatPrice(finalAmount)
                totalAmountLabel.text = formatPrice(finalAmount)
                isAnyItemRemovedFromCart = false
            }
        } else {
            couponDidcountLabel.text = formatPrice(data.discountCoupon)
            finalPriceLabel.text = formatPrice(data.totalAmount)
            totalAmountLabel.text = formatPrice(data.totalAmount)
            let savingAmount = (data.discountOnMrp ?? 0)// - (data.totalAmount ?? 0)
            saveAmountLAbel.text = "You will save \(formatPrice(savingAmount)) on this"
        }
        let selectedAddress = data.userAddress
        deliveryId = selectedAddress?.id ?? 0
        addressLabel.text = formattedAddress(from: data.userAddress)//addressLine
        shippingFeeLabel.text = CommonUtils.formatDeliveryCharges(data.shippingFees)//formatPrice(data.shippingFees)
        taxLabel.text = formatPrice(data.tax)//CommonUtils.formatTax(data.tax)//
        totalAmount = data.totalAmount ?? 0
        CommonUtils.setStrikethrough(label: actualPriceLAbel, text: formatPrice(data.totalMrp))
        let customOrderCount = viewModel.customOrders.count
        if customOrderCount != 0 {
            customPriceStackView.isHidden = false
            let totalPrice = viewModel.customOrders
                .compactMap { $0.chatroomData?.totalAmount }
                .compactMap { amount -> Double? in
                    let cleaned = amount
                        .replacingOccurrences(of: ",", with: "") // remove thousand separators
                        .filter { "0123456789.".contains($0) }
                    
                    return Double(cleaned)
                }
                .reduce(0.0, +)
            customOrderPriceLabel.text = CommonUtils.formatPrice(Double(totalPrice))
            
        } else {
            customPriceStackView.isHidden = true
        }
        let normalOrderCount = viewModel.normalOrders.count
        if normalOrderCount != 0 {
            totalMRPStackView.isHidden = false
            discountOnMrpStackView.isHidden = false
            saveAmountLAbel.isHidden = false
            actualPriceLAbel.isHidden = false
        } else {
            totalMRPStackView.isHidden = true
            discountOnMrpStackView.isHidden = true
            saveAmountLAbel.isHidden = true
            let totalPrice = viewModel.customOrders
                .compactMap { $0.chatroomData?.totalAmount }
                .compactMap { amount -> Double? in
                    let cleaned = amount
                        .replacingOccurrences(of: ",", with: "") // remove thousand separators
                        .filter { "0123456789.".contains($0) }
                    
                    return Double(cleaned)
                }
                .reduce(0.0, +)
            let finalAmountForCustomOrderOnly = max(0, (totalPrice) + (data.shippingFees ?? 0) + (data.tax ?? 0))
            totalAmountLabel.text = formatPrice(finalAmountForCustomOrderOnly)
            finalPriceLabel.text = formatPrice(finalAmountForCustomOrderOnly)
            if isPromoCodeApplied, let selected = selectedPromoCode {
                actualPriceLAbel.isHidden = false
                let finalAmountForCustomOrderOnlyAfterApplyingPromo = max(0, (totalPrice) + (data.shippingFees ?? 0) + (data.tax ?? 0) - (selected.applyDiscountValue ?? 0))
                totalAmountLabel.text = formatPrice(finalAmountForCustomOrderOnlyAfterApplyingPromo)
                finalPriceLabel.text = formatPrice(finalAmountForCustomOrderOnlyAfterApplyingPromo)
                CommonUtils.setStrikethrough(label: actualPriceLAbel, text: formatPrice(finalAmountForCustomOrderOnly))
            } else {
                actualPriceLAbel.isHidden = true
            }
        }
        
        if normalOrderCount != 0 && customOrderCount != 0 {
            let totalPrice = viewModel.customOrders.compactMap { $0.chatroomData?.totalAmount }.compactMap { amount -> Double? in
                let cleaned = amount
                    .replacingOccurrences(of: ",", with: "") // remove thousand separators
                    .filter { "0123456789.".contains($0) }
                
                return Double(cleaned)
            }
                .reduce(0.0, +)
            let finalAmount = max(0, (data.totalAmount ?? 0) + (totalPrice))
            totalAmountLabel.text = formatPrice(finalAmount)
            finalPriceLabel.text = formatPrice(finalAmount)
            let actualPriceWithputDiscount = max(0, (data.totalMrp ?? 0) + (totalPrice))
            CommonUtils.setStrikethrough(label: actualPriceLAbel, text: formatPrice(actualPriceWithputDiscount))
            if isPromoCodeApplied, let selected = selectedPromoCode {
                let finalAmountAfterApplyingPromocode = max(0, (finalAmount) - (selected.applyDiscountValue ?? 0))
                totalAmountLabel.text = formatPrice(finalAmountAfterApplyingPromocode)
                finalPriceLabel.text = formatPrice(finalAmountAfterApplyingPromocode)
            }
        }
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
    
    func formattedAddress(from address: SavedAddressList?) -> String {
        guard let address else { return "" }
        
        let nameAndHouse = [
            address.name,
            address.houseNo
        ].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "-")
        
        let mainParts = [
            nameAndHouse,
            address.streetNo,
            address.city,
            address.state,
            address.countryName
        ].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var result = mainParts.joined(separator: ", ")
        
        if let postalCode = address.postalCode,
           !postalCode.trimmingCharacters(in: .whitespaces).isEmpty {
            result += " - \(postalCode)"
        }
        
        return result
    }
    
    private func guestLoginUIHandle() {
        noDataFoundLabel.isHidden = false
        noDataFoundLabel.text = "Please login to view your bag"
        bagDetailsView.isHidden = true
        totoalAmountPriceView.isHidden = true
    }
    
}

// MARK: - TABLE VIEW METHODS
extension MyBagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bagTableView {
            return viewModel.normalOrders.count
        } else  {
            return viewModel.customOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bagTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBagTableViewCell", for: indexPath) as! MyBagTableViewCell
            cell.configData(data: viewModel.normalOrders[indexPath.row])
            let totalItems = viewModel.normalOrders.count
            let isLastIndex = indexPath.row == totalItems - 1
            if isLastIndex {
                cell.shopMoreButtonOutlet.isHidden = false
                cell.borderLabel.isHidden = true
            } else {
                cell.shopMoreButtonOutlet.isHidden = true
                cell.borderLabel.isHidden = false
            }
            let cartItem = viewModel.normalOrders[indexPath.row]
            cell.onIncrement = { [weak self] in
                guard let cartID = cartItem.id else { return }
                self?.viewModel.handleIncrementDecrement(cartID: cartID, type: "increment", index: indexPath.row)
            }
            cell.onDecrement = { [weak self] in
                guard let cartID = cartItem.id else { return }
                self?.viewModel.handleIncrementDecrement(cartID: cartID, type: "decrement", index: indexPath.row)
            }
            return cell
        } else {
            let customOrderCell = tableView.dequeueReusableCell(withIdentifier: "MyBagForCustomOrderTableViewCell", for: indexPath) as! MyBagForCustomOrderTableViewCell
            let totalItems = viewModel.customOrders.count
            let isLastIndex = indexPath.row == totalItems - 1
            if isLastIndex {
                customOrderCell.borderLabel.isHidden = true
            } else {
                customOrderCell.borderLabel.isHidden = false
            }
            customOrderCell.configData(data: viewModel.customOrders[indexPath.row])
            customOrderCell.onCustomDetailsTap = { [weak self] in
                let nextVC = CustomOrderDetailsViewController.instantiate(fromAppStoryboard: .MyOrder)
                nextVC.customDetails = self?.viewModel.customOrders[indexPath.row].chatroomData?.customDetails
                self?.navigationController?.present(nextVC, animated: true)
            }
            customOrderCell.onRemoveTap = { [weak self] in
                self?.viewModel.removeCustomOrderFromCartSerivice(id: self?.viewModel.customOrders[indexPath.row].id ?? 0)
            }
            return customOrderCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
        if tableView == bagTableView {
            nextVC.productId = viewModel.normalOrders[indexPath.row].productID
        } else {
            nextVC.productId = viewModel.customOrders[indexPath.row].productID
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}
