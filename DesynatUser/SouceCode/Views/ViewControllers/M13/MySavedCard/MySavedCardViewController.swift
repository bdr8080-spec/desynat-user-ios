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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    @IBAction func addNewCardDidTapped(_ sender: Any) {
        
    }
    
}
extension MySavedCardViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardTableViewCell", for: indexPath) as! SavedCardTableViewCell
        return cell
    }
}
