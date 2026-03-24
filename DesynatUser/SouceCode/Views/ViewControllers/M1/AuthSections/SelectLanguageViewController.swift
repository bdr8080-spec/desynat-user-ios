//
//  SelectLanguageViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 22/10/25.
//

import UIKit

class SelectLanguageViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var arabicView: CustomView!
    @IBOutlet weak var englishView: CustomView!
    @IBOutlet weak var imgArabic: UIImageView!
    @IBOutlet weak var imgEnglish: UIImageView!
    
    // MARK: - Property Decalaration
    private var selectedLanguage: String = "en"
    var comingFromDashboard: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    // MARK: - Button's Action
    @IBAction func btnSelectLanguage(_ sender: UIButton) {
        if sender.tag == 0 {
            // English selected
            selectedLanguage = "en"
            
            imgArabic.image = UIImage(named: "radioUnselected")
            imgEnglish.image = UIImage(named: "radioSelected")
            
            arabicView.layer.borderColor = UIColor.lightGray.cgColor
            englishView.layer.borderColor = UIColor(named: "darkBrown")?.cgColor
        } else {
            // Arabic selected
            selectedLanguage = "ar"
            
            imgArabic.image = UIImage(named: "radioSelected")
            imgEnglish.image = UIImage(named: "radioUnselected")
            
            arabicView.layer.borderColor = UIColor(named: "darkBrown")?.cgColor
            englishView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func btnTapContinue(_ sender: Any) {
        UserDefaults.standard.setValue(selectedLanguage, forKey: "AppLanguage")
        UserDefaults.standard.setValue("true", forKey: "isAppInstall")
        let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

