//
//  MyOrderDetailVC.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit
import SDWebImage
import Cosmos

class MyOrderDetailVC: UIViewController {
    
    @IBOutlet weak var discountOnMRPView: UIView!
    @IBOutlet weak var customOrderItemPriceLabel: CustomLabelFont!
    @IBOutlet weak var itemPriceLabelForCustomOrder: CustomLabelFont!
    @IBOutlet weak var totalMRPView: UIView!
    @IBOutlet weak var customItemAndQuanoitytPriceView: UIView!
    @IBOutlet weak var customOrderDetailsstackView: UIView!
    @IBOutlet weak var customOrderRquestView: UIView!
    @IBOutlet weak var customOrderRequestIdLabel: CustomLabelFont!
    @IBOutlet weak var quantityLAbel: UILabel!
    @IBOutlet weak var customDetailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var returnDateLabel: CustomLabelFont!
    @IBOutlet weak var returnIdLabel: CustomLabelFont!
    @IBOutlet weak var exchangeDateLabel: CustomLabelFont!
    @IBOutlet weak var exchangeIdLabel: CustomLabelFont!
    @IBOutlet weak var cancellationDateLabel: CustomLabelFont!
    @IBOutlet weak var cancellationIDLabel: CustomLabelFont!
    @IBOutlet weak var reasonLabel: CustomLabelFont!
    @IBOutlet weak var exchangeReturnHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var exchangeProductButtonOutlet: UIButton!
    @IBOutlet weak var returnProductButtonOutlet: UIButton!
    @IBOutlet weak var exchangeReturnDescriptionLabel: CustomLabelFont!
    @IBOutlet weak var exchangeReturnDescriptionView: CustomView!
    @IBOutlet weak var rateThisProductButtonOutlet: UIButton!
    @IBOutlet weak var lblOrderId: CustomLabelFont!
    @IBOutlet weak var lblPlacedDate: CustomLabelFont!
    @IBOutlet weak var viewStatus: CustomView!
    @IBOutlet weak var lblStatus: CustomLabelFont!
    @IBOutlet weak var lblTotalMrp: CustomLabelFont!
    @IBOutlet weak var lblDiscountMrp: CustomLabelFont!
    @IBOutlet weak var lblCouponDis: CustomLabelFont!
    @IBOutlet weak var lblShippingFee: CustomLabelFont!
    @IBOutlet weak var lblTax: CustomLabelFont!
    @IBOutlet weak var lblTotalAmount: CustomLabelFont!
    @IBOutlet weak var lblSavedAmount: CustomLabelFont!
    @IBOutlet weak var lblDeliveryInst: CustomLabelFont!
    @IBOutlet weak var lblDeliveredOn: CustomLabelFont!
    @IBOutlet weak var imgConfirm: UIImageView!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var imgShip: UIImageView!
    @IBOutlet weak var lblShip: UILabel!
    @IBOutlet weak var imgWay: UIImageView!
    @IBOutlet weak var lblWay: UILabel!
    @IBOutlet weak var imgDelivered: UIImageView!
    @IBOutlet weak var lblDelivered: UILabel!
    @IBOutlet weak var lblShippingAdd: CustomLabelFont!
    @IBOutlet weak var lblTransactionId: CustomLabelFont!
    @IBOutlet weak var lblPaidByCardAmount: CustomLabelFont!
    @IBOutlet weak var lblPaidByCard: CustomLabelFont!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var viewItemPrice: UIView!
    @IBOutlet weak var orderTableView: TableViewDynamicHeight! {
        didSet {
            orderTableView.registerCellFromNib(cellID: "OrderDetailTableCell")
        }
    }
    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var lblProductName: CustomLabelFont!
    @IBOutlet weak var lblSize: CustomLabelFont!
    @IBOutlet weak var lblDisPrice: CustomLabelFont!
    @IBOutlet weak var lblPrice: CustomLabelFont!
    @IBOutlet weak var lblReturnAvail: CustomLabelFont!
    @IBOutlet weak var viewReturnDays: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var viewReturnEx: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var lblTotalQuantity: CustomLabelFont!
    @IBOutlet weak var lblAddress: CustomLabelFont!
    @IBOutlet weak var lblDetails: CustomLabelFont!
    @IBOutlet weak var viewReturnDetail: UIView!
    @IBOutlet weak var viewCancelDetail: UIView!
    @IBOutlet weak var viewExchangeDetail: UIView!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var viewRetExSize: UIView!
    @IBOutlet weak var lblExSize: CustomLabelFont!
    @IBOutlet weak var imgProfile: CustomImageView!
    @IBOutlet weak var viewPaidBy: UIView!
    @IBOutlet weak var viewDownloadInvoice: UIView!
    @IBOutlet weak var viewCancelBtn: UIView!
    @IBOutlet weak var viewUploadImg: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var showRatingView: CosmosView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var rateThisProductLabel: CustomLabelFont!
    @IBOutlet weak var anotherOrdersView: CustomView!
    @IBOutlet weak var allOrdersLabel: CustomLabelFont!
    @IBOutlet weak var extraSpaceLabel: UILabel!
    @IBOutlet weak var couponDiscountView: UIView!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    
    lazy private var viewModel = MyOrderDetailVM(hostVC: self)
    var orderData: OrderModel?
    var isCustomOrder: Bool = false
    var orderId: Int?
    var orderDetailId: Int?
//    var selectedPromoCode: PromocodeApplied?
    lazy var stepImages: [StepImage] = [
        StepImage(selected: "confirmedOrder", unselected: "confirmedOrder"),
        StepImage(selected: "shippedDone", unselected: "shipped"),
        StepImage(selected: "ontheWayDone", unselected: "ontheWay"),
        StepImage(selected: "deliveredDone", unselected: "delivered"),
    ]
    var totalPaidAmount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRatingView.settings.fillMode = .full
        viewModel.getOrderDetail()
        viewItemPrice.isHidden = true
        if isCustomOrder {
            customOrderRquestView.isHidden = false
            customOrderDetailsstackView.isHidden = false
            customItemAndQuanoitytPriceView.isHidden = false
            totalMRPView.isHidden = true
            discountOnMRPView.isHidden = true
            lblSavedAmount.isHidden = true
        } else{
            customOrderRquestView.isHidden = true
            customOrderDetailsstackView.isHidden = true
            customItemAndQuanoitytPriceView.isHidden = true
            totalMRPView.isHidden = false
            discountOnMRPView.isHidden = false
            lblSavedAmount.isHidden = false
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDownloadInvoice(_ sender: Any) {
        let orderId = orderData?.order?.orderID ?? ""
        let urlString = "http://157.241.119.72/Invoice/\(orderId)"
        guard let url = URL(string: urlString) else {
            showAlert(msg: "Invalid invoice URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func rateThisProductDidTapped(_ sender: Any) {
        let vc = RateProductOrderViewController.instantiate(fromAppStoryboard: .MyOrder)
        vc.orderId = self.orderId
        vc.orderDetailId = self.orderDetailId
        vc.ratingDone = { [weak self] in
            self?.viewModel.getOrderDetail()
        }
        navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnCancelOrder(_ sender: Any) {
        let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.screenType = .cancelOrder
        vc.orderId = orderId ?? 0
        vc.orderDetailId = orderDetailId ?? 0
        vc.delegate = self
        vc.onCancel = {
            let vc = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
            vc.message = "Order Cancelled successfully!"
            self.dismiss(animated: true) {
                self.navigationController?.present(vc, animated: true)
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.screenType = .cancelOrder
        vc.orderId = orderId ?? 0
        vc.orderDetailId = orderDetailId ?? 0
        vc.delegate = self
        vc.onCancel = {
            let vc = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
            vc.message = "Order Cancelled successfully!"
            self.dismiss(animated: true) {
                self.navigationController?.present(vc, animated: true)
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnExchangee(_ sender: Any) {
        let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.screenType = .exchangePro
        vc.orderId = orderId ?? 0
        vc.orderDetailId = orderDetailId ?? 0
        vc.delegate = self
        vc.onExchange = { [weak self] in
            self?.viewModel.getOrderDetail()
        }
        
        navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnReturnn(_ sender: Any) {
        let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.screenType = .returnPro
        vc.orderId = orderId ?? 0
        vc.orderDetailId = orderDetailId ?? 0
        vc.delegate = self
        vc.onReturn = { [weak self] in
            self?.viewModel.getOrderDetail()
        }
        navigationController?.present(vc, animated: true)
    }
    
    private func resetStepper() {
        let inactiveColor = UIColor.lightGray
        let labels = [lbl1, lbl2, lbl3, lbl4]
        let images = [img1, img2, img3, img4]
        for i in 0..<labels.count {
            labels[i]?.textColor = inactiveColor
            images[i]?.image = UIImage(named: stepImages[i].unselected)
        }
    }
    
    private func activateStep(_ index: Int, title: String) {
        let labels = [lbl1, lbl2, lbl3, lbl4]
        let images = [img1, img2, img3, img4]
        
        labels[index]?.text = title
        labels[index]?.textColor = UIColor(hexString: "#6E4527")
        images[index]?.image = UIImage(named: stepImages[index].selected)
    }
    
    private func hideStep(_ index: Int) {
        let labels = [lbl1, lbl2, lbl3, lbl4]
        let images = [img1, img2, img3, img4]
        
        labels[index]?.isHidden = true
        images[index]?.isHidden = true
    }
    
    func setData() {
        guard let data = orderData else { return }
        //CommonUtils.updateDiscountPercentageLabel(discountPercentageLabel, actualAmountLabel: lblPrice,discountType: data.variationDetails?.discountType,discountValue: data.variationDetails?.discountValue)
        lblOrderId.text = "#\(data.id ?? 0)"
        customOrderRequestIdLabel.text = "Request id #\(data.id ?? 0)"
        lblPlacedDate.text = "Placed on \(data.createdAt?.formattedPlacedDate() ?? "")"
        quantityLAbel.text = data.quantity?.description
        let unitPrice = Double(data.amount ?? "") ?? 0
        let quantity = data.quantity ?? 1
        let totalPriceforCustom = unitPrice * Double(quantity)

        itemPriceLabelForCustomOrder.text = "Custom Items Price"
        
        lblTotalMrp.text = CommonUtils.formatPriceStringInput(data.order?.totalMrp, currency: "KD")
        
        customOrderItemPriceLabel.text = CommonUtils.formatPrice(Double(totalPriceforCustom))
        lblDiscountMrp.text = CommonUtils.formatPrice(Double(data.order?.discountMrp ?? "0"))
        lblShippingFee.text = CommonUtils.formatDeliveryCharges(Double(data.order?.shippingFees ?? "0"))//"\(data.order?.shippingFees ?? "0") KD"
        lblTax.text = "\(data.order?.tax ?? "0") KD"
        lblTotalAmount.text = CommonUtils.formatPrice(Double(data.order?.totalAmount ?? "0"))
        totalPaidAmount = lblTotalAmount.text
        if isCustomOrder {
            lblDisPrice.text = CommonUtils.formatPriceStringInput(data.chatroomRecordtable?.totalAmount ?? "0")//"Per Item Price \(CommonUtils.formatPrice(Double(unitPrice)))"
            lblPrice.isHidden = true
            discountPercentageLabel.isHidden = true
        } else {
            lblDisPrice.text = CommonUtils.formatPrice(Double(data.variationDetails?.finalPrice ?? "0"))
            lblPrice.isHidden = false
//            discountPercentageLabel.isHidden = false
            CommonUtils.updateDiscountPercentageLabel(discountPercentageLabel, actualAmountLabel: lblPrice,discountType: data.variationDetails?.discountType,discountValue: data.variationDetails?.discountValue)
        }
//        let discountType = data.variationDetails?.discountType ?? "1"
//        if discountType == "1" {
//            discountPercentageLabel.text = "\(data.variationDetails?.discountValue ?? "")% Off"
//        } else {
//            discountPercentageLabel.text = "\(data.variationDetails?.discountValue ?? "") KD Off"
//        }
        
        
        
        let orderProductPrice = CommonUtils.formatPrice(Double(data.variationDetails?.actualPrice ?? "0"))
        CommonUtils.setStrikethrough(label: lblPrice, text: orderProductPrice)
        let isReturnAllowed = data.productDetails?.productReturn == "1"
        if isReturnAllowed {
            lblReturnAvail.text = "\(data.productDetails?.returnDays ?? "1") days return available"
        } else {
            lblReturnAvail.text = "No return available"
        }
        
        if data.order?.promocodeID != nil {
//        if let selected = selectedPromoCode {
            couponDiscountView.isHidden = false
            lblSavedAmount.isHidden = false
            lblCouponDis.text = CommonUtils.formatPriceStringInput(data.order?.promocodeValue ?? "")
//            lblTotalAmount.text = CommonUtils.formatPrice(selected.finalAmount)
//            totalPaidAmount = lblTotalAmount.text
            let discountMrp = Double(data.order?.discountMrp ?? "0") ?? 0.0
            let promoValue = Double(data.order?.promocodeValue ?? "0") ?? 0.0
            let discountValue = discountMrp + promoValue
            lblSavedAmount.text = "You saved \(CommonUtils.formatPrice(discountValue)) on this"
        } else {
            couponDiscountView.isHidden = true
            lblSavedAmount.text = "You saved \(CommonUtils.formatPriceStringInput(data.order?.discountMrp ?? "0")) on this"
//            lblTotalAmount.text = CommonUtils.formatPrice(Double(data.order?.totalAmount ?? "0"))
//            let savingAmount = Double(data.order?.discountMrp ?? "0")
//            totalPaidAmount = lblTotalAmount.text
//            lblSavedAmount.text = "You saved \(CommonUtils.formatPrice(savingAmount)) on this"
        }
        
        let selectedAddress = data.order?.deliveryDetails
        let addressLine = "\(selectedAddress?.name ?? "")-\(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
        lblShippingAdd.text = addressLine
        addressLabel.text = addressLine
        customDetailLabel.text = data.chatroomRecordtable?.customDetails
        let img = data.variationDetails?.variantImage
        if let imageUrl = img?.first, let url = URL(string: imageUrl) {
            imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgProduct.sd_imageIndicator?.startAnimatingIndicator()
            imgProduct.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            imgProduct.image = UIImage(named: "")
        }
        
        if let returnImg = data.returnImage?.first, let returnImgUrl = URL(string: returnImg) {
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgProfile.sd_imageIndicator?.startAnimatingIndicator()
            imgProfile.sd_setImage(with: returnImgUrl, placeholderImage: UIImage(named: ""))
        } else {
            imgProfile.image = UIImage(named: "")
        }
        
        lblProductName.text = data.productDetails?.productNameEn ?? ""
        if isCustomOrder {
            setColorBoxWithQuanityInView(size: data.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data.variationDetails?.color?.hexCode ?? "#98ADFF")
        } else {
            setColorBox(size: data.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data.quantity ?? 0)")
        }
        configureStatus(with: data)
        
        lblPaidByCardAmount.text = totalPaidAmount
        reasonLabel.text = data.returnReason ?? data.exchangeReason ?? data.cancelReason ?? data.notDeliveredReason
        returnIdLabel.text = "#\(data.orderID ?? 0)"
        cancellationIDLabel.text = "#\(data.orderID ?? 0)"
        exchangeIdLabel.text = "#\(data.orderID ?? 0)"
        
        returnDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
        cancellationDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
        exchangeDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
        let otherOrdersCount = data.allOtherOrderVarient?.count ?? 0
        if otherOrdersCount == 0 {
            anotherOrdersView.isHidden = true
            allOrdersLabel.isHidden = true
            extraSpaceLabel.isHidden = true
        } else {
            anotherOrdersView.isHidden = false
            allOrdersLabel.isHidden = false
            extraSpaceLabel.isHidden = false
        }
        orderTableView.reloadData()
        if isCustomOrder {
            lblTotalAmount.text = CommonUtils.formatPrice(Double(data.order?.totalAmount ?? "0"))
        }
        
        let otherVarientOrders = data.allOtherOrderVarient ?? []
        let customOrderType = otherVarientOrders.filter { $0.orderType == "2" }
        if customOrderType.count > 0 {
            customItemAndQuanoitytPriceView.isHidden = false
            let totalPrice = customOrderType
                .compactMap { $0.chatroomRecordtable?.totalAmount }
                .compactMap { amount -> Double? in
                    let cleaned = amount
                        .replacingOccurrences(of: ",", with: "") // remove thousand separators
                        .filter { "0123456789.".contains($0) }

                    return Double(cleaned)
                }
                .reduce(0.0, +)
            let mainOrderDetailsCustomPrice = (Double(data.chatroomRecordtable?.totalAmount ?? "0") ?? 0) + totalPrice
            customOrderItemPriceLabel.text = CommonUtils.formatPrice(Double(mainOrderDetailsCustomPrice))
        }
        
        let normalOrderType = otherVarientOrders.filter { $0.orderType == "1" }
        if normalOrderType.count > 0 {
            totalMRPView.isHidden = false
            discountOnMRPView.isHidden = false
            lblSavedAmount.isHidden = false
        }
    }
    
    private func configureStatus(with data: OrderModel) {
        resetStepper()
        lblStatus.text = "Ongoing"
        lblStatus.textColor = UIColor(hexString: "#FF5F1B")
        viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
        viewReturnDays.isHidden = true
        viewCancel.isHidden = true
        viewRate.isHidden = true
        viewReturnEx.isHidden = true
        
        viewReturnDetail.isHidden = true
        viewExchangeDetail.isHidden = true
        viewCancelDetail.isHidden = true
        viewReason.isHidden = true
        viewRetExSize.isHidden = true
        viewUploadImg.isHidden = true
        viewPaidBy.isHidden = true
        viewDownloadInvoice.isHidden = true
        viewCancelBtn.isHidden = true
        lblReturnAvail.isHidden = false
        let paymentMethod = data.order?.paymentMethod
        let paymentStatus = data.paymentStatus
        let deliveryStatus = data.deliveryStatus
        
        if paymentMethod == "1" || paymentMethod == "2" {
            if paymentMethod == "1" {
                lblPaidByCard.text = "Online"
                lblTransactionId.isHidden = false
                lblTransactionId.text = data.order?.transactionID
            } else if paymentMethod == "2" {
                lblTransactionId.isHidden = true
                lblPaidByCard.text = "Wallet"
            }
            if paymentStatus == "1" {
                switch deliveryStatus {
                case "0":
                    if data.returnType == "1" {
                        viewReturnEx.isHidden = true
                        if data.rEApprove == "1" {
                            lblStatus.text = "Return Accepted"
                            lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                            viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                            viewReturnEx.isHidden = true
                            resetStepper()
                            activateStep(0, title: "Confirmed")
                            activateStep(1, title: "In Progress")
                            lbl3.text = "Picked Up"
                            lbl4.text = "Completed"
                            if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 6) {
                                lblDeliveredOn.text = "Pickup Date : \(isoDate)"
                            } else {
                                lblDeliveredOn.text = "Pickup Date : -"
                            }
                            lblPlacedDate.text = "Return request \(data.updatedAt?.formattedPlacedDate() ?? "")"
                            let returnImgeUpload = data.returnImage?.first ?? ""
                            if returnImgeUpload.isEmpty {
                                viewUploadImg.isHidden = true
                            } else {
                                viewUploadImg.isHidden = false
                            }
                        }
                    }
                    
                    
                case "1": //Pending
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                    
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                        viewReturnDays.isHidden = true
                    } else {
                        viewCancel.isHidden = false
                        viewReturnDays.isHidden = false
                    }
                    viewPaidBy.isHidden = false
                    activateStep(0, title: "Confirmed")
                    
                case "2": //Ongoing
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                    
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                        viewReturnDays.isHidden = true
                    } else {
                        viewCancel.isHidden = false
                        viewReturnDays.isHidden = false
                    }
                    viewPaidBy.isHidden = false
                    activateStep(0, title: "Confirmed")
                case "2.1":
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                    } else {
                        viewCancel.isHidden = false
                    }
                    viewPaidBy.isHidden = false
                    activateStep(0, title: "Confirmed")
                    activateStep(1, title: "Shipped")
                    
                case "3": //Delivered
                    lblStatus.text = "Delivered"
                    lblStatus.textColor = UIColor(hexString: "#16B364")
                    viewStatus.borderColor = UIColor(hexString: "#16B364")
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    viewRate.isHidden = false
                    
                    viewReturnEx.isHidden = isCustomOrder//false
                    viewPaidBy.isHidden = false
                    viewDownloadInvoice.isHidden = false
                    activateStep(0, title: "Confirmed")
                    activateStep(1, title: "Shipped")
                    activateStep(2, title: "On the Way")
                    activateStep(3, title: "Delivered")
                    handleReturnExchange(data: data)
                    if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                        lblDeliveredOn.text = "Delivered On : \(isoDate)"
                    } else {
                        lblDeliveredOn.text = "Delivered On : -"
                    }
                    if data.returnType == "1" || data.returnType == "2" { //Return Request
                        if data.returnType == "1" {
                            lblStatus.text = "Return Request"
                        } else if data.returnType == "2"{
                            lblStatus.text = "Exchange Request"
                        }
                        lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                        viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                        viewReturnEx.isHidden = true
                        resetStepper()
                        img1.image = .unconfiremdOrder
                        img2.image = .shipped
                        lbl3.text = "Picked Up"
                        lbl4.text = "Completed"
                        if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 6) {
                            lblDeliveredOn.text = "Pickup Date : \(isoDate)"
                        } else {
                            lblDeliveredOn.text = "Pickup Date : -"
                        }
                        
                        let returnImgeUpload = data.returnImage?.first ?? ""
                        if returnImgeUpload.isEmpty {
                            viewUploadImg.isHidden = true
                        } else {
                            viewUploadImg.isHidden = false
                        }
                        lblPlacedDate.text = "Return request \(data.updatedAt?.formattedPlacedDate() ?? "")"
                        if data.rEApprove == "1" {
                            //                            lblStatus.text = "Return Request"
                            if data.returnType == "1" {
                                lblStatus.text = "Returned"//"Return Request"
                                activateStep(0, title: "Confirmed")
                                activateStep(1, title: "Shipped")
                                activateStep(2, title: "Picked up")
                                activateStep(3, title: "Completed")
                                lblStatus.textColor = UIColor(hexString: "#16B364")
                                viewStatus.borderColor = UIColor(hexString: "#16B364")
                            } else if data.returnType == "2"{
                                lblStatus.text = "Exchange Request"
                                activateStep(0, title: "Confirmed")
                                activateStep(1, title: "In Progress")
                                lbl3.text = "Picked &\nexchange"
                                lbl4.text = "Completed"
                                if data.isPicked == "1" {
                                    activateStep(2, title: "Picked &\nexchange")
                                    let exchangeOrderDetails = data.exchangeOrderDetails?.deliveryStatus ?? "0"
                                    if exchangeOrderDetails == "3" {
                                        activateStep(3, title: "Completed")
                                        lblStatus.text = "Delivered"
                                        lblStatus.textColor = UIColor(hexString: "#16B364")
                                        viewStatus.borderColor = UIColor(hexString: "#16B364")
                                    }
                                }
                            }
                            //                            lbl4.text = "Completed"
                        } else if data.rEApprove == "2" {
                            lblStatus.text = "Delivered"//"Return Request"
                            activateStep(0, title: "Confirmed")
                            activateStep(1, title: "Shipped")
                            activateStep(2, title: "On the way")
                            activateStep(3, title: "Delivered") //
                            viewReturnEx.isHidden = false
                        }
                    }
                    
                case "4": //Cancelled
                    lblStatus.text = "Cancelled"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewStatus.borderColor = UIColor(hexString: "#E70000")
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                    } else {
                        viewCancel.isHidden = false
                    }
                    viewReason.isHidden = false
                    viewPaidBy.isHidden = false
                    hideStep(2)
                    hideStep(1)
                    activateStep(0, title: "Confirmed")
                    activateStep(3, title: "Cancelled")
                    img4.image = UIImage(named: "canclledOrdreRed")
                    lbl4.textColor = UIColor(hexString: "#D72E04")
                    if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                        lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
                    } else {
                        lblDeliveredOn.text = "Cancelled Date : -"
                    }
                    lblReturnAvail.isHidden = true
                    
                case "7": //Picked
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewStatus.borderColor = UIColor(hexString: "#E70000")
                    viewCancelDetail.isHidden = true
                    viewReason.isHidden = true
                    viewPaidBy.isHidden = false
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    activateStep(0, title: "Confirmed")
                    activateStep(1, title: "Shipped")
                    activateStep(2, title: "On the Way")
                    let returnType = data.returnType ?? "0"
                    
                    if returnType == "1" || returnType == "2" {
                        if data.isPicked == "1" {
                            lblStatus.text = "Return Req."
                            activateStep(1, title: "Shipped")
                            activateStep(2, title: "Picked up")
                            lbl4.text = "Completed"
                        }
                    }
                    
                case "8": //Cancelled
                    lblStatus.text = "Cancelled"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewStatus.borderColor = UIColor(hexString: "#E70000")
                    viewCancelDetail.isHidden = false
                    reasonLabel.text = data.notDeliveredReason
                    viewReason.isHidden = false
                    viewPaidBy.isHidden = false
                    hideStep(2)
                    hideStep(1)
                    activateStep(0, title: "Confirmed")
                    activateStep(3, title: "Cancelled")
                    img4.image = UIImage(named: "canclledOrdreRed")
                    lbl4.textColor = UIColor(hexString: "#D72E04")
                    if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                        lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
                    } else {
                        lblDeliveredOn.text = "Cancelled Date : -"
                    }
                    lblReturnAvail.isHidden = true
                default:
                    return
                }
            } else if paymentStatus == "3" {
                lblStatus.text = "Cancelled"
                lblStatus.textColor = UIColor(hexString: "#E70000")
                viewStatus.borderColor = UIColor(hexString: "#E70000")
                viewCancelDetail.isHidden = false
                viewReason.isHidden = false
                viewPaidBy.isHidden = false
                hideStep(2)
                hideStep(1)
                activateStep(0, title: "Confirmed")
                activateStep(3, title: "Cancelled")
                img4.image = UIImage(named: "canclledOrdreRed")
                lbl4.textColor = UIColor(hexString: "#D72E04")
                if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                    lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
                } else {
                    lblDeliveredOn.text = "Cancelled Date : -"
                }
                lblReturnAvail.isHidden = true
            }
            
        } else if paymentMethod == "3" {
            if paymentStatus == "0" || paymentStatus == "1" {
                switch deliveryStatus {
                case "0":
                    if data.returnType == "1" {
                        viewReturnEx.isHidden = true
                        if data.rEApprove == "1" {
                            lblStatus.text = "Return Accepted"
                            lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                            viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                            viewReturnEx.isHidden = true
                            resetStepper()
                            activateStep(0, title: "Confirmed")
                            activateStep(1, title: "In Progress")
                            lbl3.text = "Picked Up"
                            lbl4.text = "Completed"
                            if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 6) {
                                lblDeliveredOn.text = "Pickup Date : \(isoDate)"
                            } else {
                                lblDeliveredOn.text = "Pickup Date : -"
                            }
                            lblPlacedDate.text = "Return request \(data.updatedAt?.formattedPlacedDate() ?? "")"
                            let returnImgeUpload = data.returnImage?.first ?? ""
                            if returnImgeUpload.isEmpty {
                                viewUploadImg.isHidden = true
                            } else {
                                viewUploadImg.isHidden = false
                            }
                        }
                    }
                    
                case "1": //Pending
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                    } else {
                        viewCancel.isHidden = false
                    }
                    viewPaidBy.isHidden = false
                    activateStep(0, title: "Confirmed")
                    let returnType = data.returnType ?? "1"
                    if returnType == "1" || returnType == "2" {
                        let approveType = data.rEApprove ?? "1"
                        if approveType == "1" {
                            lblStatus.text = "Return Req."
                            activateStep(1, title: "In Progress")
                            lbl3.text = "Picked up"
                            lbl4.text = "Completed"
                        }
                    }
                    
                case "2": //Ongoing
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                    } else {
                        viewCancel.isHidden = false
                    }
                    viewPaidBy.isHidden = false
                    activateStep(0, title: "Confirmed")
                    
                case "2.1":
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                    viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                    if isCustomOrder {
                        let canCancel = CommonUtils.isWithinThreeHours(from: data.createdAt ?? "")
                        viewCancel.isHidden = !canCancel
                        viewReturnDays.isHidden = true
                    } else {
                        viewCancel.isHidden = false
                        viewReturnDays.isHidden = false
                    }
                    viewPaidBy.isHidden = false
                    activateStep(0, title: "Confirmed")
                    activateStep(1, title: "Shipped")
                    
                case "3": //Delivered
                    lblStatus.text = "Delivered"
                    lblStatus.textColor = UIColor(hexString: "#16B364")
                    viewStatus.borderColor = UIColor(hexString: "#16B364")
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    viewRate.isHidden = false
                    viewReturnEx.isHidden = isCustomOrder//false
                    viewPaidBy.isHidden = false
                    viewDownloadInvoice.isHidden = false
                    viewCancelDetail.isHidden = true
                    activateStep(0, title: "Confirmed")
                    activateStep(1, title: "Shipped")
                    activateStep(2, title: "On the Way")
                    activateStep(3, title: "Delivered")
                    handleReturnExchange(data: data)
                    if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                        lblDeliveredOn.text = "Delivered On : \(isoDate)"
                    } else {
                        lblDeliveredOn.text = "Delivered On : -"
                    }
                    if data.returnType == "1" || data.returnType == "2"{ //Return Request
                        if data.returnType == "1" {
                            lblStatus.text = "Return Request"
                        } else if data.returnType == "2"{
                            lblStatus.text = "Exchange Request"
                        }
                        
                        lblStatus.textColor = UIColor(hexString: "#FF5F1B")
                        viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
                        viewReturnEx.isHidden = true
                        resetStepper()
                        img1.image = .unconfiremdOrder
                        img2.image = .shipped
                        lbl3.text = "Picked Up"
                        lbl4.text = "Completed"
                        if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 6) {
                            lblDeliveredOn.text = "Pickup Date : \(isoDate)"
                        } else {
                            lblDeliveredOn.text = "Pickup Date : -"
                        }
                        lblPlacedDate.text = "Return request \(data.updatedAt?.formattedPlacedDate() ?? "")"
                        let returnImgeUpload = data.returnImage?.first ?? ""
                        if returnImgeUpload.isEmpty {
                            viewUploadImg.isHidden = true
                        } else {
                            viewUploadImg.isHidden = false
                        }
                        if data.rEApprove == "1" {
                            if data.returnType == "1" {
                                lblStatus.text = "Returned"
                                activateStep(0, title: "Confirmed")
                                activateStep(1, title: "Shipped")
                                activateStep(2, title: "Picked up")
                                activateStep(3, title: "Completed")
                                lblStatus.textColor = UIColor(hexString: "#16B364")
                                viewStatus.borderColor = UIColor(hexString: "#16B364")
                            } else if data.returnType == "2"{
                                lblStatus.text = "Exchange Request"
                                activateStep(0, title: "Confirmed")
                                activateStep(1, title: "In Progress")
                                lbl3.text = "Picked &\nexchange"
                                lbl4.text = "Completed"
                                if data.isPicked == "1" {
                                    activateStep(2, title: "Picked &\nexchange")
                                    let exchangeOrderDetails = data.exchangeOrderDetails?.deliveryStatus ?? "0"
                                    if exchangeOrderDetails == "3" {
                                        activateStep(3, title: "Completed")
                                        lblStatus.text = "Delivered"
                                    }
                                }
                            }
                        } else if data.rEApprove == "2" {
                            lblStatus.text = "Delivered"//"Return Request"
                            activateStep(0, title: "Confirmed")
                            activateStep(1, title: "Shipped")
                            activateStep(2, title: "On the way")
                            activateStep(3, title: "Delivered") //
                            viewReturnEx.isHidden = false
                            lblStatus.textColor = UIColor(hexString: "#16B364")
                            viewStatus.borderColor = UIColor(hexString: "#16B364")
                        }
                    }
                    
                case "4": //Cancelled
                    lblStatus.text = "Cancelled"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewStatus.borderColor = UIColor(hexString: "#E70000")
                    viewCancelDetail.isHidden = false
                    viewReason.isHidden = false
                    viewPaidBy.isHidden = false
                    hideStep(2)
                    hideStep(1)
                    activateStep(0, title: "Confirmed")
                    activateStep(3, title: "Cancelled")
                    img4.image = UIImage(named: "canclledOrdreRed")
                    lbl4.textColor = UIColor(hexString: "#D72E04")
                    if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                        lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
                    } else {
                        lblDeliveredOn.text = "Cancelled Date : -"
                    }
                    lblReturnAvail.isHidden = true
                    
                case "7": //Picked
                    lblStatus.text = "Ongoing"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewStatus.borderColor = UIColor(hexString: "#E70000")
                    viewCancelDetail.isHidden = true
                    viewReason.isHidden = true
                    viewPaidBy.isHidden = false
                    if isCustomOrder {
                        viewReturnDays.isHidden = true
                    } else {
                        viewReturnDays.isHidden = false
                    }
                    activateStep(0, title: "Confirmed")
                    activateStep(1, title: "Shipped")
                    activateStep(2, title: "On the Way")
                    let returnType = data.returnType ?? "0"
                    
                    if returnType == "1" || returnType == "2" {
                        if data.isPicked == "1" {
                            lblStatus.text = "Return Req."
                            activateStep(1, title: "Shipped")
                            activateStep(2, title: "Picked up")
                            lbl4.text = "Completed"
                        }
                    }
                    
                case "8": //Cancelled
                    lblStatus.text = "Cancelled"
                    lblStatus.textColor = UIColor(hexString: "#E70000")
                    viewStatus.borderColor = UIColor(hexString: "#E70000")
                    viewCancelDetail.isHidden = false
                    reasonLabel.text = data.order?.notDeliveredReason
                    viewReason.isHidden = false
                    viewPaidBy.isHidden = false
                    hideStep(2)
                    hideStep(1)
                    activateStep(0, title: "Confirmed")
                    activateStep(3, title: "Cancelled")
                    img4.image = UIImage(named: "canclledOrdreRed")
                    lbl4.textColor = UIColor(hexString: "#D72E04")
                    if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                        lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
                    } else {
                        lblDeliveredOn.text = "Cancelled Date : -"
                    }
                    lblReturnAvail.isHidden = true
                default:
                    return
                }
            } else if paymentStatus == "2" {
                lblStatus.text = "Cancelled"
                lblStatus.textColor = UIColor(hexString: "#E70000")
                viewStatus.borderColor = UIColor(hexString: "#E70000")
                viewCancelDetail.isHidden = false
                viewReason.isHidden = false
                viewPaidBy.isHidden = false
                hideStep(2)
                hideStep(1)
                activateStep(0, title: "Confirmed")
                activateStep(3, title: "Cancelled")
                img4.image = UIImage(named: "canclledOrdreRed")
                lbl4.textColor = UIColor(hexString: "#D72E04")
                lblReturnAvail.isHidden = true
                if let isoDate = CommonUtils.isoStringAddingDays(data.updatedAt, days: 0) {
                    lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
                } else {
                    lblDeliveredOn.text = "Cancelled Date : -"
                }
            }
            lblPaidByCard.text = "COD"
            lblTransactionId.isHidden = true
        }
        
    }
    
    private func handleReturnExchange(data: OrderModel) {
        let isReturnAllowed = data.productDetails?.productReturn == "1"
        let isExchangeAllowed = data.productDetails?.productExchangable == "1"
        
        if data.userRatingReviewProvide == nil {
            // Rating NOT given
            showRatingView.rating = 0
            rateThisProductButtonOutlet.isHidden = false
            rateThisProductLabel.isHidden = false
        } else {
            // Rating already given
            rateThisProductButtonOutlet.isHidden = true
            rateThisProductLabel.isHidden = true
            
            let rating = Double(data.userRatingReviewProvide?.productRating ?? "") ?? 0
            showRatingView.rating = rating
        }
        
        returnProductButtonOutlet.isHidden = !isReturnAllowed
        exchangeProductButtonOutlet.isHidden = !isExchangeAllowed
        
        if !isReturnAllowed && !isExchangeAllowed {
            viewReturnEx.isHidden = isCustomOrder//true
            exchangeReturnHeightConstrint.constant = 0
        } else {
            viewReturnEx.isHidden = isCustomOrder//false
            exchangeReturnHeightConstrint.constant = 64
        }
        let returnStatus = data.returnType ?? "0"
        
        switch returnStatus {
        case "1":
            viewReturnEx.isHidden = isCustomOrder//true
            viewReturnDetail.isHidden = false
            viewReason.isHidden = false
        case "2":
            viewReturnEx.isHidden = isCustomOrder//true
            viewExchangeDetail.isHidden = false
            viewReason.isHidden = false
        default:
            viewReturnEx.isHidden = isCustomOrder//false
            exchangeReturnDescriptionView.isHidden = true
            viewReturnDetail.isHidden = true
            viewExchangeDetail.isHidden = true
            viewReason.isHidden = true
        }
        
    }
}

extension MyOrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderData?.allOtherOrderVarient?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell", for: indexPath) as! OrderDetailTableCell
        let data = orderData?.allOtherOrderVarient?[indexPath.row]
        let paymentMethod = orderData?.order?.paymentMethod ?? "1"
        let paymentStatus = data?.paymentStatus ?? "1"
        let deliveryStatus = data?.deliveryStatus ?? "1"
        cell.configData(data: data, paymentMethod: paymentMethod, paymentStatus: paymentStatus, deliveryStatus: deliveryStatus)
        return cell
    }
}

//extension MyOrderDetailVC: UIDocumentInteractionControllerDelegate {
//    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        return self
//    }
//}

extension MyOrderDetailVC: SelectReasonDelegate {
    
    func didUpdateOrder(status: SelectScreenType) {
        viewModel.getOrderDetail()
    }
}

