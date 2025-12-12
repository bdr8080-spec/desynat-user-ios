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
    //  var isCashOnDelivery: Bool = false
    var selectedMethod: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getOrderSummary()
        deliveryDateView.layer.cornerRadius = 10
        deliveryDateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        deliveryDateView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //      paymentAmountStackView.isHidden = isCashOnDelivery
        
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
    
    func configData(data: OrderSummaryDataModel?) {
        deliveryDateLabel.text = data?.createdAt
        amountPaidLabel.text = "\(data?.totalAmount ?? "") KD"
        locationLabel.text = data?.deliveryDetails?.name
        let selectedAddress = data?.deliveryDetails
        let addressLine = "\(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
        addressDescriptionLabel.text = addressLine
        
        if selectedMethod == 1 {
            payentDoneOrNotLabel.text = "Paid Online"
        } else if selectedMethod == 2 {
            payentDoneOrNotLabel.text = "Paid Using Wallet"
        } else if selectedMethod == 3 {
            payentDoneOrNotLabel.text = "Cash on Delivery (COD)"
        }
    }
    
}
