//
//  WithdrawalFiltersViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 05/03/26.
//

import UIKit

class WithdrawalFiltersViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    
    // MARK: - Property Decalaration
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedFilter = WithdrawalFilterModel()
    var onApplyFilter: ((WithdrawalFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        applyPreselectedData()
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = WithdrawalFilterModel()
        
        if let fromDate = fromTextField.text, !fromDate.isEmpty {
            filter.fromDate = fromDate
        }
        
        if let toDate = toTextField.text, !toDate.isEmpty {
            filter.toDate = toDate
        }
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        setUpTextFields()
    }
    
    private func applyPreselectedData() {
        // Preselect date fields
        fromTextField.text = selectedFilter.fromDate
        toTextField.text = selectedFilter.toDate
    }
    
}

extension WithdrawalFiltersViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        fromTextField.inputView = datePicker
        fromTextField.inputAccessoryView = toolbar
        toTextField.inputView = datePicker
        toTextField.inputAccessoryView = toolbar
        
        fromTextField.delegate = self
        toTextField.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if activeTextField == fromTextField {
            fromTextField.text = formatter.string(from: datePicker.date)
            if let toText = toTextField.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {
                toTextField.text = ""
            }
        }
        
        else if activeTextField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText),
               datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            toTextField.text = formatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    private func showValidationAlert() {
        let alert = UIAlertController(title: "Invalid Date",
                                      message: "To Date cannot be earlier than From Date.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

//MARK: UITextFieldDelegate Methods
extension WithdrawalFiltersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if textField == toTextField {
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        }
        if textField == fromTextField {
            datePicker.minimumDate = nil
        }
    }
}


struct WithdrawalFilterModel {
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return fromDate == nil && toDate == nil
    }
}
