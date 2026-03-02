//
//  ItemPerformanceViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit
import SDWebImage

class ItemPerformanceViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var productImageView: CustomImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var discountPercenteLabel: UILabel!
    @IBOutlet weak var commissionPercentageLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalOrdersLabel: UILabel!
    @IBOutlet weak var conversionRateLabel: UILabel!
    @IBOutlet weak var totalRevenueLabel: UILabel!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    
    // MARK: - Property Decalaration
    private var activeTextField: UITextField?
    private lazy var viewModel = ItemPerformanceViewModel(hostVC: self)
    var productId: Int = 0
    let datePicker = UIDatePicker()
    var onProductIsRemoved:(()-> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getLatestSearchData()
        setUpTextFields()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyLinkDidTapped(_ sender: Any) {
        let link = viewModel.productsDetailsData?.affiliateProductLink?.link ?? ""
        UIPasteboard.general.string = link
        showCopiedLabel()
    }
    
    @IBAction func productImageDidTapped(_ sender: Any) {
        guard let images = viewModel.productsDetailsData?.product?.productVariants?.first?.variantImage else { return }
        let vc = FullscreenGalleryViewController()
        vc.images = images
        vc.startIndex = 0
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        showConfirmationAlert(msg: "Are you sure you want to remove this product?"){ [weak self] in
            guard let self = self else { return }
            viewModel.deleteAffiliatedProductData()
        }
    }
    
    // MARK: - function
    private func showCopiedLabel() {
        let copiedLabel = UILabel()
        copiedLabel.text = "  Copied  "
        copiedLabel.textAlignment = .center
        copiedLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        copiedLabel.textColor = .white
        copiedLabel.backgroundColor = .darkGray
        copiedLabel.layer.cornerRadius = 8
        copiedLabel.clipsToBounds = true
        
        copiedLabel.frame = CGRect(
            x: (view.frame.width - 100) / 2,
            y: view.frame.height - 120,
            width: 100,
            height: 35)
        view.addSubview(copiedLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            copiedLabel.removeFromSuperview()
        }
    }
    
}


extension ItemPerformanceViewController {
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        //        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        let textFields = [txtFromDate, txtToDate]
        textFields.forEach { textField in
            textField?.inputView = datePicker
            textField?.inputAccessoryView = toolbar
            textField?.delegate = self
        }
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let activeTextField = activeTextField else { return }
        activeTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        switch activeTextField {
        case txtFromDate:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.txtToDate.becomeFirstResponder()
            }
        default:
            break
        }
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        // If textfield already has a date, show it in picker
        if let text = textField.text,
           let selectedDate = formatter.date(from: text) {
            datePicker.date = selectedDate
        } else {
            // Optional: set default date
            datePicker.date = Date()
        }
        
        // Handle minimum date for To Date
        if textField == txtToDate,
           let fromDateText = txtFromDate.text,
           let fromDate = formatter.date(from: fromDateText) {
            datePicker.minimumDate = fromDate
        } else {
            datePicker.minimumDate = nil
        }
    }
}
