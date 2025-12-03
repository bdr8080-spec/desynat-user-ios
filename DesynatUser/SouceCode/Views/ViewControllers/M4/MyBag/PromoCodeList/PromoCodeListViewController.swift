//
//  PromoCodeListViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import CoreFoundation
import UIKit

class PromoCodeListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.registerCellFromNib(cellID: "PromoCodeTableViewCell")
        }
    }

    var expandedRows = Set<Int>()
  var onPromoSelected: ((String) -> Void)?
    let promoTexts = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "Another long promo text for testing the read more option that spans multiple lines.A very long promo text that needs to show more button when more than 3 lines appear in the label.A very long promo text that needs to show more button when more than 3 lines appear in the label.",
        "Short text.",
        "A very long promo text that needs to show more button when more than 3 lines appear in the label.A very long promo text that needs to show more button when more than 3 lines appear in the label."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      tableview.visibleCells.forEach { cell in
          (cell as? PromoCodeTableViewCell)?.setNeedsLayout()
      }
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    self.onPromoSelected?("PROMO10")
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension PromoCodeListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoTexts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PromoCodeTableViewCell", for: indexPath) as! PromoCodeTableViewCell

        let isExpanded = expandedRows.contains(indexPath.row)
        cell.configure(text: promoTexts[indexPath.row], expanded: isExpanded)

        cell.onExpansionChanged = { [weak self] in
            guard let self = self else { return }
            if isExpanded {
                self.expandedRows.remove(indexPath.row)
            } else {
                self.expandedRows.insert(indexPath.row)
            }
            self.tableview.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


