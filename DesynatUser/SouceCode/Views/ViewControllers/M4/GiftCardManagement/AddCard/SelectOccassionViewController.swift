//
//  SelectOccassionViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class SelectOccassionViewController: UIViewController {
  
  @IBOutlet weak var occassionCollectionView: UICollectionView! {
    didSet {
      occassionCollectionView.registerCellFromNib(cellID: "SelectOccassionCollectionViewCell")
    }
  }
  
  var selectedIndex: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func continueDidTapped(_ sender: Any) {
    guard let _ = selectedIndex else {
      showAlert(msg: "Please select an occasion")
      return
    }
    let vc = EnterCardsDetailsViewController.instantiate(fromAppStoryboard: .Profile)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension SelectOccassionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 9
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectOccassionCollectionViewCell", for: indexPath) as! SelectOccassionCollectionViewCell
    if selectedIndex == indexPath {
      cell.backgroundImageView.isHidden = false
      cell.titleLabel.textColor = .white
    } else {
      cell.backgroundImageView.isHidden = true
      cell.titleLabel.textColor = UIColor.darkBrown
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (collectionView.frame.width) / 3
      return CGSize(width: width, height: 38)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath
    occassionCollectionView.reloadData()
  }
  
}



