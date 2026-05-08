//
//  AffiliatedUserHomeViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserHomeViewController: UIViewController {
    
    //MARK: - IBOutlet's
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnThisWeek: UIButton!
    @IBOutlet weak var btnThisMonth: UIButton!
    @IBOutlet weak var ntoificationcountView: CustomView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var lblTotalRevenue: UILabel!
    @IBOutlet weak var lblTotalProduct: UILabel!
    @IBOutlet weak var lblTotalOrder: UILabel!
    @IBOutlet weak var lblOngoing: UILabel!
    @IBOutlet weak var lblReturn: UILabel!
    @IBOutlet weak var lblCancelled: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    
    //MARK: - Property Decalaration
    private var dateButtons: [UIButton] { [btnToday, btnThisWeek, btnThisMonth]}
    private lazy var viewModel = AffiliatedUserHomeViewModel(hostVC: self)
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    
    enum FilterType: Int {
        //        case custom = 0
        //1-today,2-this week,3-this month,4-this year
        case today = 1
        case week = 2
        case month = 3
        //        case thisYear = 4
    }
    private var selectedButton: UIButton?
    private var selectedFilter: FilterType?
    
    //MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        // Default Today Selected
        updateRadioSelection(for: dateButtons, selectedButton: btnToday)
        selectedFilter = .today
        selectedButton = btnToday
        callDashboardAPI()
        viewModel.getUserData()
        btnToday.setTitle("Today".localiz(), for: .normal)
        btnThisWeek.setTitle("This week".localiz(), for: .normal)
        btnThisMonth.setTitle("This Month".localiz(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCountOfNotificationRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func btnSelectDate(_ sender: UIButton) {
        if selectedButton == sender {
            selectedButton = nil
            selectedFilter = nil
            
            for button in dateButtons {
                button.setImage(UIImage(named: "unselcetdRadioHome"), for: .normal)
            }
            
            callDashboardAPI()
            return
        }
        
        // 👉 New selection
        selectedButton = sender
        updateRadioSelection(for: dateButtons, selectedButton: sender)
        
        // ❌ DON'T clear dates anymore
        
        if sender == btnToday {
            selectedFilter = .today
        } else if sender == btnThisWeek {
            selectedFilter = .week
        } else {
            selectedFilter = .month
        }
        
        callDashboardAPI()
    }
    
    @IBAction func bellDidTapepd(_ sender: Any) {
        let nextVC = AffiliateUserNotificationViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func supportChatDidTapped(_ sender: Any) {
        let nextVC = SupportChatViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.comingUserRole = .affilaiteUser
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    private func updateRadioSelection(for buttons: [UIButton], selectedButton: UIButton) {
        for button in buttons {
            if button == selectedButton {
                button.setImage(UIImage(named: "radioHome"), for: .normal)
            } else {
                button.setImage(UIImage(named: "unselcetdRadioHome"), for: .normal)
            }
        }
    }
}

//MARK: UITextFieldDelegate Methods
extension AffiliatedUserHomeViewController: UITextFieldDelegate {
    
    private func setUpTextFields() {
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
            datePicker.locale = Locale(identifier: "ar")
        } else {
            datePicker.locale = Locale(identifier: "en_US")
        }
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancel, space, done], animated: false)
        
        fromDateTextField.inputView = datePicker
        fromDateTextField.inputAccessoryView = toolbar
        
        toDateTextField.inputView = datePicker
        toDateTextField.inputAccessoryView = toolbar
        
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if textField == fromDateTextField {
            // ✅ From date → no minimum restriction
            datePicker.minimumDate = nil
            datePicker.maximumDate = Date()
            
        } else if textField == toDateTextField {
            // ✅ To date → min = fromDate (if selected)
            if let fromText = fromDateTextField.text,
               let fromDate = formatter.date(from: fromText) {
                
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
            
            datePicker.maximumDate = Date()
        }
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: datePicker.date)
        if activeTextField == fromDateTextField {
            fromDateTextField.text = selectedDate
            if let fromDate = formatter.date(from: selectedDate),
               let toText = toDateTextField.text,
               let toDate = formatter.date(from: toText),
               toDate < fromDate {
                toDateTextField.text = ""
            }
        } else if activeTextField == toDateTextField {
            toDateTextField.text = selectedDate
        }
        validateAndApplyCustomDate()
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    private func validateAndApplyCustomDate() {
        
        guard
            let from = fromDateTextField.text, !from.isEmpty,
            let to = toDateTextField.text, !to.isEmpty
        else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard
            let fromDate = formatter.date(from: from),
            let toDate = formatter.date(from: to)
        else { return }
        
        if toDate < fromDate {
            showAlert("To date cannot be less than From date".localiz())
            toDateTextField.text = ""
            return
        }
        callDashboardAPI()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert".localiz(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))
        present(alert, animated: true)
    }
}

extension AffiliatedUserHomeViewController {
    
    private func callDashboardAPI() {
        let fromDate = fromDateTextField.text ?? ""
        let toDate = toDateTextField.text ?? ""
        var filterModel = AffiliateDashboardFilterModel(fromDate: nil,toDate: nil,filter: selectedFilter?.rawValue)
        if !fromDate.isEmpty && !toDate.isEmpty {
            filterModel.fromDate = fromDate
            filterModel.toDate = toDate
        }
        viewModel.dashboardFilter = filterModel
        viewModel.getDashboardData()
    }
}
