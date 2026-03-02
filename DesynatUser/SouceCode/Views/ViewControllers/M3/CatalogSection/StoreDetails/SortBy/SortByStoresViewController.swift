//
//  SortByStoresViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class SortByStoresViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sortTableview: UITableView! {
        didSet {
            sortTableview.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var selectedIndex: Int = 0
    private lazy var viewModel = SortByStoreViewModel(hostVC: self)
    var preSelectedApiValue: Int?
    var filtersOptions: [SortOptionModel] = []
    weak var delegate: SortByStoresViewControllerDelegate?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getSingleStoresApi()
        setupOptions()
    }
    
    // MARK: - Button's Action
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

// MARK: - TABLE VIEW METHODS
extension SortByStoresViewController: UITableViewDelegate, UITableViewDataSource {
    
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
