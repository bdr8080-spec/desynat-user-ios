//
//  SubCatgoryViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import Speech
import AVFoundation

class SubCatgoryViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var subCatgeoryTableView: UICollectionView! {
        didSet {
            subCatgeoryTableView.registerCellFromNib(cellID: "SubCatgoryCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var categoryId: Int? = 0
    private lazy var viewModel = SubCategoryViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSubCategoriesListApi(categoryID: categoryId ?? 0)
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Mic Button – This is what you wanted!
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.filterSubCategories(with: searchText)
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func storyDidTapped(_ sender: Any) {
        let nextVC = StoryViewerViewController.instantiate(fromAppStoryboard: .Home)
        nextVC.comingFor = .forAdminStory
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    //MARK: Function's declaration
    @objc private func searchTextChanged(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.filterSubCategories(with: text)
    }
}

// MARK: - COLLECTION VIEW METHODS
extension SubCatgoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.subCategoriesSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCatgoryCollectionViewCell", for: indexPath) as! SubCatgoryCollectionViewCell
        let data = viewModel.subCategoriesSection[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = StoresViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.slectedsubCategoryId = viewModel.subCategoriesSection[indexPath.row].id ?? 0
        nextVC.slecetedCategoryID = categoryId ?? 0
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 215)
    }
}
