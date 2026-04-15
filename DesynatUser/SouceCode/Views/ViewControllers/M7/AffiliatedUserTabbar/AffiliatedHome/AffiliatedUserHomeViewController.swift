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
        case custom = 0
        case today = 1
        case week = 2
        case month = 3
    }
    
    private var selectedFilter: FilterType = .today
    
    //MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        // Default Today Selected
        updateRadioSelection(for: dateButtons, selectedButton: btnToday)
        selectedFilter = .today
        
        callDashboardAPI()
        viewModel.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCountOfNotificationRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func btnSelectDate(_ sender: UIButton) {
        updateRadioSelection(for: dateButtons, selectedButton: sender)
        
        // Clear custom dates
        fromDateTextField.text = ""
        toDateTextField.text = ""
        
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
        self.navigationController?.popViewController(animated: true)
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
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
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
    }
    
    @objc private func doneDatePicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let selectedDate = formatter.string(from: datePicker.date)
        
        if activeTextField == fromDateTextField {
            fromDateTextField.text = selectedDate
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
        
        // ❌ Validation
        if toDate < fromDate {
            showAlert("To date cannot be less than From date")
            toDateTextField.text = ""
            return
        }
        
        // ✅ Custom selected
        selectedFilter = .custom
        
        // Unselect radio buttons
        for button in dateButtons {
            button.setImage(UIImage(named: "unselcetdRadioHome"), for: .normal)
        }
        
        callDashboardAPI()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AffiliatedUserHomeViewController {
    
    private func callDashboardAPI() {
        
        var fromDate = ""
        var toDate = ""
        var filterType = selectedFilter.rawValue
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        
        switch selectedFilter {
            
        case .today:
            let date = formatter.string(from: today)
            fromDate = date
            toDate = date
            
        case .week:
            let calendar = Calendar.current
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            fromDate = formatter.string(from: startOfWeek)
            toDate = formatter.string(from: today)
            
        case .month:
            let calendar = Calendar.current
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
            fromDate = formatter.string(from: startOfMonth)
            toDate = formatter.string(from: today)
            
        case .custom:
            fromDate = fromDateTextField.text ?? ""
            toDate = toDateTextField.text ?? ""
            filterType = 0
        }
        
        // 👉 YOUR VIEWMODEL METHOD
        viewModel.getDashboardData(
            fromDate: fromDate,
            toDate: toDate,
            filterType: filterType
        )
    }
}
