//
//  GiftCardsListViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class GiftCardsListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: "GiftCardsListTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = GiftCardsListViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.isHidden = true
        searchTF.delegate = self
        viewModel.getAllGiftsCards()
    }
    
    // MARK: - Button's Action
    @IBAction func plusDidTapped(_ sender: Any) {
        let vc = SelectOccassionViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension GiftCardsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.giftsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardsListTableViewCell", for: indexPath) as! GiftCardsListTableViewCell
        let data = viewModel.giftsList?[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = AddedCardDetailsViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.giftCardDetails = viewModel.giftsList?[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: UITextFieldDelegate Methods
extension GiftCardsListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllGiftsCards()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
    
}
