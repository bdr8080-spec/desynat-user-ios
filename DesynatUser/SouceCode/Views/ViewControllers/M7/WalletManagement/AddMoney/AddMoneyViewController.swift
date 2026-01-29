//
//  AddMoneyViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import UIKit

class AddMoneyViewController: UIViewController {
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var amountCollectionview: UICollectionView! {
        didSet {
            amountCollectionview.registerCellFromNib(cellID: "AddMoneyCollectionViewCell")
        }
    }
    private var moneyList = ["10 KD", "100 KD", "500 KD"]
    var selectedMoneyIndex: Int = -1
    var amountToPay: Double? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTF.keyboardType = .decimalPad
        amountTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        selectedMoneyIndex = -1
        amountToPay = nil
        amountCollectionview.reloadData()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func continueDidTapped(_ sender: Any) {
        guard let finalAmount = getFinalAmount(), finalAmount > 0 else {
            showAlert(msg: "Please enter or select a valid amount")
            return
        }
        
        let nextVC = PaymentMethodViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.comingFrom = .fromWalletMeonyAdd
        //        nextVC.orderId = response.orderID ?? ""
        nextVC.payAmount = finalAmount
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func getFinalAmount() -> Double? {
        // 1️⃣ Check TextField first
        if let text = amountTF.text,
           !text.trimmingCharacters(in: .whitespaces).isEmpty,
           let amount = Double(text.trimmingCharacters(in: .whitespaces)) {
            return amount
        }
        
        // 2️⃣ Else fallback to selected collection value
        return amountToPay
    }
    
    
    
}

extension AddMoneyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moneyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoneyCollectionViewCell", for: indexPath) as! AddMoneyCollectionViewCell
        let data = moneyList[indexPath.row]
        cell.titleLabel.text = data
        if selectedMoneyIndex == indexPath.row {
            cell.mainView.borderColor = .accent
        } else {
            cell.mainView.borderColor = .black.withAlphaComponent(0.1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMoneyIndex = indexPath.row
        let value = moneyList[indexPath.row]
            .replacingOccurrences(of: "KD", with: "")
            .trimmingCharacters(in: .whitespaces)
        amountToPay = Double(value)
        amountTF.text = value
        amountCollectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//       let width = (amountCollectionview.frame.width + 5) / 3
        let height: CGFloat = 38
        return CGSize(width: 105, height: height)
    }
    
    
}
