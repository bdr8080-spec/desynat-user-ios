//
//  CatalogViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class CatalogViewController: UIViewController {
    
      // MARK: - IBOutlet's
    @IBOutlet weak var catalogTableView: UITableView! {
        didSet {
            catalogTableView.registerCellFromNib(cellID: "CatalogTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = CatalogViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCategoriesListApi()
    }
}

// MARK: - TABLE VIEW METHODS
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        cell.configData(data: viewModel.categoriesSection[indexPath.row])
        if indexPath.row % 2 == 0 {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.mainContentView.layer.borderColor = UIColor.systemGray5.cgColor
        } else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.mainContentView.layer.borderColor = UIColor(named: "darkBrown")?.withAlphaComponent(0.5).cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = SubCatgoryViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.categoryId = viewModel.categoriesSection[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

