//
//  AffiliatedCategoryFilterViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 26/02/26.
//

import UIKit

class AffiliatedCategoryFilterViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var buttonActionStackView: UIStackView!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedProductsFiltersViewModel(hostVC: self)
    private var isColorExpanded = false
    private let colorSectionIndex = 2
    private let defaultVisibleColorCount = 10
    var selectedBrandIDs: [String] = []
    var selectedColorIDs: [String] = []
    var selectedSizeIDs: [String] = []
    var selectedDiscountIDs: [String] = []
    var selectedRatings: [String] = []
    var selectedDeliveryTime: [String] = []
    var selectedMinPrice: Int?
    var selectedMaxPrice: Int?
    var onApplyFilters: (( [String], [String], [String], [String], Int?, Int?) -> Void)?
    
    // MARK: - FILTER SECTIONS
    var filtersOptions: [ProductFilterSection] = [
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
            ProductFilterOption(title: "Today - 2 days", isSelected: false, apiParcing: "2", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "3 - 5 days", isSelected: false, apiParcing: "3", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "6 - 12 days", isSelected: false, apiParcing: "6", havingColourCode: false, colourCode: "")
        ])
    ]
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        callDynamicFilterAPIs()
        buttonActionStackView.semanticContentAttribute = .forceLeftToRight
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applydidTapped(_ sender: Any) {
        onApplyFilters?(
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
            selectedBrandIDs,
            selectedColorIDs,
            selectedSizeIDs,
            selectedDiscountIDs,
            selectedMinPrice,
            selectedMaxPrice
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
    func registerXib() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        filtersTableView.registerCellFromNib(cellID: "PriceRangeSliderTableViewCell")
        filtersTableView.register(FilterHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "FiltersHeaderTableViewCell")
        filtersTableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - API CALLS
    private func callDynamicFilterAPIs() {
        viewModel.getAllBrands { [weak self] in self?.prepareBrandSection() }
        viewModel.getAllColors { [weak self] in self?.prepareColorSection() }
        viewModel.getAllSize { [weak self] in self?.prepareSizeSection() }
        applyPreselectedDiscount()
    }
    
    func prepareBrandSection() {
        let options = viewModel.getAllBrandsList.map {
            ProductFilterOption(
                title: AppLanguageManager.shared.currentLanguage == .ar
                ? ($0.nameArabic ?? $0.nameEnglish ?? "")
                : ($0.nameEnglish ?? ""),
                isSelected: selectedBrandIDs.contains("\($0.id ?? 0)"), // important
                apiParcing: "\($0.id ?? 0)",
                havingColourCode: false,
                colourCode: ""
            )
        }
        filtersOptions[0].options = options
        filtersTableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func prepareColorSection() {
        let options = viewModel.getAllColorsList.map {
            ProductFilterOption(
                title: AppLanguageManager.shared.currentLanguage == .ar
                ? ($0.nameAr ?? $0.name ?? "")
                : ($0.name ?? ""),
                isSelected: selectedColorIDs.contains("\($0.id ?? 0)"), // important
                apiParcing: "\($0.id ?? 0)",
                havingColourCode: true,
                colourCode: $0.hexCode ?? "#000000"
            )
        }
        filtersOptions[2].options = options
        filtersTableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
    
    func prepareSizeSection() {
        let options = viewModel.getAllSizesList.map {
            ProductFilterOption(
                title: AppLanguageManager.shared.currentLanguage == .ar
                ? ($0.nameAr ?? $0.name ?? "")
                : ($0.name ?? ""),
                isSelected: selectedSizeIDs.contains("\($0.id ?? 0)"), // important
                apiParcing: "\($0.id ?? 0)",
                havingColourCode: false,
                colourCode: ""
            )
        }
        filtersOptions[4].options = options
        filtersTableView.reloadSections(IndexSet(integer: 4), with: .none)
    }
    
    private func applyPreselectedDiscount() {
        guard let sectionIndex = filtersOptions.firstIndex(where: { $0.header == "Discount Range" }) else { return }
        
        for index in filtersOptions[sectionIndex].options.indices {
            let option = filtersOptions[sectionIndex].options[index]
            filtersOptions[sectionIndex].options[index].isSelected =
            selectedDiscountIDs.contains(option.apiParcing)
        }
        
        filtersTableView.reloadSections(IndexSet(integer: sectionIndex), with: .none)
    }
    
    
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedCategoryFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtersOptions[section].header == "Price" { return 1 }
        if section == colorSectionIndex {
            let totalColors = filtersOptions[section].options.count
            
            if totalColors <= defaultVisibleColorCount {
                return totalColors
            }
            
            return isColorExpanded
            ? totalColors + 1   // +1 for Show Less
            : defaultVisibleColorCount + 1 // +1 for Show More
        }
        return filtersOptions[section].options.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = Bundle.main.loadNibNamed("FilterHeaderTableViewCell", owner: self, options: nil)?.first as? FilterHeaderTableViewCell else { return nil }
        headerCell.titlelabel.text = filtersOptions[section].header.localiz()
        headerCell.decriptionLabel.isHidden = filtersOptions[section].description.isEmpty
        if AppLanguageManager.shared.currentLanguage == .en {
            headerCell.decriptionLabel.text = filtersOptions[section].description
        } else {
            headerCell.decriptionLabel.isHidden = true
        }
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
        // 👇 Special handling for Color section
        if indexPath.section == colorSectionIndex {
            
            let totalColors = filtersOptions[indexPath.section].options.count
            
            // SHOW MORE / LESS CELL
            if totalColors > defaultVisibleColorCount {
                
                if (!isColorExpanded && indexPath.row == defaultVisibleColorCount) ||
                    (isColorExpanded && indexPath.row == totalColors) {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
                    
                    let title = isColorExpanded ? "Show Less".localiz() : "Show More".localiz()
                    
                    let showMoreOption = ProductFilterOption(
                        title: title,
                        isSelected: false,
                        apiParcing: "",
                        havingColourCode: false,
                        colourCode: ""
                    )
                    
                    cell.configureProductFilter(option: showMoreOption, sectionName: filtersOptions[indexPath.section].header)
                    
                    return cell
                }
            }
            
            let visibleOptions = isColorExpanded
            ? filtersOptions[indexPath.section].options
            : Array(filtersOptions[indexPath.section].options.prefix(defaultVisibleColorCount))
            
            let option = visibleOptions[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
            cell.configureProductFilter(option: option, sectionName: filtersOptions[indexPath.section].header)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = filtersOptions[indexPath.section].options[indexPath.row]
        cell.configureProductFilter(option: option, sectionName: filtersOptions[indexPath.section].header)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let sectionName = filtersOptions[section].header
        
        if sectionName == "Price" {
            return 75
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let sectionName = filtersOptions[section].header
        
        if sectionName == "Price" { return }
        // 👇 Handle Show More / Less tap
        if section == colorSectionIndex {
            
            let totalColors = filtersOptions[section].options.count
            
            if totalColors > defaultVisibleColorCount {
                
                if (!isColorExpanded && indexPath.row == defaultVisibleColorCount) ||
                    (isColorExpanded && indexPath.row == totalColors) {
                    
                    isColorExpanded.toggle()
                    tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    return
                }
            }
            
            let actualIndex = isColorExpanded
            ? indexPath.row
            : indexPath.row
            
            filtersOptions[section].options[actualIndex].isSelected.toggle()
            let option = filtersOptions[section].options[actualIndex]
            
            if filtersOptions[section].options[actualIndex].isSelected {
                selectedColorIDs.append(option.apiParcing)
            } else {
                selectedColorIDs.removeAll { $0 == option.apiParcing }
            }
            
            tableView.reloadSections(IndexSet(integer: section), with: .none)
            return
        }
        // Toggle selection
        filtersOptions[section].options[indexPath.row].isSelected.toggle()
        let isSelected = filtersOptions[section].options[indexPath.row].isSelected
        let option = filtersOptions[section].options[indexPath.row]
        
        switch sectionName {
            
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
                // Clear previous selection
                filtersOptions[section].options.indices.forEach {
                    filtersOptions[section].options[$0].isSelected = false
                }
                selectedSizeIDs.removeAll()
                
                // Select current
                filtersOptions[section].options[indexPath.row].isSelected = true
                selectedSizeIDs = [option.apiParcing]
            } else {
                // If tapping already selected → remove selection
                selectedSizeIDs.removeAll()
            }
            
        case "Discount Range":
            if isSelected {
                // Clear previous selection
                filtersOptions[section].options.indices.forEach {
                    filtersOptions[section].options[$0].isSelected = false
                }
                selectedDiscountIDs.removeAll()
                
                // Select current
                filtersOptions[section].options[indexPath.row].isSelected = true
                selectedDiscountIDs = [option.apiParcing]
            } else {
                // If tapping already selected → remove selection
                selectedDiscountIDs.removeAll()
            }
            
        default:
            break
        }
        
        tableView.reloadSections(IndexSet(integer: section), with: .none)
    }
}
