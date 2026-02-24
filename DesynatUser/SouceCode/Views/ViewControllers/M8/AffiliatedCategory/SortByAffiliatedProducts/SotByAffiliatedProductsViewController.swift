//
//  SotByAffiliatedProductsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import UIKit

class SotByAffiliatedProductsViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sortTableview: UITableView! {
        didSet {
            sortTableview.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    
    private lazy var viewModel = SortByAffiliatedProductsViewModel(hostVC: self)
    weak var delegate: SortByStoresViewControllerDelegate?
    var preSelectedApiValue: Int?
    var selectedIndex: Int = 0
    var filtersOptions: [SortOptionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getSortListOfAffilatedProductsApi()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32   // Your desired value
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    func setupOptions() {
        guard let selectedApi = preSelectedApiValue,
              let storeList = viewModel.sortedStoreList,
              let index = storeList.firstIndex(where: { $0.id == selectedApi }) else {
            sortTableview.reloadData()
            return
        }
        selectedIndex = index
        sortTableview.reloadData()
    }
}

// MARK: - TableView Delegate & DataSource
extension SotByAffiliatedProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedStoreList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = viewModel.sortedStoreList?[indexPath.row]
        cell.titleLabel.text = option?.name
        if selectedIndex == indexPath.row {
            cell.selectionImageView.image = UIImage(named: "radioSelected")
        } else {
            cell.selectionImageView.image = UIImage(named: "radioUnselected")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        sortTableview.reloadData()
        delegate?.didSelectSortOption(viewModel.sortedStoreList?[indexPath.row].id ?? 0)
        self.dismiss(animated: true)
    }
    
}

