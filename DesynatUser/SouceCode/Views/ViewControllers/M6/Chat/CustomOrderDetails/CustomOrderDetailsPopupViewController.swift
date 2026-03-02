//
//  CustomOrderDetailsPopupViewController.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import UIKit

class CustomOrderDetailsPopupViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var customDetailsLabel: UILabel!
    @IBOutlet weak var addressLAbel: UILabel!
    @IBOutlet weak var tottalQuantityLAbel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    var quotationData: Record?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        bindData()
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    func bindData() {
        tottalQuantityLAbel.text = quotationData?.quantity
        addressLAbel.text = buildFullAddress(from: quotationData?.deliveryDetails)
        customDetailsLabel.text = quotationData?.customDetails
    }
    
    func buildFullAddress(from details: DeliveryDetails?) -> String {
        guard let details = details else { return "" }
        
        var addressParts: [String] = []
        
        // Base address (if API already provides)
        if let baseAddress = details.address?.trimmingCharacters(in: .whitespacesAndNewlines),
           !baseAddress.isEmpty {
            addressParts.append(baseAddress)
        }
        
        let additionalParts = [
            details.houseNo,
            details.streetNo,
            details.landmark,
            details.city,
            details.state,
            details.countryName,
            details.postalCode,
        ]
        
        for part in additionalParts {
            guard let value = part?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty else { continue }
            
            if !addressParts.joined(separator: " ").localizedCaseInsensitiveContains(value) {
                addressParts.append(value)
            }
        }
        
        return addressParts.joined(separator: ", ")
    }
}
