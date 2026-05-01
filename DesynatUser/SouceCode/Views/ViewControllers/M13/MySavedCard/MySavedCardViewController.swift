//
//  MySavedCardViewController.swift
//  DesynatUser
//
//  Created by  shailendra singh on 17/04/26.
//

import UIKit

class MySavedCardViewController: UIViewController {
    
    @IBOutlet weak var savedTableView: UITableView!{
        didSet{
            savedTableView.registerCellFromNib(cellID: "SavedCardTableViewCell")
        }
    }
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    private lazy var viewModel = MySavedCardViewModel(hostVC: self)
    var onCardSelected: ((SavedCardsDataModel?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMySavedCardsRequest()
    }
    
    
    // MARK: - Navigation
    
    @IBAction func addNewCardDidTapped(_ sender: Any) {
        let nextVC = AddCardViewController.instantiate(fromAppStoryboard: .MyBag)
        nextVC.comingReason = .savedCard
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MySavedCardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedCardsDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardTableViewCell", for: indexPath) as! SavedCardTableViewCell
        let data = viewModel.savedCardsDetails?[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configData(data: data)
        return cell
    }
}

extension MySavedCardViewController: HandleCardInteraction {
    func deleteDidTapped(indexPath: IndexPath) {
        let card = viewModel.savedCardsDetails?[indexPath.row]
        let id = card?.id ?? 0
        self.showConfirmationAlert(msg: "Are you sure you want to delete this card?".localiz()) { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteCardAPI(cardId: id) { success in
                if success {
                    self.viewModel.savedCardsDetails?.remove(at: indexPath.row)
                    self.savedTableView.beginUpdates()
                    self.savedTableView.deleteRows(at: [indexPath], with: .left)
                    self.savedTableView.endUpdates()
                    self.noDataFoundLabel.isHidden = !(self.viewModel.savedCardsDetails?.isEmpty ?? true)
                } else {
                    self.showAlert(msg: "Failed to delete address. Try again.".localiz())
                }
            }
        }
    }
    
    func makeItDefault(indexPath: IndexPath) {
        let selectedCard = viewModel.savedCardsDetails?[indexPath.row]
        let selectedCardID = selectedCard?.id ?? 0
        viewModel.makeDefaultCardAPI(cardID: selectedCardID) { [weak self] success in
            guard let self = self else { return }
            guard let data = self.viewModel.savedCardsDetails else { return }
            if success {
                for i in 0..<data.count {
                    self.viewModel.savedCardsDetails?[i].isFuture = (i == indexPath.row) ? 1 : 0
                }
                onCardSelected?(selectedCard)
                self.savedTableView.reloadData()
            } else {
                self.showAlert(msg: "Failed to set default card".localiz())
            }
        }
    }

}


