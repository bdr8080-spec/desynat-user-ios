//
//  FAQViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class FAQViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.delegate = self
            listTableView.dataSource = self
            listTableView.registerCellFromNib(cellID: "FAQTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var selecetdIndex = -1
    private lazy var viewModel = FAQViewModel(hostVC: self)
    var selectedUserType = 1
    var comingUserRole: UserRoleType = .normalUser
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFAQRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
}

// MARK: - TABLE VIEW METHODS
extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.faqListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        if selecetdIndex == indexPath.row {
            cell.descriptionView.isHidden = false
            cell.vectorImageView.image = .upwardVector
        } else {
            cell.descriptionView.isHidden = true
            cell.vectorImageView.image = .downVector
        }
        let data = viewModel.faqListData?[indexPath.row]
        cell.configData(data: data, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selecetdIndex == indexPath.row {
            selecetdIndex = -1
        } else {
            selecetdIndex = indexPath.row
        }
        listTableView.reloadData()
    }
    
}

enum UserRoleType {
    case normalUser
    case affilaiteUser
}
