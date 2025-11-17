//
//  SortByStoresViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class SortByStoresViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sortTableview: UITableView! {
        didSet {
            sortTableview.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    
    var filtersOptions: [StoreFilterOption] = [
        StoreFilterOption(id: 0, title: "Recommended", isSelected: true, apiParcing: "recommended", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
        StoreFilterOption(id: 0, title: "Price: Low to High", isSelected: false, apiParcing: "lowToHigh", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
        StoreFilterOption(id: 0, title: "Price: High to Low", isSelected: false, apiParcing: "highToLow", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
        StoreFilterOption(id: 0, title: "Newest First", isSelected: false, apiParcing: "newestFirst", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
        StoreFilterOption(id: 0, title: "Customer Ratings", isSelected: false, apiParcing: "customerRatings", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
        StoreFilterOption(id: 0, title: "Best Selling", isSelected: false, apiParcing: "bestSelling", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
        StoreFilterOption(id: 0, title: "Fastest Delivery", isSelected: false, apiParcing: "fastest", seletedImage: "radioSelected", unselectedImage: "radioUnselected"),
    ]
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32   // Your desired value
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
    
}

// MARK: - TableView Delegate & DataSource
extension SortByStoresViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = filtersOptions[indexPath.row]
        cell.configure(option: option)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 1. First, reset all selections
        for i in 0..<filtersOptions.count {
            filtersOptions[i].isSelected = false
        }
        
        // 2. Then update the selected option
        filtersOptions[indexPath.row].isSelected = true
        selectedIndex = indexPath.row
        
        // 3. Reload table to update UI
        tableView.reloadData()

        // 4. (Optional) Send back selected API value
        print("Selected Sort: \(filtersOptions[indexPath.row].apiParcing)")
    }

}
