//
//  AffiliatedProductsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit
import Speech

class AffiliatedProductsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.registerCellFromNib(cellID: "AffiliatedProductsCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedProductsViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var categoryId: Int = 0
    var subCatrgoryId: Int = 0
    var comingReasonAtAllProducts: ComingReasonAtAllProducts? = .fromCategory
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        searchTF.text = viewModel.searchText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resetAndFetchProducts()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        switch comingReasonAtAllProducts {
        case .fromCategory:
            self.navigationController?.popViewController(animated: true)
        default:
            self.navigationController?.popToViewController(ofType: AffiliatedCategorySearchViewController.self)
        }
    }
    
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                nextVC.onSearchedCompletionTxt = { [weak self] searchText in
                    self?.searchTF.text = searchText
                    self?.viewModel.searchText = searchText
                    self?.viewModel.resetAndFetchProducts() // live search as user speaks
                }
                self.navigationController?.present(nextVC, animated: true)

    }
}

// MARK: - COLLECTION VIEW METHODS
extension AffiliatedProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AffiliatedProductsCollectionViewCell", for: indexPath) as! AffiliatedProductsCollectionViewCell
        let data = viewModel.productDetails[indexPath.row]
        cell.configData(data: data)
        cell.onGetLinkTapped = { [weak self] in
            self?.viewModel.generateProductLink(productId: data.id ?? 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 295)
    }
}

extension AffiliatedProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == productsCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 50 {
            viewModel.getAllProducts()
        }
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AffiliatedProductsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.resetAndFetchProducts()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

enum ComingReasonAtAllProducts {
    case fromCategory
}
