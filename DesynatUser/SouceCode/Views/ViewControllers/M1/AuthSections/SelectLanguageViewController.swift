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
    var selectedLanguage: Languages = .en
    var comingFromDashboard: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        selectedLanguage = AppLanguageManager.shared.currentLanguage
        selectLanguage(isEnglishSelected: selectedLanguage != .ar)
    }
    
    // MARK: - Button's Action
    @IBAction func btnSelectLanguage(_ sender: UIButton) {
        if sender.tag == 0 {
            selectedLanguage = .en
            selectLanguage(isEnglishSelected: true)
        } else {
            selectedLanguage = .ar
            selectLanguage(isEnglishSelected: false)
        }
        applyLanguageChange()
    }
    
    @IBAction func btnTapContinue(_ sender: Any) {
        UserDefaults.standard.setValue(selectedLanguage.rawValue, forKey: "AppLanguage")
        UserDefaults.standard.setValue("true", forKey: "isAppInstall")
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func selectLanguage(isEnglishSelected: Bool) {
        let selectedColor = UIColor(named: "darkBrown")?.cgColor
        let deselectedColor = UIColor.lightGray.cgColor
        
        // English
        englishView.layer.borderColor = isEnglishSelected ? selectedColor : deselectedColor
        imgEnglish.image = UIImage(named: isEnglishSelected ? "radioSelected" : "radioUnselected")
        
        // Arabic
        arabicView.layer.borderColor = isEnglishSelected ? deselectedColor : selectedColor
        imgArabic.image = UIImage(named: isEnglishSelected ? "radioUnselected" : "radioSelected")
    }
    
    private func applyLanguageChange() {
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        if selectedLanguage == .ar {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        refreshUI()
    }
    
    private func refreshUI() {
        let nextVC = SelectLanguageViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.setViewControllers([nextVC], animated: false)
    }
    
}

