//
//  SplashViewController.swift
//  DesynatUser
//
//  Created by Mohd Faizan on 01/11/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline:.now() + 5.0){
            let vc = SelectLanguageViewController.instantiate(fromAppStoryboard:.Main)
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
}
