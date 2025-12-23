//
//  FilterVC.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit

class FilterVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var filterTableview: UITableView!
    
    var filtersOptions = ["All", "Ongoing", "Delivered", "Cancelled", "Return"]
    var selectedIndex: Int = 0
    weak var delegate: FilterDelegate?
    
    var selectedFilter: OrderFilterType {
        return OrderFilterType(rawValue: selectedIndex + 1) ?? .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        initialSetup()
    }
    
    func registerXib() {
        filterTableview.dataSource = self
        filterTableview.delegate = self
        filterTableview.register(UINib(nibName: "FiltersOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "FiltersOptionsTableViewCell")
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnClear(_ sender: Any) {
        selectedIndex = 0
        filterTableview.reloadData()
    }
    
    @IBAction func btnApply(_ sender: Any) {
        delegate?.didApplyFilter(selectedFilter)
        dismiss(animated: true)
    }
    
}

extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        let option = filtersOptions[indexPath.row]
        cell.titleLabel.text = option
        if selectedIndex == indexPath.row {
            cell.selectionImageView.image = UIImage(named: "radioSelected")
        } else {
            cell.selectionImageView.image = UIImage(named: "radioUnselected")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        filterTableview.reloadData()
        //self.dismiss(animated: true)
    }
    
    
}
