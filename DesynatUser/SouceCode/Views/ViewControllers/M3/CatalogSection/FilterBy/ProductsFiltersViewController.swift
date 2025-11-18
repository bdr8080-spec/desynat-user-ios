//
//  ProductsFiltersViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class ProductsFiltersViewController: UIViewController {

    @IBOutlet weak var filtersTableView: UITableView!
    
    var filtersOptions: [ProductFilterSection] = [
        ProductFilterSection(header: "Category", description: "", options: [
            ProductFilterOption(title: "Women", isSelected: false, apiParcing: "Women", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Men", isSelected: false, apiParcing: "Men", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Kids", isSelected: false, apiParcing: "Kids", havingColourCode: false, colourCode: ""),
        ]),
        ProductFilterSection(header: "Brand", description: "A-Z", options: [
            ProductFilterOption(title: "Brand", isSelected: false, apiParcing: "Brand", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Brand", isSelected: false, apiParcing: "Brand", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Brand", isSelected: false, apiParcing: "Brand", havingColourCode: false, colourCode: ""),
        ]),
        ProductFilterSection(header: "Price", description: "", options: []),
        ProductFilterSection(header: "Color", description: "", options: [
            ProductFilterOption(title: "Color", isSelected: false, apiParcing: "Color", havingColourCode: true, colourCode: "#9B5DE5"),
            ProductFilterOption(title: "Color", isSelected: false, apiParcing: "Color", havingColourCode: true, colourCode: "#FFA41B"),
            ProductFilterOption(title: "Color", isSelected: false, apiParcing: "Color", havingColourCode: true, colourCode: "#9B5DE5"),
            ProductFilterOption(title: "Color", isSelected: false, apiParcing: "Color", havingColourCode: true, colourCode: "#FFA41B"),
        ]),
        ProductFilterSection(header: "Discount Range", description: "", options: [
            ProductFilterOption(title: "10%", isSelected: false, apiParcing: "Discount", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "20%", isSelected: false, apiParcing: "Discount", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "30%", isSelected: false, apiParcing: "Discount", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "40%", isSelected: false, apiParcing: "Discount", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "50%", isSelected: false, apiParcing: "Discount", havingColourCode: false, colourCode: ""),
        ]),
        ProductFilterSection(header: "Sizes", description: "", options: [
            ProductFilterOption(title: "Size 1", isSelected: false, apiParcing: "Sizes", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Size 2", isSelected: false, apiParcing: "Sizes", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Size 3", isSelected: false, apiParcing: "Sizes", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Size 4", isSelected: false, apiParcing: "Sizes", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "Size 5", isSelected: false, apiParcing: "Sizes", havingColourCode: false, colourCode: ""),
        ]),
        ProductFilterSection(header: "Ratings", description: "", options: [
            ProductFilterOption(title: "1 Star", isSelected: false, apiParcing: "Ratings", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "2 Star", isSelected: false, apiParcing: "Ratings", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "3 Star", isSelected: false, apiParcing: "Ratings", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "4 Star", isSelected: false, apiParcing: "Ratings", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "5 Star", isSelected: false, apiParcing: "Ratings", havingColourCode: false, colourCode: ""),
        ]),
        ProductFilterSection(header: "Delivery Time", description: "", options: [
            ProductFilterOption(title: "Today- 2 days", isSelected: false, apiParcing: "DeliveryTime", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "3- 5 days", isSelected: false, apiParcing: "DeliveryTime", havingColourCode: false, colourCode: ""),
            ProductFilterOption(title: "6- 12 days", isSelected: false, apiParcing: "DeliveryTime", havingColourCode: false, colourCode: ""),
        ]),
        
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
        filtersTableView.registerCellFromNib(cellID: "PriceRangeSliderTableViewCell")
        filtersTableView.register(FilterHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "FiltersHeaderTableViewCell")
        filtersTableView.estimatedRowHeight = 0
        filtersTableView.estimatedSectionHeaderHeight = 0
        filtersTableView.estimatedSectionFooterHeight = 0
        filtersTableView.showsVerticalScrollIndicator = false
    }

}

// MARK: - TableView Delegate & DataSource
extension ProductsFiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtersOptions[section].header == "Price" {
            return 1
        }
        return filtersOptions[section].options.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = Bundle.main.loadNibNamed("FilterHeaderTableViewCell", owner: self, options: nil)?.first as? FilterHeaderTableViewCell else {
            return nil
        }
        headerCell.titlelabel.text = filtersOptions[section].header
        let description = filtersOptions[section].description
        if !description.isEmpty {
            headerCell.decriptionLabel.isHidden = false
            headerCell.decriptionLabel.text = description
        } else {
            headerCell.decriptionLabel.isHidden = true
        }
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // ---- PRICE SLIDER SECTION ----
        if filtersOptions[indexPath.section].header == "Price" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceRangeSliderTableViewCell", for: indexPath) as! PriceRangeSliderTableViewCell
            
//            cell.onPriceChanged = { min, max in
//                print("Selected Price Range = \(min) - \(max)")
//            }
            return cell
        }

        // ---- OTHER FILTERS ----
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = filtersOptions[indexPath.section].options[indexPath.row]
        cell.configureProductFilter(option: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let sectionHeader = filtersOptions[indexPath.section].header

        // PRICE section → fixed height 50
        if sectionHeader == "Price" {
            return 60
        }

        // For all other sections → normal height
        return UITableView.automaticDimension
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filtersOptions[indexPath.section].header == "Price" { return }
        filtersOptions[indexPath.section].options[indexPath.row].isSelected.toggle()
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }

}

