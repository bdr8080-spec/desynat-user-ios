//
//  PlaceOrderPaymentMethodsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PlaceOrderPaymentMethodsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var paymentMethodView: UIView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var paymentMethdImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var cardTableViewHeightConstarint: NSLayoutConstraint!
  @IBOutlet weak var addNewCardView: CustomView!
  @IBOutlet weak var checkboxStackView: UIStackView!
  @IBOutlet weak var selecetdPaymentMethodButtonOutlet: UIButton!
  @IBOutlet weak var descriptionStackView: UIStackView!
  @IBOutlet weak var descriptionCheckbox: UIButton!
  @IBOutlet weak var cardsTableView: UITableView! {
    didSet {
      cardsTableView.registerCellFromNib(cellID: "CreditCardTableViewCell")
      cardsTableView.rowHeight = 60
      cardsTableView.separatorStyle = .none
    }
  }
  var totalAmountToPay: Int = 0
  let applePayButton = MFApplePayButton()
  var selectedCardID: Int = 0
  var isDefaultSelected: Bool = false
  var cardsCount: Int = 0 {
    didSet { updateCardsTableViewHeight() }
  }
  var addCardDidTapped:(() -> Void)?
  var onSetAsDefaultTapped: (() -> Void)?
  var onPaymentCompletion: ((MFPaymentStatusResponse?, String?, Error?) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    cardsTableView.delegate = self
    cardsTableView.dataSource = self
  }
  
  // MARK: - Update nested table height
  func updateCardsTableViewHeight() {
    DispatchQueue.main.async {
      self.cardsTableView.layoutIfNeeded()
      self.cardTableViewHeightConstarint.constant = self.cardsTableView.contentSize.height
      self.layoutIfNeeded()
    }
  }
  
  @IBAction func addCardDidTapped(_ sender: Any) {
    addCardDidTapped?()
  }
  
  @IBAction func setAsDefaultDidTapped(_ sender: Any) {
    isDefaultSelected.toggle()
    let imageName = isDefaultSelected ? "selectedFilterCheckBox" : "unslectedCheckbox"
    descriptionCheckbox.setImage(UIImage(named: imageName), for: .normal)
    onSetAsDefaultTapped?()
  }
  
  // MARK: Fix stackView layout
  func fixStackViewLayout() {
    descriptionStackView.layoutIfNeeded()
    checkboxStackView.layoutIfNeeded()
    addNewCardView.layoutIfNeeded()
    cardsTableView.layoutIfNeeded()
    self.layoutIfNeeded()
  }
}

// MARK: - TableView delegate
extension PlaceOrderPaymentMethodsTableViewCell: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cardsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
    cell.selectedRadioImageView.image = (indexPath.row == selectedCardID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCardID = indexPath.row
    cardsTableView.reloadData()
  }
}

extension PlaceOrderPaymentMethodsTableViewCell{
  
  func setupApplePay() {
    print("🟢 setupApplePay CALLED")
        print("paymentMethodView frame:", paymentMethodView.frame)
        print("applePayButton previously added:", applePayButton.superview != nil)
      if applePayButton.superview != nil { return }
      paymentMethodView.addSubview(applePayButton)
      applePayButton.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          applePayButton.leadingAnchor.constraint(equalTo: paymentMethodView.leadingAnchor),
          applePayButton.trailingAnchor.constraint(equalTo: paymentMethodView.trailingAnchor),
          applePayButton.topAnchor.constraint(equalTo: paymentMethodView.topAnchor),
          applePayButton.bottomAnchor.constraint(equalTo: paymentMethodView.bottomAnchor),
          applePayButton.heightAnchor.constraint(equalToConstant: 50)
      ])
  }
  
//  func startApplePaySession() {
//    let invoiceValue = Decimal(totalAmountToPay)
//    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
//    request.displayCurrencyIso = .uAE_AED
//    request.customerName = "Customer"
//    request.userDefinedField = "ORDER-38757353"
//    MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
//      guard let self = self else { return }
//      switch response {
//      case .success(let session):
//        print("Session initiated for Apple Pay")
//        self.applePayButton.load(session, request, .english,
//                                 startLoading: {
//          print("Starting Apple Pay...")
//        },
//                                 completion: { response, invoiceId in
//          switch response {
//          case .success(let executeResponse):
//            print("Apple Pay success: Invoice \(invoiceId ?? "N/A")")
////            let transactionID = executeResponse.invoiceTransactions?.first?.transactionID ?? ""
////            let gateway = executeResponse.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
//            self.onPaymentCompletion?(executeResponse, invoiceId, nil)
//          case .failure(let error):
//            print("Apple Pay failed: \(error.errorDescription)")
//          }
//        })
//      case .failure(let error):
//        print("Failed to initiate session: \(error.localizedDescription)")
//      }
//    }
//  }
  
  func startApplePaySession() {
      print("🔥 startApplePaySession CALLED")

      let invoiceValue = Decimal(totalAmountToPay)
      let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
      request.displayCurrencyIso = .uAE_AED
      request.customerName = "Customer"
      request.userDefinedField = "ORDER-38757353"

      MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
          guard let self = self else { return }

          switch response {
          case .success(let session):
              print("✅ Session initiated for Apple Pay")
              
              // Before loading
              print("🟦 Loading Apple Pay button...")

              self.applePayButton.load(session, request, .english,
                  startLoading: {
                      print("🚀 Apple Pay UI is now loading...")
                  },
                  completion: { response, invoiceId in
                      print("🎯 Apple Pay completion triggered")

                      switch response {
                      case .success(let executeResponse):
                          print("💚 Apple Pay success")
                      case .failure(let error):
                          print("💔 Apple Pay failed: \(error.errorDescription)")
                      }
                  }
              )

          case .failure(let error):
              print("❌ Session init failed:", error.localizedDescription)
          }
      }
  }

}
