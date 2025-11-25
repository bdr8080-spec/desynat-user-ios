//
//  StoresFiltersViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class StoresFiltersViewController: UIViewController {

    @IBOutlet weak var filtersTableView: UITableView!
    
    // MARK: - Closure Callback (same as your provided file)
    var onFilterApplied: ((_ ratings: [String], _ availability: String, _ shortest: Bool, _ highest: Bool) -> Void)?

    // MARK: - Pre-selected Values Coming from StoresViewController
    var selectedRatings: [String] = []
    var selectedAvailability = ""      // "1" or "0"
    var selectedShortest = false
    var selectedHighest = false

    // MARK: - Filter Data
    var filtersOptions: [StoreFilterSection] = [
        StoreFilterSection(header: "Ratings", options: []),
        StoreFilterSection(header: "Availability", options: [])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        prepareFilters()
    }

    // MARK: - Apply Button
    @IBAction func applyDidTapped(_ sender: Any) {

        let ratingIDs = filtersOptions[0].options
            .filter { $0.isSelected }
            .map { $0.apiParcing }

        let open = filtersOptions[1].options[0].isSelected
        let busy = filtersOptions[1].options[1].isSelected

        let availability = open ? "1" : (busy ? "0" : "")

        let shortest = filtersOptions[1].options[2].isSelected
        let highest = filtersOptions[1].options[3].isSelected

        onFilterApplied?(ratingIDs, availability, shortest, highest)

      self.navigationController?.popViewController(animated: true)
    }

    @IBAction func crossDidTapped(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Clear Button
    @IBAction func clearDidTapped(_ sender: Any) {

        selectedRatings.removeAll()
        selectedAvailability = ""
        selectedShortest = false
        selectedHighest = false

        prepareFilters()

        onFilterApplied?([], "", false, false)
      self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Build UI Filters List
    func prepareFilters() {

        // RATING OPTIONS
        let ratingOptions: [StoreFilterOption] = [
            StoreFilterOption(id: 0, title: "Upto 2 Star", isSelected: selectedRatings.contains("2"), apiParcing: "2", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 0, title: "Upto 3 Star", isSelected: selectedRatings.contains("3"), apiParcing: "3", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 0, title: "Upto 4 Star", isSelected: selectedRatings.contains("4"), apiParcing: "4", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 0, title: "Upto 5 Star", isSelected: selectedRatings.contains("5"), apiParcing: "5", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter")
        ]

        // AVAILABILITY OPTIONS
        let availabilityOptions: [StoreFilterOption] = [
            StoreFilterOption(id: 1, title: "Open", isSelected: selectedAvailability == "1", apiParcing: "1", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
            StoreFilterOption(id: 2, title: "Busy", isSelected: selectedAvailability == "0", apiParcing: "0", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
            StoreFilterOption(id: 3, title: "Shortest Delivery Time", isSelected: selectedShortest, apiParcing: "1", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter"),
            StoreFilterOption(id: 4, title: "Highest Sale", isSelected: selectedHighest, apiParcing: "1", seletedImage: "selectedFilterCheckBox", unselectedImage: "unslectedStoreFilter")
        ]

        filtersOptions = [
            StoreFilterSection(header: "Ratings", options: ratingOptions),
            StoreFilterSection(header: "Availability", options: availabilityOptions)
        ]

        filtersTableView.reloadData()
    }

    func registerXib() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self

        filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        
        filtersTableView.register(
            UINib(nibName: "FilterHeaderTableViewCell", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "FilterHeaderTableViewCell"
        )
        
        filtersTableView.estimatedRowHeight = 0
        filtersTableView.estimatedSectionHeaderHeight = 0
        filtersTableView.estimatedSectionFooterHeight = 0
        filtersTableView.showsVerticalScrollIndicator = false
    }
}


extension StoresFiltersViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersOptions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions[section].options.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderTableViewCell") as! FilterHeaderTableViewCell
        header.titlelabel.text = filtersOptions[section].header
        header.decriptionLabel.isHidden = true
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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

        if section == 0 {
            // Ratings: multiple selections allowed
            filtersOptions[section].options[row].isSelected.toggle()
        }
        else if section == 1 {
            // Open / Busy → single selection
            if row == 0 || row == 1 {
                filtersOptions[1].options[0].isSelected = false
                filtersOptions[1].options[1].isSelected = false
                filtersOptions[1].options[row].isSelected = true
            }
            else {
                // Shortest / Highest → multi select
                filtersOptions[1].options[row].isSelected.toggle()
            }
        }

        tableView.reloadSections(IndexSet(integer: section), with: .none)
    }
}
