//
//  StoresFiltersViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class StoresFiltersViewController: UIViewController {

    @IBOutlet weak var filtersTableView: UITableView!
    
    var filtersOptions: [StoreFilterSection] = [
        StoreFilterSection(header: "Ratings", options: [
            StoreFilterOption(id: 0, title: "Upto 2 Star", isSelected: false, apiParcing: "2", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 0, title: "Upto 3 Star", isSelected: false, apiParcing: "3", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 0, title: "Upto 4 Star", isSelected: false, apiParcing: "4", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 0, title: "Upto 5 Star", isSelected: false, apiParcing: "5", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter")
        ]),
        StoreFilterSection(header: "Availability", options: [
            StoreFilterOption(id: 1, title: "Open", isSelected: false, apiParcing: "open", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
            StoreFilterOption(id: 2, title: "Busy", isSelected: false, apiParcing: "busy", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
            StoreFilterOption(id: 2, title: "Shortest Delivery time", isSelected: false, apiParcing: "shortest", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 2, title: "Highest Sale", isSelected: false, apiParcing: "highest", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerXib() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        filtersTableView.register(FilterHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "FiltersHeaderTableViewCell")
        filtersTableView.estimatedRowHeight = 0
        filtersTableView.estimatedSectionHeaderHeight = 0
        filtersTableView.estimatedSectionFooterHeight = 0
        filtersTableView.showsVerticalScrollIndicator = false
    }

}

// MARK: - TableView Delegate & DataSource
extension StoresFiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions[section].options.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = Bundle.main.loadNibNamed("FilterHeaderTableViewCell", owner: self, options: nil)?.first as? FilterHeaderTableViewCell else {
            return nil
        }
        headerCell.titlelabel.text = filtersOptions[section].header
        headerCell.decriptionLabel.isHidden = true
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = filtersOptions[indexPath.section].options[indexPath.row]
        cell.configure(option: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        // -------- SECTION 0: Ratings (Multiple Selections Allowed) --------
        if section == 0 {
            filtersOptions[section].options[row].isSelected.toggle()   // toggle selection
        }

        // -------- SECTION 1: Availability --------
        else if section == 1 {

            if row == 0 || row == 1 {
                // OPEN or BUSY → Radio behavior (single selection between them)

                // Unselect both radio items (index 0 & 1)
                filtersOptions[section].options[0].isSelected = false
                filtersOptions[section].options[1].isSelected = false

                // Select tapped radio
                filtersOptions[section].options[row].isSelected = true
            }
            else {
                // Shortest Delivery Time (row 2) or Highest Sale (row 3)
                // → multiple allowed (toggle)
                filtersOptions[section].options[row].isSelected.toggle()
            }
        }

        tableView.reloadSections(IndexSet(integer: section), with: .none)
    }


}
