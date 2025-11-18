//
//  MyBagViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class MyBagViewController: UIViewController {

    @IBOutlet weak var bagTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bagTableView: UITableView! {
        didSet {
            bagTableView.registerCellFromNib(cellID: "MyBagTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.bagTableViewHeightConstraint.constant = self.bagTableView.contentSize.height
        }
    }

}

extension MyBagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBagTableViewCell", for: indexPath) as! MyBagTableViewCell
        if indexPath.row == 1 {
            cell.shopMoreButtonOutlet.isHidden = false
            cell.borderLabel.isHidden = true
        } else{
            cell.shopMoreButtonOutlet.isHidden = true
            cell.borderLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}
