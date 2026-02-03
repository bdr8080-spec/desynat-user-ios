//
//  OrderPlacedViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit
import SwiftyGif

class OrderPlacedViewController: UIViewController {
  
  @IBOutlet weak var payentDoneOrNotLabel: UILabel!
  @IBOutlet weak var imageVideo: UIImageView!
  @IBOutlet weak var paymentAmountStackView: UIStackView!
  @IBOutlet weak var addressDescriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var amountPaidLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateView: UIView!
  
  var orderId: String? = ""
  lazy var viewModel = OrderPlacedViewModel(hostVC: self)
  var selectedMethod: Int = 0
    var isCustomOrderSeleced: Bool = false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getOrderSummary()
    deliveryDateView.layer.cornerRadius = 10
    deliveryDateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    deliveryDateView.layer.masksToBounds = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    playGIF()
  }
  
  func playGIF() {
    do {
      let gif = try UIImage(gifName: "orderPlace.gif")
      let gifManager = SwiftyGifManager(memoryLimit: 20)
      imageVideo.setGifImage(gif, manager: gifManager, loopCount: 1)
    } catch {
      print("GIF not found or failed to load")
    }
  }
  
  @IBAction func continueDidTapped(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @IBAction func trackYourOrderDidTapped(_ sender: Any) {
    let vc = MyOrderVC.instantiate(fromAppStoryboard: .MyOrder)
    vc.comingFromOrderTracking = true
//    vc.isCustomOrderSeleced = isCustomOrderSeleced
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func configData(data: OrderSummaryDataModel?) {
    locationLabel.text = data?.deliveryDetails?.name
    let selectedAddress = data?.deliveryDetails
    let addressLine = "\(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
    addressDescriptionLabel.text = addressLine
    let amountValue = Double(data?.totalAmount ?? "0")
    let amount = formatPrice(amountValue)
    var paymentMethodText = ""
    if selectedMethod == 1 {
      paymentMethodText = "Paid Online"
    } else if selectedMethod == 2 {
      paymentMethodText = "Paid Using Wallet"
    } else if selectedMethod == 3 {
      paymentMethodText = "Cash on Delivery (COD)"
    }
    let finalText = "\(amount) \(paymentMethodText)"
    let attributedString = NSMutableAttributedString(string: finalText)
    attributedString.addAttribute(
      .font,
      value: UIFont(name: "Poppins-Medium", size: 18)!,
      range: (finalText as NSString).range(of: amount)
    )
    attributedString.addAttribute(
      .font,
      value: UIFont(name: "Poppins-Regular", size: 13)!,
      range: (finalText as NSString).range(of: paymentMethodText)
    )
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    attributedString.addAttribute(
      .paragraphStyle,
      value: style,
      range: NSMakeRange(0, attributedString.length)
    )
    amountPaidLabel.attributedText = attributedString
  }
  
  func formatPrice(_ amount: Double?, currency: String = "KD") -> String {
    guard let amount = amount else { return "0 \(currency)" }
    let roundedAmount = round(amount * 100) / 100
    if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
      return "\(Int(roundedAmount)) \(currency)"
    } else {
      return String(format: "%.2f", roundedAmount) + " \(currency)"
    }
  }

}
