//
//  SelectOccassionViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import SDWebImage

class SelectOccassionViewController: UIViewController {
  
  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
  @IBOutlet weak var occassionCollectionView: UICollectionView! {
    didSet {
      occassionCollectionView.registerCellFromNib(cellID: "SelectOccassionCollectionViewCell")
    }
  }
  
  var selectedIndex: Int?
  private lazy var viewModel = SelectOccassionViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getAllGiftsCardsOccassion()
  }
  
  func updateCollectionViewHeight() {
      self.occassionCollectionView.layoutIfNeeded()
      self.heightOfCollectionView.constant = self.occassionCollectionView.contentSize.height
  }
  
  @IBAction func continueDidTapped(_ sender: Any) {
    guard let _ = selectedIndex else {
      showAlert(msg: "Please select an occasion")
      return
    }
    let vc = EnterCardsDetailsViewController.instantiate(fromAppStoryboard: .Profile)
    vc.selectedOccassionId = selectedIndex ?? 0
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func populateData(imageUrl: String?) {
    if let imageUrlString = imageUrl,
       let url = URL(string: imageUrlString) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    }
  }
  
}

extension SelectOccassionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.occassionsList?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectOccassionCollectionViewCell", for: indexPath) as! SelectOccassionCollectionViewCell
    let data = viewModel.occassionsList?[indexPath.row]
    cell.titleLabel.text = data?.nameEnglish ?? ""
    if selectedIndex == data?.id {
      cell.backgroundImageView.isHidden = false
      cell.titleLabel.textColor = .white
      populateData(imageUrl: data?.image)
    } else {
      cell.backgroundImageView.isHidden = true
      cell.titleLabel.textColor = UIColor.darkBrown
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (occassionCollectionView.frame.width - 12) / 3
    let height: CGFloat = 38
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = viewModel.occassionsList?[indexPath.row].id
    occassionCollectionView.reloadData()
  }
  
}
