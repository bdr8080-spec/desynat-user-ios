//
//  CatalogViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class CatalogViewController: UIViewController {

    @IBOutlet weak var catalogTableView: UITableView! {
        didSet {
            catalogTableView.registerCellFromNib(cellID: "CatalogTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    



}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        if indexPath.row % 2 == 0 {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.mainContentView.layer.borderColor = UIColor.systemGray5.cgColor
        } else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.mainContentView.layer.borderColor = UIColor(named: "darkBrown")?.withAlphaComponent(0.5).cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = SubCatgoryViewController.instantiate(fromAppStoryboard: .Catalog)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

