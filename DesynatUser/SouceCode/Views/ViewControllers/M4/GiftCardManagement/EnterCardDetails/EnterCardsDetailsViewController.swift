//
//  EnterCardsDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class EnterCardsDetailsViewController: UIViewController {
  
  @IBOutlet weak var enterAmountView: CustomView!
  @IBOutlet weak var amountCollectioView: UICollectionView! {
    didSet {
      amountCollectioView.registerCellFromNib(cellID: "SelectOccassionCollectionViewCell")
    }
  }
  
  var amountArray = ["100 KD", "1000 KD", "Enter amount"]
  var selectedIndex: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    enterAmountView.isHidden = true
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func payDidTapped(_ sender: Any) {
    let nextVC = PaymentMethodViewController.instantiate(fromAppStoryboard: .Profile)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}

extension EnterCardsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return amountArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectOccassionCollectionViewCell", for: indexPath) as! SelectOccassionCollectionViewCell
    let data = amountArray[indexPath.row]
    cell.titleLabel.text = data
    if selectedIndex == indexPath {
      cell.backgroundImageView.isHidden = false
      cell.titleLabel.textColor = .white
    } else {
      cell.backgroundImageView.isHidden = true
      cell.titleLabel.textColor = .black
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width) / 3
    let height: CGFloat = 38
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath
    if indexPath.row == 2 {
      enterAmountView.isHidden = false
    } else {
      enterAmountView.isHidden = true
    }
    amountCollectioView.reloadData()
  }
  
}

