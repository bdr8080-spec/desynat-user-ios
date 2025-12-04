//
//  AddCardViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class AddCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
