//
//  AddedCardDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import SDWebImage

class AddedCardDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var giftCardImageView: CustomImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recepientNameLabel: UILabel!
    @IBOutlet weak var recepientEmailLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var fromMessageLabel: UILabel!
    @IBOutlet weak var transactiobIdLabel: UILabel!
    @IBOutlet weak var paidAmountLabel: UILabel!
    @IBOutlet weak var paymentCardImageView: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    
    // MARK: - Property Decalaration
    var giftCardDetails: GiftCardsListDataModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
    func configData(){
        if let imageUrlString = giftCardDetails?.giftDetails?.image,
           let url = URL(string: imageUrlString) {
            giftCardImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            giftCardImageView.sd_imageIndicator?.startAnimatingIndicator()
            giftCardImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        dateLabel.text = formatDate(giftCardDetails?.createdAt ?? "")
        
        cardLabel.text = giftCardDetails?.giftDetails?.nameEnglish
        amountLabel.text = CommonUtils.formatPriceStringInput(giftCardDetails?.amount)
        recepientNameLabel.text = giftCardDetails?.receiverName
        recepientEmailLabel.text = giftCardDetails?.receiverEmail
        quantityLabel.text = "Total Quantity- 1"
        fromNameLabel.text = giftCardDetails?.senderName
        fromMessageLabel.text = giftCardDetails?.wishMessage
        
        transactiobIdLabel.text = giftCardDetails?.transactionID
        paidAmountLabel.text = CommonUtils.formatPriceStringInput(giftCardDetails?.amount)
    }
    
    private func formatDate(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: isoString) else {
            return "Invalid date"
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM yy, h:mm a"
        return formatter.string(from: date).lowercased()
    }
    
}
