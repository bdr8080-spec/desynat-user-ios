//
//  ChangeLanguageViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class ChangeLanguageViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var arabicView: CustomView!
    @IBOutlet weak var englishView: CustomView!
    @IBOutlet weak var imgArabic: UIImageView!
    @IBOutlet weak var imgEnglish: UIImageView!
    
    // MARK: - Property Decalaration
    var selectedLanguage: Languages = .en
    var comingFromDashboard: Bool = false
    var comingUserRole: UserRoleType = .normalUser
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func btnTapSave(_ sender: Any) {
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        switch comingUserRole {
        case .normalUser:
            kSharedSceneDelegate.navigateToUserHomeVc()
        case .affilaiteUser:
            kSharedSceneDelegate.navigateToAffiliatedUserHomeVc()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        switch comingUserRole {
        case .normalUser:
            kSharedSceneDelegate.navigateToUserHomeVc(selectedIndex: 4)
        case .affilaiteUser:
            kSharedSceneDelegate.navigateToAffiliatedUserHomeVc(selectedIndex: 4)
        }
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
        let nextVC = ChangeLanguageViewController.instantiate(fromAppStoryboard: .DashBoard)
        nextVC.comingUserRole = comingUserRole
        self.navigationController?.setViewControllers([nextVC], animated: false)
    }
    
}


