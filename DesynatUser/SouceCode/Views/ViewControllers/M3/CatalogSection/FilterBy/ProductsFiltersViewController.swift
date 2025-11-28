//
//  ProductsFiltersViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class ProductsFiltersViewController: UIViewController {

    @IBOutlet weak var filtersTableView: UITableView!

    // --- SELECTED FILTERS ---
    var selectedCategoryIDs: [String] = []
    var selectedBrandIDs: [String] = []
    var selectedColorIDs: [String] = []
    var selectedSizeIDs: [String] = []
    var selectedDiscountIDs: [String] = []
    var selectedMinPrice: Int?
    var selectedMaxPrice: Int?

    // Callback to send data back
    var onApplyFilters: (([String], [String], [String], [String], [String], Int?, Int?) -> Void)?

    // MARK: - FILTER SECTIONS
    var filtersOptions: [ProductFilterSection] = [
        ProductFilterSection(header: "Category", description: "", options: []),
        ProductFilterSection(header: "Brand", description: "A-Z", options: []),
        ProductFilterSection(header: "Price", description: "", options: []),
        ProductFilterSection(header: "Color", description: "", options: []),
        ProductFilterSection(header: "Discount Range", description: "", options: [
            ProductFilterOption(title: "10%", isSelected: false, apiParcing: "10", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "20%", isSelected: false, apiParcing: "20", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "30%", isSelected: false, apiParcing: "30", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "40%", isSelected: false, apiParcing: "40", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "50%", isSelected: false, apiParcing: "50", havingColourCode: false, colourCode: "")
        ]),
        ProductFilterSection(header: "Sizes", description: "", options: []),
        ProductFilterSection(header: "Ratings", description: "", options: [
            ProductFilterOption(title: "1 Star", isSelected: false, apiParcing: "1", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "2 Star", isSelected: false, apiParcing: "2", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "3 Star", isSelected: false, apiParcing: "3", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "4 Star", isSelected: false, apiParcing: "4", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "5 Star", isSelected: false, apiParcing: "5", havingColourCode: false, colourCode: "")
        ]),
        ProductFilterSection(header: "Delivery Time", description: "", options: [
            ProductFilterOption(title: "Today - 2 days", isSelected: false, apiParcing: "1", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "3 - 5 days", isSelected: false, apiParcing: "2", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "6 - 12 days", isSelected: false, apiParcing: "3", havingColourCode: false, colourCode: "")
        ]),
    ]

    private lazy var viewModel = ProductsFiltersViewModel(hostVC: self)

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        callDynamicFilterAPIs()
    }

    // MARK: - API CALLS
    private func callDynamicFilterAPIs() {
        viewModel.getAllCategory { [weak self] in self?.prepareCategorySection() }
        viewModel.getAllBrands { [weak self] in self?.prepareBrandSection() }
        viewModel.getAllColors { [weak self] in self?.prepareColorSection() }
        viewModel.getAllSize { [weak self] in self?.prepareSizeSection() }
    }

  func prepareCategorySection() {
      let options = viewModel.getAllCategoriesList.map {
          ProductFilterOption(
              title: $0.name ?? "",
              isSelected: selectedCategoryIDs.contains("\($0.id ?? 0)"), // ✅ important
              apiParcing: "\($0.id ?? 0)",
              havingColourCode: false,
              colourCode: ""
          )
      }
      filtersOptions[0].options = options
      filtersTableView.reloadSections(IndexSet(integer: 0), with: .none)
  }

  func prepareBrandSection() {
      let options = viewModel.getAllBrandsList.map {
          ProductFilterOption(
              title: $0.nameEnglish ?? "",
              isSelected: selectedBrandIDs.contains("\($0.id ?? 0)"), // ✅ important
              apiParcing: "\($0.id ?? 0)",
              havingColourCode: false,
              colourCode: ""
          )
      }
      filtersOptions[1].options = options
      filtersTableView.reloadSections(IndexSet(integer: 1), with: .none)
  }

  func prepareColorSection() {
      let options = viewModel.getAllColorsList.map {
          ProductFilterOption(
              title: $0.name ?? "",
              isSelected: selectedColorIDs.contains("\($0.id ?? 0)"), // ✅ important
              apiParcing: "\($0.id ?? 0)",
              havingColourCode: true,
              colourCode: $0.hexCode ?? "#000000"
          )
      }
      filtersOptions[3].options = options
      filtersTableView.reloadSections(IndexSet(integer: 3), with: .none)
  }

  func prepareSizeSection() {
      let options = viewModel.getAllSizesList.map {
          ProductFilterOption(
              title: $0.name ?? "",
              isSelected: selectedSizeIDs.contains("\($0.id ?? 0)"), // ✅ important
              apiParcing: "\($0.id ?? 0)",
              havingColourCode: false,
              colourCode: ""
          )
      }
      filtersOptions[5].options = options
      filtersTableView.reloadSections(IndexSet(integer: 5), with: .none)
  }


    // MARK: - ACTIONS
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func applydidTapped(_ sender: Any) {
        onApplyFilters?(
            selectedCategoryIDs,
            selectedBrandIDs,
            selectedColorIDs,
            selectedSizeIDs,
            selectedDiscountIDs,
            selectedMinPrice,
            selectedMaxPrice
        )
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clearDidTapped(_ sender: Any) {
        selectedCategoryIDs.removeAll()
        selectedBrandIDs.removeAll()
        selectedColorIDs.removeAll()
        selectedSizeIDs.removeAll()
        selectedDiscountIDs.removeAll()
        selectedMinPrice = nil
        selectedMaxPrice = nil

        // Reset all options
        for sectionIndex in filtersOptions.indices {
            for optionIndex in filtersOptions[sectionIndex].options.indices {
                filtersOptions[sectionIndex].options[optionIndex].isSelected = false
            }
        }

        filtersTableView.reloadData()
      onApplyFilters?(
              selectedCategoryIDs,
              selectedBrandIDs,
              selectedColorIDs,
              selectedSizeIDs,
              selectedDiscountIDs,
              selectedMinPrice,
              selectedMaxPrice
          )
      self.navigationController?.popViewController(animated: true)
    }

    // MARK: - TABLE REGISTRATION
    func registerXib() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        filtersTableView.registerCellFromNib(cellID: "PriceRangeSliderTableViewCell")
        filtersTableView.register(FilterHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "FiltersHeaderTableViewCell")
        filtersTableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - TABLE VIEW METHODS
extension ProductsFiltersViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersOptions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtersOptions[section].header == "Price" { return 1 }
        return filtersOptions[section].options.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = Bundle.main.loadNibNamed("FilterHeaderTableViewCell", owner: self, options: nil)?.first as? FilterHeaderTableViewCell else { return nil }
        headerCell.titlelabel.text = filtersOptions[section].header
        headerCell.decriptionLabel.isHidden = filtersOptions[section].description.isEmpty
        headerCell.decriptionLabel.text = filtersOptions[section].description
        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if filtersOptions[indexPath.section].header == "Price" {
          let cell = tableView.dequeueReusableCell(withIdentifier: "PriceRangeSliderTableViewCell", for: indexPath) as! PriceRangeSliderTableViewCell

          // Preselect previously chosen values
          cell.minPrice = selectedMinPrice ?? 0
          cell.maxPrice = selectedMaxPrice ?? 10000

          cell.onPriceChanged = { [weak self] min, max in
              guard let self = self else { return }
              self.selectedMinPrice = min
              self.selectedMaxPrice = max
          }

          return cell
      }



        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = filtersOptions[indexPath.section].options[indexPath.row]
        cell.configureProductFilter(option: option)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = indexPath.section
        let sectionName = filtersOptions[section].header

        if sectionName == "Price" { return }

        // Toggle selection
        filtersOptions[section].options[indexPath.row].isSelected.toggle()
        let isSelected = filtersOptions[section].options[indexPath.row].isSelected
        let option = filtersOptions[section].options[indexPath.row]

        switch sectionName {
        case "Category":
                // Single selection: deselect all first
                for i in 0..<filtersOptions[section].options.count {
                    filtersOptions[section].options[i].isSelected = false
                }

                // Select the tapped option if it was not selected
                filtersOptions[section].options[indexPath.row].isSelected = true
                selectedCategoryIDs = [option.apiParcing]

        case "Brand":
            if isSelected {
                selectedBrandIDs.append(option.apiParcing)
            } else {
                selectedBrandIDs.removeAll { $0 == option.apiParcing }
            }

        case "Color":
            if isSelected {
                selectedColorIDs.append(option.apiParcing)
            } else {
                selectedColorIDs.removeAll { $0 == option.apiParcing }
            }

        case "Sizes":
            if isSelected {
                selectedSizeIDs.append(option.apiParcing)
            } else {
                selectedSizeIDs.removeAll { $0 == option.apiParcing }
            }

        case "Discount Range":
            if isSelected {
                selectedDiscountIDs.append(option.apiParcing)
            } else {
                selectedDiscountIDs.removeAll { $0 == option.apiParcing }
            }

        default:
            break
        }

        tableView.reloadSections(IndexSet(integer: section), with: .none)
    }
}
