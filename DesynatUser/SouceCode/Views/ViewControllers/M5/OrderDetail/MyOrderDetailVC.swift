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
  var orderId: Int?
  var orderDetailId: Int?
  var selectedPromoCode: PromocodeApplied?
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
    registerXib()
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
    lblOrderId.text = "#\(data.id ?? 0)"
    lblPlacedDate.text = "Placed on \(data.createdAt?.formattedPlacedDate() ?? "")"
    
    lblTotalMrp.text = formatPrice(Double(data.order?.totalMrp ?? "0"))
    lblDiscountMrp.text = formatPrice(Double(data.order?.discountMrp ?? "0"))
    //lblCouponDis.text
    lblShippingFee.text = "\(data.order?.shippingFees ?? "0") KD"
    lblTax.text = "\(data.order?.tax ?? "0") KD"
    lblTotalAmount.text = formatPrice(Double(data.order?.totalAmount ?? "0"))
    totalPaidAmount = lblTotalAmount.text
    let totalPrice = formatPrice(Double(data.order?.totalMrp ?? "0"))
    CommonUtils.setStrikethrough(label: lblPrice, text: totalPrice)
    let isReturnAllowed = data.productDetails?.productReturn == "1"
    if isReturnAllowed {
      lblReturnAvail.text = "\(data.productDetails?.returnDays ?? "1") days return available"
    } else {
      lblReturnAvail.text = "No return available"
    }
    
    let discountType = data.variationDetails?.discountType ?? "1"
    if discountType == "1" {
      discountPercentageLabel.text = "\(data.variationDetails?.discountValue ?? "")% Off"
    } else {
      discountPercentageLabel.text = "\(data.variationDetails?.discountValue ?? "") KD Off"
    }
    
    // FIX: Only use API value when promo NOT applied
//    if let selected = selectedPromoCode {
//      lblCouponDis.text = formatPrice(selected.applyDiscountValue)
//      lblTotalAmount.text = formatPrice(selected.finalAmount)
//      totalPaidAmount = lblTotalAmount.text
//    } else {
//      lblCouponDis.text = "0"//formatPrice(data.discountCoupon)
//      lblTotalAmount.text = formatPrice(Double(data.order?.totalAmount ?? "0"))
//      let savingAmount = Double(data.order?.discountMrp ?? "0")// - (data.totalAmount ?? 0)
//      totalPaidAmount = lblTotalAmount.text
//      lblSavedAmount.text = "You saved \(formatPrice(savingAmount)) on this"
//    }
    
    if let selected = selectedPromoCode {
        // Promo code applied
        couponDiscountView.isHidden = false
        lblCouponDis.text = formatPrice(selected.applyDiscountValue)
        lblTotalAmount.text = formatPrice(selected.finalAmount)
        totalPaidAmount = lblTotalAmount.text
    } else {
        // No promo code applied
        couponDiscountView.isHidden = true
        lblCouponDis.text = "0" // or formatPrice(data.discountCoupon)
        lblTotalAmount.text = formatPrice(Double(data.order?.totalAmount ?? "0"))
        let savingAmount = Double(data.order?.discountMrp ?? "0") // - (data.totalAmount ?? 0)
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
    
    if let returnImg = data.returnImage, let returnImgUrl = URL(string: returnImg) {
      imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
      imgProfile.sd_imageIndicator?.startAnimatingIndicator()
      imgProfile.sd_setImage(with: returnImgUrl, placeholderImage: UIImage(named: ""))
    } else {
      imgProfile.image = UIImage(named: "")
    }
    
    //lblDisPrice.text = data.am
//    lblPrice.text = "\(data.amount ?? "") KD"
    lblProductName.text = data.productDetails?.productNameEn ?? ""
    setColorBox(size: data.variationDetails?.size?.name ?? "", label: lblSize, hexColor: data.variationDetails?.color?.hexCode ?? "#98ADFF", quantity: "\(data.quantity ?? 0)")
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
    lblReturnAvail.isHidden = false
    let paymentMethod = data.order?.paymentMethod
    let paymentStatus = data.paymentStatus//order?.paymentStatus
    let deliveryStatus = data.deliveryStatus//order?.deliveryStatus
    
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
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          viewReturnDays.isHidden = false
          viewCancel.isHidden = false
          viewPaidBy.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          
        case "2": //Ongoing
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          viewReturnDays.isHidden = false
          viewCancel.isHidden = false
          viewPaidBy.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          
        case "3": //Delivered
          lblStatus.text = "Delivered"
          lblStatus.textColor = UIColor(hexString: "#16B364")
          viewStatus.borderColor = UIColor(hexString: "#16B364")
          viewReturnDays.isHidden = false
          viewRate.isHidden = false
          viewReturnEx.isHidden = false
          viewPaidBy.isHidden = false
          viewDownloadInvoice.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          activateStep(3, title: "Delivered")
          handleReturnExchange(data: data)
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
            lblDeliveredOn.text = "Delivered On : \(isoDate)"
          } else {
            lblDeliveredOn.text = "Delivered On : -"
          }
          if data.returnType == "1"{ //Return Request
            lblStatus.text = "Return Request"
            lblStatus.textColor = UIColor(hexString: "#FF5F1B")
            viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
            resetStepper()
            activateStep(0, title: "Confirmed")
            activateStep(1, title: "In Progress")
            lbl3.text = "Picked Up"
            lbl4.text = "Completed"
            if let isoDate = isoStringAddingDays(data.updatedAt, days: 6) {
              lblDeliveredOn.text = "Pickup Date : \(isoDate)"
            } else {
              lblDeliveredOn.text = "Pickup Date : -"
            }
            
            let returnImgeUpload = data.returnImage ?? ""
            if returnImgeUpload.isEmpty {
              viewUploadImg.isHidden = true
            } else {
              viewUploadImg.isHidden = false
            }
            lblPlacedDate.text = "Return request \(data.updatedAt?.formattedPlacedDate() ?? "")"
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
//          activateStep(1, title: "In Progress")
          activateStep(3, title: "Cancelled")
          img4.image = UIImage(named: "canclledOrdreRed")
          lbl4.textColor = UIColor(hexString: "#D72E04")
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
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
          viewReturnDays.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          
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
//          activateStep(1, title: "In Progress")
//          activateStep(2, title: "On the Way")
          activateStep(3, title: "Cancelled")
          img4.image = UIImage(named: "canclledOrdreRed")
          lbl4.textColor = UIColor(hexString: "#D72E04")
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
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
//        activateStep(1, title: "In Progress")
        activateStep(3, title: "Cancelled")
        img4.image = UIImage(named: "canclledOrdreRed")
        lbl4.textColor = UIColor(hexString: "#D72E04")
        if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
          lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
        } else {
          lblDeliveredOn.text = "Cancelled Date : -"
        }
        lblReturnAvail.isHidden = true
      }
      
    } else if paymentMethod == "3" {
      if paymentStatus == "0" || paymentStatus == "1" {
        switch deliveryStatus {
        case "1": //Pending
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          viewReturnDays.isHidden = false
          viewCancel.isHidden = false
          viewPaidBy.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          
        case "2": //Ongoing
          lblStatus.text = "Ongoing"
          lblStatus.textColor = UIColor(hexString: "#FF5F1B")
          viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
          viewReturnDays.isHidden = false
          viewCancel.isHidden = false
          viewPaidBy.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          
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
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          activateStep(3, title: "Delivered")
          handleReturnExchange(data: data)
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
            lblDeliveredOn.text = "Delivered On : \(isoDate)"
          } else {
            lblDeliveredOn.text = "Delivered On : -"
          }
          if data.returnType == "1"{ //Return Request
            lblStatus.text = "Return Request"
            lblStatus.textColor = UIColor(hexString: "#FF5F1B")
            viewStatus.borderColor = UIColor(hexString: "#FF5F1B")
            resetStepper()
            activateStep(0, title: "Confirmed")
            activateStep(1, title: "In Progress")
            lbl3.text = "Picked Up"
            lbl4.text = "Completed"
            if let isoDate = isoStringAddingDays(data.updatedAt, days: 6) {
              lblDeliveredOn.text = "Pickup Date : \(isoDate)"
            } else {
              lblDeliveredOn.text = "Pickup Date : -"
            }
            lblPlacedDate.text = "Return request \(data.updatedAt?.formattedPlacedDate() ?? "")"
            let returnImgeUpload = data.returnImage ?? ""
            if returnImgeUpload.isEmpty {
              viewUploadImg.isHidden = true
            } else {
              viewUploadImg.isHidden = false
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
//          activateStep(1, title: "In Progress")
          activateStep(3, title: "Cancelled")
          img4.image = UIImage(named: "canclledOrdreRed")
          lbl4.textColor = UIColor(hexString: "#D72E04")
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
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
          viewReturnDays.isHidden = false
          activateStep(0, title: "Confirmed")
          activateStep(1, title: "Shipped")
          activateStep(2, title: "On the Way")
          
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
//          activateStep(1, title: "In Progress")
//          activateStep(2, title: "On the Way")
          activateStep(3, title: "Cancelled")
          img4.image = UIImage(named: "canclledOrdreRed")
          lbl4.textColor = UIColor(hexString: "#D72E04")
          if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
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
//        activateStep(1, title: "In Progress")
//        activateStep(2, title: "On the Way")
        activateStep(3, title: "Cancelled")
        img4.image = UIImage(named: "canclledOrdreRed")
        lbl4.textColor = UIColor(hexString: "#D72E04")
        lblReturnAvail.isHidden = true
        if let isoDate = isoStringAddingDays(data.updatedAt, days: 0) {
          lblDeliveredOn.text = "Cancelled Date : \(isoDate)"
        } else {
          lblDeliveredOn.text = "Cancelled Date : -"
        }
      }
      lblPaidByCard.text = "COD"
      lblTransactionId.isHidden = true
      
      
    }
    
  }
  
  func isoStringAddingDays(_ isoString: String?, days: Int = 0) -> String? {
    guard let isoString = isoString else { return nil }
    
    // 1️⃣ Parse the ISO date string from API
    let isoFormatter = DateFormatter()
    isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    isoFormatter.locale = Locale(identifier: "en_US_POSIX")
    isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = isoFormatter.date(from: isoString) else { return nil }
    
    // 2️⃣ Add days if needed
    let calendar = Calendar(identifier: .gregorian)
    let newDate = calendar.date(byAdding: .day, value: days, to: date) ?? date
    
    // 3️⃣ Format to desired output: 12 SEP 25
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd MMM yy"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    outputFormatter.timeZone = TimeZone.current
    
    return outputFormatter.string(from: newDate)
  }
  
  func handleReturnExchange(data: OrderModel) {
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
      viewReturnEx.isHidden = true
      exchangeReturnHeightConstrint.constant = 0
    } else {
      viewReturnEx.isHidden = false
      exchangeReturnHeightConstrint.constant = 64
    }
    let returnStatus = data.returnType ?? "0"
    
    switch returnStatus {
    case "1":
      viewReturnEx.isHidden = true
      viewReturnDetail.isHidden = false
      viewReason.isHidden = false
    case "2":
      viewReturnEx.isHidden = true
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
//    guard let urlString = viewModel.invoiceDetailsUrl,
//              let url = URL(string: urlString) else {
//            showAlert(msg: "Invoice not available")
//            return
//        }
//
//        downloadPDF(from: url)
    let orderId = orderData?.order?.orderID ?? ""
    let urlString = "http://157.241.119.72/Invoice/\(orderId)"

        guard let url = URL(string: urlString) else {
            showAlert(msg: "Invalid invoice URL")
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  private func downloadPDF(from url: URL) {
      let session = URLSession(configuration: .default)

      let task = session.downloadTask(with: url) { [weak self] tempURL, response, error in
          guard let self = self else { return }

          if let error = error {
              DispatchQueue.main.async {
                  self.showAlert(msg: error.localizedDescription)
              }
              return
          }

          guard let tempURL = tempURL else { return }

          do {
              let fileManager = FileManager.default
              let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
              let destinationURL = documentsURL.appendingPathComponent("Invoice.pdf")

              // Remove existing file if any
              if fileManager.fileExists(atPath: destinationURL.path) {
                  try fileManager.removeItem(at: destinationURL)
              }

              try fileManager.moveItem(at: tempURL, to: destinationURL)

              DispatchQueue.main.async {
                  self.showAlert(msg: "Invoice downloaded successfully")
                  self.openPDF(at: destinationURL)
              }

          } catch {
              DispatchQueue.main.async {
                  self.showAlert(msg: "Failed to save invoice")
              }
          }
      }

      task.resume()
  }

  private func openPDF(at url: URL) {
      let controller = UIDocumentInteractionController(url: url)
      controller.delegate = self
      controller.presentPreview(animated: true)
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
    return orderData?.allOtherOrderVarient?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell", for: indexPath) as! OrderDetailTableCell
    let data = orderData?.allOtherOrderVarient?[indexPath.row]
    let paymentMethod = orderData?.order?.paymentMethod ?? "1"
    let paymentStatus = data?.paymentStatus ?? "1"
    let deliveryStatus = data?.deliveryStatus ?? "1"
    cell.configData(data: data, paymentMethod: paymentMethod, paymentStatus: paymentStatus, deliveryStatus: deliveryStatus)
//    cell.onTapCancel = {
//      let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
//      vc.screenType = .cancelOrder
//      self.navigationController?.present(vc, animated: true)
//    }
//    
//    cell.onTapExchange = {
//      let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
//      vc.screenType = .exchangePro
//      self.navigationController?.present(vc, animated: true)
//    }
//    
//    cell.onTapReturn = {
//      let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
//      vc.screenType = .returnPro
//      self.navigationController?.present(vc, animated: true)
//    }
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

extension MyOrderDetailVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
