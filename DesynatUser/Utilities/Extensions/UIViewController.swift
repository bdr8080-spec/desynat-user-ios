//
//  UIViewController.swift
//  ChorApp
//
//  Created by Developer on 07/12/23.
//

import Foundation
import UIKit
import Toaster
import PDFKit

extension UIViewController {
    
    private static var isAlertVisible = false
    
    static var viewFromNIB : Self {
        return Self(nibName: String(describing: Self.self), bundle: nil) as Self
    }
    
    public func showAlert(msg: String, completion: (() -> Void)? = nil) {
        // Prevent multiple alerts
        guard !UIViewController.isAlertVisible else { return }
        UIViewController.isAlertVisible = true
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Bundle.main.ApplicationName ?? "",
                                          message: msg.localiz(),
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: StringConstant.ok.value(), style: .default, handler: { _ in
                UIViewController.isAlertVisible = false   // reset flag
                completion?()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    static func convertPDFToImages(pdfURL: URL) -> [UIImage]? {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            return nil
        }
        var images: [UIImage] = []
        
        for pageNum in 0..<pdfDocument.pageCount {
            if let pdfPage = pdfDocument.page(at: pageNum) {
                let pdfPageSize = pdfPage.bounds(for: .mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pdfPageSize.size)
                
                let image = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pdfPageSize)
                    ctx.cgContext.translateBy(x: 0.0, y: pdfPageSize.size.height)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    
                    pdfPage.draw(with: .mediaBox, to: ctx.cgContext)
                }
                images.append(image)
            }
        }
        return images
    }
    
    public func showConfirmationAlert(
        msg: String,
        completion: (() -> Void)? = nil
    ) {
        // Prevent multiple alerts
        guard !UIViewController.isAlertVisible else { return }
        UIViewController.isAlertVisible = true
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: Bundle.main.ApplicationName ?? "",
                message: msg,
                preferredStyle: .alert
            )
            
            // Yes Action
            let yesButton = UIAlertAction(title: "Yes".localiz(), style: .default) { _ in
                UIViewController.isAlertVisible = false
                completion?()
            }
            
            // Cancel Action (red color)
            let cancelButton = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { _ in
                UIViewController.isAlertVisible = false
            }
            
            // Apply red color to Cancel button text
            cancelButton.setValue(UIColor.red, forKey: "titleTextColor")
            
            alert.addAction(yesButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        }
    }
    
    func getCurrentTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        return dateFormatter.string(from: currentDate)
    }
    
    public func showLoginAlert(completion: (() -> ())? = nil) {
        let alert = UIAlertController(
            title: Bundle.main.ApplicationName ?? "",
            message: "Please login to proceed".localiz(),
            preferredStyle: .alert
        )
        
        // Login action
        let loginAction = UIAlertAction(title: "Login".localiz(), style: .default) { _ in
            completion?()
            UserDefaults.standard.setValue("false", forKey:"isGuestLogin")
            kSharedSceneDelegate.navigateToLoginVc()
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
    /// Show Toater Alert
    public func showToast(msg:String) {
        let tost = Toast(text: msg)
        tost.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tost.view.layer.cornerRadius = 5
        tost.view.textColor = UIColor.white
        tost.start()
    }
    
    func getAttributedText(fullText: String, highlightedText: String, highlightedFont: UIFont, highlightedColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: highlightedText) {
            let nsRange = NSRange(range, in: fullText)
            // Apply both font and color to the highlighted text
            attributedString.addAttributes([
                .font: highlightedFont,
                .foregroundColor: highlightedColor
            ], range: nsRange)
        }
        
        return attributedString
    }
    func formattedMinimumRate(from amount: String?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        guard let amountString = amount, let value = Double(amountString) else {
            return "0.00"
        }
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        return "0.00"
    }
    
    
    func formattedMinimu(from amount: Float?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        let value = Double(amount ?? 0)
        
        // Check if the value is a whole number
        if value == floor(value) {
            // If it's a whole number, we can avoid showing decimals
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // If it's a floating-point number, we ensure two decimals
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "0.00"
    }
    
    func formattedAmount(from amount: Double?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        // Use the Double value directly, with a default of 0.0 if nil
        let value = amount ?? 0.0
        
        // Check if the value is a whole number
        if value == floor(value) {
            // If it's a whole number, we can avoid showing decimals
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // If it's a floating-point number, we ensure two decimals
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        
        // Format the number and return as a string
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "0.00"
    }
    
    
    func convertDateString(inputDateString: String, inputDateFormat: String, outputDateFormat: String) -> String? {
        // Step 1: Create a DateFormatter to parse the original string
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = inputDateFormat
        originalDateFormatter.timeZone = TimeZone.current // Adjust timezone if necessary
        
        // Step 2: Convert the string to a Date object
        if let date = originalDateFormatter.date(from: inputDateString) {
            
            // Step 3: Create a new DateFormatter for the desired output format
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputDateFormat
            outputDateFormatter.locale = Locale(identifier: "en_US") // You can change this to a different locale if necessary
            
            // Step 4: Convert the Date object to the desired format
            let formattedDate = outputDateFormatter.string(from: date)
            return formattedDate
        } else {
            print("Invalid date format")
            return nil
        }
    }
    func removeSpecialCharacters(from string: String) -> String {
        let cleanedString = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleanedString
    }
    
    func backController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    func backTwoController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        
        let fullText = "Size: \(size)  \(dot)  Color: \(coloredSquare)  \(dot)  Qnt: \(quantity)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") ?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
    
    func setColorBoxWithQuanityInView(size: String, label: UILabel, hexColor: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        
        let fullText = "\("Size:".localiz()) \(size)  \(dot)  \("Color:".localiz()) \(coloredSquare)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") //?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
    
    func findTabBarVC() -> TabBarVC? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in scene.windows {
                if let tabVC = window.rootViewController as? TabBarVC {
                    return tabVC
                }
                if let nav = window.rootViewController as? UINavigationController {
                    if let tabVC = nav.viewControllers.first(where: { $0 is TabBarVC }) as? TabBarVC {
                        return tabVC
                    }
                }
                if let presented = window.rootViewController?.presentedViewController as? TabBarVC {
                    return presented
                }
            }
        }
        return nil
    }
}

extension UITableViewCell {
    func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        
        let fullText = "\("Size:".localiz()) \(size)  \(dot)  \("Color:".localiz()) \(coloredSquare)  \(dot)  \("Qnt:".localiz()) \(quantity)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") //?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
    
    func setColorBoxWithQuanity(size: String, label: UILabel, hexColor: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        
        let fullText = "\("Size:".localiz()) \(size)  \(dot)  \("Color:".localiz()) \(coloredSquare)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") //?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
}



extension UINavigationController {
    func previousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        return previousViewController
    }
    
    func secondPreviousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 3 ? self.viewControllers[lenght-3] : nil
        return previousViewController
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
}


extension UINavigationController {
    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        if let targetVC = viewControllers.first(where: { $0 is T }) {
            popToViewController(targetVC, animated: animated)
        }
    }
}

