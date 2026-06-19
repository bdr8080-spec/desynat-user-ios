//
//  ChatFilterViewController.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import UIKit

class ChatFilterViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var filterTableView: UITableView! {
        didSet {
            filterTableView.registerCellFromNib(cellID: "ChatsFilterTableViewCell")
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonActionStackView: UIStackView!
    
    // MARK: - Property Decalaration
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedFilter = ChatsFilterModel()
    var onApplyFilter: ((ChatsFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    private var filtersOptions = ["All", "Waiting", "Quotation Received", "Quotation Accepted"]
    private var selectedIndex: Int = -1
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        applyPreselectedData()
        buttonActionStackView.semanticContentAttribute = .forceLeftToRight
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = ChatsFilterModel()
        filter.chatStatus = selectedIndex
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    private func applyPreselectedData() {
        selectedIndex = selectedFilter.chatStatus ?? -1
    }
    
}

// MARK: - TABLE VIEW METHODS
extension ChatFilterViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsFilterTableViewCell", for: indexPath) as! ChatsFilterTableViewCell
        cell.titleLabel.text = filtersOptions[indexPath.row].localiz()
        if selectedIndex == indexPath.row {
            cell.mainImageView.image = .selectedFilterCheckBox
        } else {
            cell.mainImageView.image = .unslectedStoreFilter
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        filterTableView.reloadData()
    }
}

struct ChatsFilterModel {
    var chatStatus: Int?
    
    var isEmpty: Bool {
        return chatStatus == nil
    }
}
