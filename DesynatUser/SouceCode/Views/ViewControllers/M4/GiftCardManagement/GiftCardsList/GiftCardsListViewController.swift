//
//  GiftCardsListViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class GiftCardsListViewController: UIViewController {

  @IBOutlet weak var noDataLabel: UILabel!
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.registerCellFromNib(cellID: "GiftCardsListTableViewCell")
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    noDataLabel.isHidden = true
    }
    
  @IBAction func plusDidTapped(_ sender: Any) {
    let vc = SelectOccassionViewController.instantiate(fromAppStoryboard: .Profile)
    self.navigationController?.pushViewController(vc, animated: false)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension GiftCardsListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardsListTableViewCell", for: indexPath) as! GiftCardsListTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = AddedCardDetailsViewController.instantiate(fromAppStoryboard: .Profile)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}
