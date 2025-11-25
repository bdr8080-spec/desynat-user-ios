//
//  StoresViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class StoresViewController: UIViewController {
    
  @IBOutlet weak var noResultFoundLabel: UILabel!
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var storesCollectionViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var bannerPageController: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView! {
        didSet {
            bannerCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
        }
    }
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "StoresCollectionViewCell")
        }
    }
  
  var slectedsubCategoryId: Int? = 0
  private lazy var viewModel = StoreViewModel(hostVC: self)
  var appliedRatings: [String] = []
     var appliedAvailability: String = ""
     var appliedShortest: Bool = false
     var appliedHighest: Bool = false
  private var searchWorkItem: DispatchWorkItem?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.layer.cornerRadius = 12
      searchTF.delegate = self
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getStoresListApi()
  }
    
  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      updateCollectionsHeight()
  }

    @IBAction func filterDidTapped(_ sender: Any) {
      let nextVC = StoresFiltersViewController.instantiate(fromAppStoryboard: .Catalog)

          // Pass previous selections
          nextVC.selectedRatings = appliedRatings
          nextVC.selectedAvailability = appliedAvailability
          nextVC.selectedShortest = appliedShortest
          nextVC.selectedHighest = appliedHighest

          // Closure callback
          nextVC.onFilterApplied = { [weak self] ratings, availability, shortest, highest in
              guard let self = self else { return }

              self.appliedRatings = ratings
              self.appliedAvailability = availability
              self.appliedShortest = shortest
              self.appliedHighest = highest

              self.viewModel.getStoresListApi()
          }

          navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func updateCollectionsHeight() {
        storesCollectionViewHeightConstriant.constant = storesCollectionView.contentSize.height
    }
}

extension StoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            return 5
        case storesCollectionView:
          return viewModel.storesSection.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case bannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
            cell.mainImageView.layer.cornerRadius = 0
            return cell
        case storesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresCollectionViewCell", for: indexPath) as! StoresCollectionViewCell
          let data = viewModel.storesSection[indexPath.row]
          cell.configData(data: data)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case bannerCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case storesCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
          return CGSize(width: width, height: 194)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = StoresDetailsViewController.instantiate(fromAppStoryboard: .Catalog)
      nextVC.storeId = viewModel.storesSection[indexPath.row].id
      let info = viewModel.storesSection[indexPath.row].sellerInformation
      nextVC.fullName = "\(info?.firstName ?? "") \(info?.lastName ?? "")"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == storesCollectionView {
//            viewWillLayoutSubviews()
//        }
//    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bannerCollectionView.frame.width))
            bannerPageController.currentPage = pageIndex
        }
    }
    
}

extension StoresViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      viewModel.getStoresListApi()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}
