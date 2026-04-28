//
//  EnterCardsDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class EnterCardsDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var whatsAppNumberTF: UITextField!
    @IBOutlet weak var enterAmountTF: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fromNameTextField: UITextField!
    @IBOutlet weak var wishMessageTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var enterAmountView: CustomView!
    @IBOutlet weak var amountCollectioView: UICollectionView! {
        didSet {
            amountCollectioView.registerCellFromNib(cellID: "SelectOccassionCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var amountArray = ["100 KD", "1000 KD", "Enter amount"]
    var selectedIndex: Int? = 0
    var selectedOccassionId: Int = 0
    private lazy var viewModel = EnterCardsDetailsViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enterAmountView.isHidden = true
        setDelegateMethod()
        viewModel.getALlUserCountryListApi()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.payForAddingCard()
        }
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag1 ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.getAllUSerCountryList[index]
            let code = selectedCountry.dialCode ?? "+965"
            self.countryCodeTF.text = code
        }
    }
    
    //MARK: Function's declaration
    func setDelegateMethod() {
        let textFields = [enterAmountTF, nameTextField, emailTextField, fromNameTextField, wishMessageTextView, noteTextView]
        for item in textFields {
            if let tf = item as? UITextField {
                tf.delegate = self
            } else if let tv = item as? UITextView {
                tv.delegate = self
            }
        }
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension EnterCardsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amountArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectOccassionCollectionViewCell", for: indexPath) as! SelectOccassionCollectionViewCell
        let data = amountArray[indexPath.row]
        if indexPath.row != 2 {
            cell.titleLabel.text = CommonUtils.formatPriceStringInput(data.replacingOccurrences(of: " KD", with: ""))
        } else {
            cell.titleLabel.text = data
        }
        
        if selectedIndex == indexPath.row {
            cell.backgroundImageView.isHidden = false
            cell.titleLabel.textColor = .white
        } else {
            cell.backgroundImageView.isHidden = true
            cell.titleLabel.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (amountCollectioView.frame.width - 15) / 3
        let height: CGFloat = 38
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if indexPath.row == 2 {
            enterAmountView.isHidden = false
        } else {
            enterAmountView.isHidden = true
        }
        amountCollectioView.reloadData()
    }
}

//MARK: UITextFieldDelegate Methods
extension EnterCardsDetailsViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if currentText.count == 1, currentText == " " {
            return false
        }
        if textField == enterAmountTF {
            if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
                return false
            }
            if currentText.count == 1, currentText == "0" {
                return false
            }
            if currentText.count > 7 {
                return false
            }
        }
        if textField == self.emailTextField {
            var validation: StringValidation?
            validation = StringValidation(string: currentText, characterCount: 65, validation: .emailId)
            if let data = validation {
                return data.validate()
            } else {
                return true
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updated = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if updated.count == 1, updated == " " {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            textView.placeholderTextView = ""
        } else {
            if textView == wishMessageTextView {
                textView.placeholderTextView = "Enter wish message"
            }
        }
    }
}
