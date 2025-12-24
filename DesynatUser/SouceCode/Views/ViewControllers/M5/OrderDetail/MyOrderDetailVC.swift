//
//  MyOrderDetailVC.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

struct StepImage {
  let selected: String
  let unselected: String
}

protocol SelectReasonDelegate: AnyObject {
  func didUpdateOrder(status: SelectScreenType)
}

import UIKit
import SDWebImage
import Cosmos

class MyOrderDetailVC: UIViewController, SelectReasonDelegate {
  func didUpdateOrder(status: SelectScreenType) {
    viewModel.getOrderDetail()
  }
  
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
  @IBOutlet weak var lblItemPrice: CustomLabelFont!
  @IBOutlet weak var orderTableView: TableViewDynamicHeight!
  
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
  
  @IBOutlet weak var lblDeliveredOnDate: CustomLabelFont!
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
  
  
  
  
  lazy private var viewModel = MyOrderDetailVM(hostVC: self)
  var orderData: OrderModel?
  var orderId: Int?
  var orderDetailId: Int?
  
  var isPromoCodeApplied: Bool = false
  var selectedPromoCode: PromocodeApplied?
  //    var slecetedPromocodeID: Int? = 0
  //    var totalAmount: Double = 0.0
  //    var totalMRPDiscountValue: Double = 0.0
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
    //registerXib()
    viewModel.getOrderDetail()
    viewItemPrice.isHidden = true
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
  
  func registerXib() {
    orderTableView.delegate = self
    orderTableView.dataSource = self
    orderTableView.register(UINib(nibName: "OrderDetailTableCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTableCell")
  }
  
  func setData() {
    guard let data = orderData else { return }
    lblOrderId.text = "#\(data.orderID ?? 0)"
    lblPlacedDate.text = "Placed on \(data.createdAt?.formattedPlacedDate() ?? "")"
    
    lblTotalMrp.text = formatPrice(Double(data.order?.totalMrp ?? "0"))
    lblDiscountMrp.text = formatPrice(Double(data.order?.discountMrp ?? "0"))
    //lblCouponDis.text
    lblShippingFee.text = "\(data.order?.shippingFees ?? "0") KD"
    lblTax.text = "\(data.order?.tax ?? "0") KD"
    lblTotalAmount.text = formatPrice(Double(data.order?.totalAmount ?? "0"))
    totalPaidAmount = lblTotalAmount.text
    
    // FIX: Only use API value when promo NOT applied
    if isPromoCodeApplied, let selected = selectedPromoCode {
      lblCouponDis.text = formatPrice(selected.applyDiscountValue)
      lblTotalAmount.text = formatPrice(selected.finalAmount)
      totalPaidAmount = lblTotalAmount.text
    } else {
      lblCouponDis.text = "0"//formatPrice(data.discountCoupon)
      lblTotalAmount.text = formatPrice(Double(data.order?.totalAmount ?? "0"))
      let savingAmount = Double(data.order?.discountMrp ?? "0")// - (data.totalAmount ?? 0)
      totalPaidAmount = lblTotalAmount.text
      lblSavedAmount.text = "You saved \(formatPrice(savingAmount)) on this"
    }
    
    //lblDeliveryInst.text = data
    let selectedAddress = data.order?.deliveryDetails
    let addressLine = "\(selectedAddress?.name ?? "")-\(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
    lblShippingAdd.text = addressLine
    
    let img = data.variationDetails?.variantImage
    if let imageUrl = img?.first, let url = URL(string: imageUrl) {
      imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
      imgProduct.sd_imageIndicator?.startAnimatingIndicator()
      imgProduct.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      imgProduct.image = UIImage(named: "")
    }
    
    //lblDisPrice.text = data.am
    lblPrice.text = "\(data.amount ?? "") KD"
    lblProductName.text = data.productDetails?.productNameEn ?? ""
    setColorBox(size: data.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data.quantity ?? 0)")
    configureStatus(with: data)
    
    lblPaidByCardAmount.text = totalPaidAmount
    reasonLabel.text = data.returnReason ?? data.exchangeReason ?? data.cancelReason ?? "-"
    returnIdLabel.text = "#\(data.orderID ?? 0)"
    cancellationIDLabel.text = "#\(data.orderID ?? 0)"
    exchangeIdLabel.text = "#\(data.orderID ?? 0)"
    
    returnDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
    cancellationDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
    exchangeDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
  }
  
  func configureStatus(with data: OrderModel) {
    resetStepper()
    lblStatus.text = ""
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
    
    let paymentMethod = data.order?.paymentMethod
    let paymentStatus = data.order?.paymentStatus
    let deliveryStatus = data.order?.deliveryStatus
    
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
        case "1": //Pending
          lblStatus.text = "Pending"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          
        case "2": //Ongoing
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          viewReturnDays.isHidden = false
          viewCancel.isHidden = false
          viewPaidBy.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          //                    activateStep(2, title: "On the Way")
          
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")
          viewStatus.borderColor = UIColor(hexString: "#16B364")
          viewReturnDays.isHidden = false
          viewRate.isHidden = false
          viewReturnEx.isHidden = false
          viewPaidBy.isHidden = false
          viewDownloadInvoice.isHidden = false
          handleReturnExchange(data: data)
          
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          activateStep(3, title: "Delivered")
          
          
        case "4": //Cancelled
          lblStatus.text = "Cancelled"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          viewStatus.borderColor = UIColor(hexString: "#E70000")
          viewCancelDetail.isHidden = false
          viewReason.isHidden = false
          viewPaidBy.isHidden = false
          hideStep(2)
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "In Progress")
          activateStep(3, title: "Cancelled")
          
        case "7": //Picked
          lblStatus.text = "Picked"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          viewStatus.borderColor = UIColor(hexString: "#E70000")
          viewCancelDetail.isHidden = true
          viewReason.isHidden = true
          viewPaidBy.isHidden = false
//          hideStep(3)
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          
          
        default:
          return
        }
      } else if paymentStatus == "3" {
        lblStatus.text = "Refund"
        lblStatus.textColor = UIColor(hexString: "#E70000")
        viewStatus.borderColor = UIColor(hexString: "#E70000")
        viewCancelDetail.isHidden = false
        viewReason.isHidden = false
        viewPaidBy.isHidden = false
        hideStep(2)
        activateStep(0, title: "Confirmed")
        activateStep(1, title: "In Progress")
        activateStep(3, title: "Refund")
      }
      
    } else if paymentMethod == "3" {
      if paymentStatus == "0" {
        switch deliveryStatus {
        case "1": //Pending
          lblStatus.text = "Pending"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          
        case "2": //Ongoing
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          viewReturnDays.isHidden = false
          viewCancel.isHidden = false
          viewPaidBy.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          //                    activateStep(2, title: "On the Way")
          
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")
          viewStatus.borderColor = UIColor(hexString: "#16B364")
          viewReturnDays.isHidden = false
          viewRate.isHidden = false
          viewReturnEx.isHidden = false
          viewPaidBy.isHidden = false
          viewDownloadInvoice.isHidden = false
          viewCancelDetail.isHidden = true
          handleReturnExchange(data: data)
          
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          activateStep(3, title: "Delivered")
          
          
        case "4": //Cancelled
          lblStatus.text = "Cancelled"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          viewStatus.borderColor = UIColor(hexString: "#E70000")
          viewCancelDetail.isHidden = false
          viewReason.isHidden = false
          viewPaidBy.isHidden = false
          hideStep(2)
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "In Progress")
          activateStep(3, title: "Cancelled")
          
        case "7": //Picked
          lblStatus.text = "Picked"
          lblStatus.textColor = UIColor(hexString: "#E70000")
          viewStatus.borderColor = UIColor(hexString: "#E70000")
          viewCancelDetail.isHidden = false
          viewReason.isHidden = false
          viewPaidBy.isHidden = false
          hideStep(3)
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          
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
//        hideStep(2)
        activateStep(0, title: "Confirmed")
        activateStep(1, title: "In Progress")
        activateStep(2, title: "On the Way")
        activateStep(3, title: "Cancelled")
      }
      lblPaidByCard.text = "COD"
      lblTransactionId.isHidden = true
    }
    
  }
  
  func handleReturnExchange(data: OrderModel) {
    let isReturnAllowed = data.productDetails?.productReturn == "1"
    let isExchangeAllowed = data.productDetails?.productExchangable == "1"
    
    //        viewReturnDays.isHidden = true
    //        viewCancel.isHidden = true
    //        viewRate.isHidden = true
    //        viewReturnEx.isHidden = true
    //        viewRatingShirt.isHidden = true
    //        viewRatingStore.isHidden = true
    //        viewDownloadInvoice.isHidden = true
    //        viewExchangeReturnBtn.isHidden = true
    
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
    
//    if !isReturnAllowed {
//      
//    }
    returnProductButtonOutlet.isHidden = !isReturnAllowed
    exchangeProductButtonOutlet.isHidden = !isExchangeAllowed
    
    if !isReturnAllowed && !isExchangeAllowed {
      viewReturnEx.isHidden = true
      exchangeReturnHeightConstrint.constant = 0
    } else {
      viewReturnEx.isHidden = false
      exchangeReturnHeightConstrint.constant = 64
    }
    if isReturnAllowed {
      lblStatus.text = "Return Request"
      lblStatus.textColor = UIColor(hexString: "#FF5F1B")
      viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
      activateStep(0, title: "Confirmed")
      activateStep(1, title: "In Progress")
      activateStep(2, title: "Pickup")
      activateStep(3, title: "Complete")
    } else if isExchangeAllowed {
      lblStatus.text = "Return Request"
      lblStatus.textColor = UIColor(hexString: "#FF5F1B")
      viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
      activateStep(0, title: "Confirmed")
      activateStep(1, title: "In Progress")
      activateStep(2, title: "Pickup & Exchange")
      activateStep(3, title: "Complete")
    }
    let returnStatus = data.returnType ?? "0"
    
    switch returnStatus {
    case "1":
      viewReturnEx.isHidden = true
      exchangeReturnDescriptionView.isHidden = false
      exchangeReturnDescriptionLabel.text = "Order is in return process"
      viewReturnDetail.isHidden = false
      viewReason.isHidden = false
    case "2":
      viewReturnEx.isHidden = true
      exchangeReturnDescriptionView.isHidden = false
      exchangeReturnDescriptionLabel.text = "Order is in exchange process"
      viewExchangeDetail.isHidden = false
      viewReason.isHidden = false
    default:
      viewReturnEx.isHidden = false
      exchangeReturnDescriptionView.isHidden = true
      viewReturnDetail.isHidden = true
      viewExchangeDetail.isHidden = true
      viewReason.isHidden = true
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
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btnDownloadInvoice(_ sender: Any) {
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
  
  
  
  //    @IBAction func btnExchnge(_ sender: Any) {
  //        let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
  //        vc.screenType = .cancelOrder
  //        vc.orderId = orderId ?? 0
  //        vc.orderDetailId = orderDetailId ?? 0
  //        vc.delegate = self
  //        vc.onExchange = {
  //            let vc = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
  //            vc.message = "Order Exchange Request Sent successfully!"
  //            vc.OnDismiss = {
  //                self.dismiss(animated: true) {
  //                    self.navigationController?.present(vc, animated: true)
  //                }
  //            }
  //        }
  //        self.navigationController?.present(vc, animated: true)
  //    }
  //
  //    @IBAction func btnReturn(_ sender: Any) {
  //        let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
  //        vc.screenType = .cancelOrder
  //        vc.orderId = orderId ?? 0
  //        vc.orderDetailId = orderDetailId ?? 0
  //        vc.delegate = self
  //        vc.onReturn = {
  //            let vc = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
  //            vc.message = "Order Return Request Sent successfully!"
  //            vc.OnDismiss = {
  //                self.dismiss(animated: true) {
  //                    self.navigationController?.present(vc, animated: true)
  //                }
  //            }
  //        }
  //        self.navigationController?.present(vc, animated: true)
  //    }
  
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
//    let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
//    vc.screenType = .returnPro
//    vc.orderId = orderId ?? 0
//    vc.orderDetailId = orderDetailId ?? 0
//    vc.delegate = self
//    vc.onReturn = {
//      let vc = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
//      vc.message = "Order Return Request Sent successfully!"
//      vc.OnDismiss = {
//        self.dismiss(animated: true) {
//          self.navigationController?.present(vc, animated: true)
//        }
//      }
//    }
//    self.navigationController?.present(vc, animated: true)
    
    
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
}

extension MyOrderDetailVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell", for: indexPath) as! OrderDetailTableCell
    cell.onTapCancel = {
      let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
      vc.screenType = .cancelOrder
      self.navigationController?.present(vc, animated: true)
    }
    
    cell.onTapExchange = {
      let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
      vc.screenType = .exchangePro
      self.navigationController?.present(vc, animated: true)
    }
    
    cell.onTapReturn = {
      let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
      vc.screenType = .returnPro
      self.navigationController?.present(vc, animated: true)
    }
    return cell
  }
  
  
}

extension String {
  func formattedPlacedDate() -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    guard let date = inputFormatter.date(from: self) else {
      return ""
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd/MM/yy 'at' h:mm a"
    outputFormatter.locale = Locale.current
    outputFormatter.timeZone = TimeZone.current
    
    return outputFormatter.string(from: date)
  }
}

