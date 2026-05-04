import Foundation
import WebKit
import UIKit
import SVProgressHUD
import AVFoundation
import DropDown
import FTIndicator

class CommonUtils {
    
    /// This function will help developer to get default country of the user based on locale
    static func getDefaultCountryDialCode() -> String {
        let countryPicker = ADCountryPicker()
        if #available(iOS 16, *) {
            return countryPicker.getDialCode(countryCode: NSLocale.current.region?.identifier ?? "IN") ?? "+91"
        } else {
            return countryPicker.getDialCode(countryCode: NSLocale.current.identifier) ?? "+91"
        }
    }
    
    static func isoStringAddingDays(_ isoString: String?, days: Int = 0) -> String? {
        guard let isoString = isoString else { return nil }
        
        // Parse the ISO date string from API
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = isoFormatter.date(from: isoString) else { return nil }
        
        // Add days if needed
        let calendar = Calendar(identifier: .gregorian)
        let newDate = calendar.date(byAdding: .day, value: days, to: date) ?? date
        
        // Format to desired output: 12 SEP 25
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: newDate)
    }
    
    static func loadHTMLContent(_ content: String, webView: WKWebView) {
        
        let cleanedContent = content
            .replacingOccurrences(of: "\u{2028}", with: "<br>")
            .replacingOccurrences(of: "\u{2029}", with: "<br><br>")
            .trimmingCharacters(in: .whitespacesAndNewlines) // IMPORTANT: remove leading blank lines
        
        let html = """
        <html>
        <head>
            <meta name="viewport"
                  content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

            <style>
                body {
                    margin: 0;                           /* remove body margin */
                    padding: 0;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    -webkit-text-size-adjust: 100%;
                    white-space: normal !important;      /* reset body */
                }

                /* Clean paragraphs completely */
                p {
                    margin: 0 !important;
                    padding: 0 !important;
                    white-space: pre-wrap !important;
                }

                div, span {
                    white-space: pre-wrap !important;
                    margin: 0 !important;
                    padding: 0 !important;
                }

                img {
                    max-width: 100%;
                    height: auto;
                }

                table {
                    width: 100% !important;
                }

                /* Add controlled spacing between elements */
                p + p {
                   margin-top: 10px !important;
                }
            </style>
        </head>
        <body>
            <div style="padding: 12px;">\(cleanedContent)</div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
    static func isWithinThreeHours(from createdAt: String) -> Bool {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let createdDate = formatter.date(from: createdAt) else {
            return false
        }
        
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(createdDate)
        
        // 3 hours = 3 * 60 * 60 seconds
        return timeDifference <= (3 * 60 * 60)
    }
    
//    static func formatPriceStringInput(_ amount: String?, currency: String = "KD") -> String {
//        guard
//            let amount = amount,
//            let doubleAmount = Double(amount)
//        else {
//            return "0 \(currency)"
//        }
//        
//        let roundedAmount = round(doubleAmount * 100) / 100
//        
//        if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
//            return "\(Int(roundedAmount)) \(currency)"
//        } else {
//            return String(format: "%.2f", roundedAmount) + " \(currency)"
//        }
//    }
    
    static func convertDisplayedPriceToKD(_ priceText: String?) -> Double {
        
        guard let text = priceText, !text.isEmpty else { return 0.0 }
        
        // Get selected currency
        let savedCurrencyCode = kSharedUserDefaults.getStringFor(key: .savedUserCurrency)
        let savedExchangeRate = kSharedUserDefaults.getStringFor(key: .exchangeRateOfCurrency)
        
        var cleanText = text
        
        // Remove selected currency text
        if let code = savedCurrencyCode, !code.isEmpty {
            cleanText = cleanText.replacingOccurrences(of: " \(code)", with: "")
        }
        
        // Remove KD if present
        cleanText = cleanText.replacingOccurrences(of: " KD", with: "")
        cleanText = cleanText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var amount = Double(cleanText) ?? 0.0
        
        // Convert selected currency back to KD
        if let code = savedCurrencyCode,
           !code.isEmpty,
           code != "KD",
           let rateString = savedExchangeRate,
           let rate = Double(rateString),
           rate > 0 {
            
            amount = amount / rate
        }
        
        // Round to 2 decimal places
        amount = (amount * 100).rounded() / 100
        
        return amount
    }
    
    static func formatPriceStringInput(_ amount: String?, currency: String = "KD") -> String {
        guard
            let amount = amount,
            let kdAmount = Double(amount)
        else {
            return "0 \(currency)"
        }
        // Fetch saved currency + exchange rate
        let savedCurrencyCode = kSharedUserDefaults.getStringFor(key: .savedUserCurrency)
        let savedExchangeRate = kSharedUserDefaults.getStringFor(key: .exchangeRateOfCurrency)
        
        var finalAmount = kdAmount
        var finalCurrency = currency
        
        // If saved values exist, convert KD amount
        if let code = savedCurrencyCode,
           !code.isEmpty,
           let rateString = savedExchangeRate,
           let rate = Double(rateString),
           rate > 0 {
            
            finalAmount = kdAmount * rate
            finalCurrency = code
        }
        
        let roundedAmount = round(finalAmount * 100) / 100
        
        if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(roundedAmount)) \(finalCurrency)"
        } else {
            return String(format: "%.2f", roundedAmount) + " \(finalCurrency)"
        }
    }
    
    static func formatPrice(_ amount: Double?, currency: String = "KD") -> String {
        
        guard let kdAmount = amount else {
            return "0 \(currency)"
        }
        
        // Fetch saved currency + exchange rate
        let savedCurrencyCode = kSharedUserDefaults.getStringFor(key: .savedUserCurrency)
        let savedExchangeRate = kSharedUserDefaults.getStringFor(key: .exchangeRateOfCurrency)
        
        var finalAmount = kdAmount
        var finalCurrency = currency
        
        // Convert if saved currency exists
        if let code = savedCurrencyCode,
           !code.isEmpty,
           let rateString = savedExchangeRate,
           let rate = Double(rateString),
           rate > 0 {
            
            finalAmount = kdAmount * rate
            finalCurrency = code
        }
        
        let roundedAmount = round(finalAmount * 100) / 100
        
        if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(roundedAmount)) \(finalCurrency)"
        } else {
            return String(format: "%.2f", roundedAmount) + " \(finalCurrency)"
        }
    }
    
//    static func formatPrice(_ amount: Double?, currency: String = "KD") -> String {
//        guard let amount = amount else { return "0 \(currency)" }
//        
//        let roundedAmount = round(amount * 100) / 100   // Round to 2 decimal places
//        if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
//            // If whole number, show without decimal
//            return "\(Int(roundedAmount)) \(currency)"
//        } else {
//            // Show up to 2 decimal places
//            return String(format: "%.2f", roundedAmount) + " \(currency)"
//        }
//    }
    
    
    static func getDictionary(_ dictData: Any?) -> Dictionary<String, Any> {
        guard let dict = dictData as? Dictionary<String, Any> else {
            guard let arr = dictData as? [Any] else {
                return ["":""]
            }
            return getDictionary(arr.count > 0 ? arr[0] : ["":""])
        }
        return dict
    }
    
    
    static func getModelFromAny<T:Decodable>(model:T.Type, data:Any, completion:(T)->()) {
        do {
            if let data = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                let final = try JSONDecoder().decode(model, from: data)
                completion(final)
            }
        } catch let err {
            debugPrint("Err:\(err)")
        }
    }
    
    
//    static func updateDiscountPercentageLabel(_ label: UILabel, actualAmountLabel: UILabel, discountType: String?,discountValue: String?) {
//        let value = Double(discountValue ?? "0") ?? 0
//        guard value > 0 else {
//            label.isHidden = true
//            actualAmountLabel.isHidden = true
//            return
//        }
//        label.isHidden = false
//        actualAmountLabel.isHidden = false
//        if discountType == "1" {
//            label.text = "\(discountValue ?? "")% Off"
//        } else {
//            label.text = "\(discountValue ?? "") KD Off"
//        }
//    }
    
    static func updateDiscountPercentageLabel(
        _ label: UILabel,
        actualAmountLabel: UILabel,
        discountType: String?,
        discountValue: String?
    ) {
        
        let value = Double(discountValue ?? "0") ?? 0
        
        guard value > 0 else {
            label.isHidden = true
            actualAmountLabel.isHidden = true
            return
        }
        
        label.isHidden = false
        actualAmountLabel.isHidden = false
        
        if discountType == "1" {
            // Percentage discount
            label.text = "\(discountValue ?? "0")% Off"
            
        } else {
            // Fixed amount discount with saved currency conversion
            let savedCurrencyCode = kSharedUserDefaults.getStringFor(key: .savedUserCurrency)
            let savedExchangeRate = kSharedUserDefaults.getStringFor(key: .exchangeRateOfCurrency)
            
            var finalAmount = value
            var finalCurrency = "KD"
            
            if let code = savedCurrencyCode,
               !code.isEmpty,
               let rateString = savedExchangeRate,
               let rate = Double(rateString),
               rate > 0 {
                
                finalAmount = value * rate
                finalCurrency = code
            }
            
            let roundedAmount = round(finalAmount * 100) / 100
            
            let amountText: String
            if roundedAmount.truncatingRemainder(dividingBy: 1) == 0 {
                amountText = "\(Int(roundedAmount))"
            } else {
                amountText = String(format: "%.2f", roundedAmount)
            }
            
            label.text = "\(amountText) \(finalCurrency) Off"
        }
    }
    
    static func setStrikethrough(label: UILabel, text: String) {
        let attributeString = NSMutableAttributedString(string: text)
        
        // Strikethrough in the same color as the label text
        let textColor = label.textColor ?? .black
        
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        attributeString.addAttribute(
            .strikethroughColor,
            value: textColor,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        // Keep label's current font
        if let font = label.font {
            attributeString.addAttribute(
                .font,
                value: font,
                range: NSRange(location: 0, length: attributeString.length)
            )
        }
        
        label.attributedText = attributeString
    }
    
    static func formatTax(_ tax: Double?) -> String {
        if tax == 0 {
            return "Free"
        } else {
            return formatPrice(tax) // Assuming formatPrice(_:) returns a formatted string like "$10.00"
        }
    }
    
    static func formatDeliveryCharges(_ deliveryFees: Double?) -> String {
        if deliveryFees == 0 {
            return "Free Delivery".localiz()
        } else {
            return formatPrice(deliveryFees) // Assuming formatPrice(_:) returns a formatted string like "$10.00"
        }
    }
    
    static func formatDate(from dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil // Return nil if string can't be parsed
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM yyyy"   // e.g. 5 Oct 2025
        outputFormatter.locale = Locale(identifier: "en_US")
        
        return outputFormatter.string(from: date)
    }
    
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    static let apiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    
    
    
    static func formatDateToYYYYMMDD(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    static func formatDateForMyBooking(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Try parsing the string
        guard let date = isoFormatter.date(from: dateString) ?? ISO8601DateFormatter().date(from: dateString) else {
            return dateString
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E dd MM yyyy | hh:mm a"
        
        return formatter.string(from: date)
    }
    
    static func formatStartEndDate(_ apiDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // important for Zulu time (UTC)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.timeZone = TimeZone.current // show in local time
        
        if let date = inputFormatter.date(from: apiDate) {
            return outputFormatter.string(from: date)
        }
        return apiDate
    }
    
    
    static func getDefaultCountryCode() -> String {
        let countryPicker = ADCountryPicker()
        if #available(iOS 16, *) {
            return countryPicker.getDialCode(countryCode: NSLocale.current.region?.identifier ?? "UK") ?? "+44"
        } else {
            return countryPicker.getDialCode(countryCode: NSLocale.current.identifier) ?? "+44"
        }
    }
    /// This function will help developer to get top, bottom and total SafeArea Height
    static func getSafeAreaHeight() -> (top: CGFloat, bottom: CGFloat, total: CGFloat) {
        var window: UIWindow!
        
        if #available(iOS 15, *) {
            guard let firstWindow = UIApplication.shared.connectedScenes.first?.inputView?.window else { return (CGFloat.zero, CGFloat.zero, CGFloat.zero) }
            window = firstWindow
        } else {
            guard let firstWindow = UIApplication.shared.windows.first else { return (CGFloat.zero, CGFloat.zero, CGFloat.zero) }
            window = firstWindow
        }
        
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        return (topPadding, bottomPadding, topPadding + bottomPadding)
    }
    
    /// This function will help developer to get an image with User's Initials
    static func getImageWithUserInitials(withName name: String?, backgroundColor bgColor: UIColor, textColor txtColor: UIColor, textFont txtFont: UIFont, andSize size: CGFloat) -> UIImage? {
        let frame = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = bgColor
        nameLabel.textColor = txtColor
        nameLabel.font = txtFont
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else if let name = name, name.count > 0 {
            initials = String(name.prefix(1)).capitalized
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            return img
        }
        return nil
    }
    static func showHudWithNoInteraction(show: Bool) {
        if show {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0))
            //SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).withAlphaComponent(1))
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    static func getDateString(from date: Date, format: String = "dd MMM yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    /// Show Progress Hud
    /// - Parameter show: Boolean value to show/Hide
    static func showHud(show: Bool) {
        if show == true {
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(UIColor(hexString: "#273470"))
            SVProgressHUD.setBackgroundColor(.white)
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    /// Get thumnail from video url
    /// - Parameter url: desired video url
    /// - Parameter completion: if found asset at url then will return uiimage else ll return nil
    static func getThumbnailImage(forUrl url: URL, completion:@escaping(UIImage?)->()) {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) ,
                                                                actualTime: nil)
            completion(UIImage(cgImage: thumbnailImage))
        } catch _ {
            completion(nil)
        }
    }
    
    static func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    /// String DropDown
    /// - Parameters:
    ///   - dataSource: String array to show list
    ///   - anchorView: view from where it will show listing
    ///   - selectedColor: selected value color
    ///   - completion: Index of selection and value of selection
    static func dropDown(dataSource:[String], anchorView:UIView, selectedColor:UIColor, bgColor:UIColor = .white,
                         completion: @escaping (_ index: Int, _ item: String) -> ()) {
        let dropDown = DropDown()
        dropDown.setupCornerRadius(16)
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = bgColor
        dropDown.textColor = .black
        dropDown.direction = .any
        dropDown.selectionBackgroundColor = bgColor
        dropDown.selectedTextColor = selectedColor
        dropDown.dismissMode = .automatic
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)! + 5.0))
        dropDown.topOffset = CGPoint(x: 0, y:-((dropDown.anchorView?.plainView.bounds.height)! + 5.0))
        dropDown.shadowColor = UIColor(hexString: "#273470")
        dropDown.shadowOffset = .zero
        dropDown.shadowRadius = 1.0
        dropDown.shadowOpacity = 1.0
        dropDown.selectionAction = {(index: Int, item: String) in
            completion(index,item)
        }
        dropDown.show()
    }
    
    static func openPicker(controller:UIViewController, callBack:@escaping ((String,String,String) -> Void)) {
        let picker = ADCountryPicker(style: .grouped)
        picker.searchBarBackgroundColor = .white
        picker.showCallingCodes = true
        picker.didSelectCountryWithCallingCodeClosure = { name,code, callingCodes in
            picker.dismiss(animated: true)
            callBack(name,code, callingCodes)
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        controller.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    static func getCode(dialCode:String) -> String {
        guard let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") else {return ""}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else { return "" }
        let countries = plist.first(where:{$0["dial_code"] ==  dialCode})
        return String.getString(countries?["code"])
    }
    
    static func showToast(message: String) {
        FTIndicator.showNotification(withTitle: Bundle.main.ApplicationName ?? "",
                                     message: message.count>0 ? message: "Message")
        
    }
}

extension Date {
    public enum DateCustomFormat : String {
        case dd_MMM_yy_h_mm_a           = "dd MMM yy, h:mm a"
        case h_mm_a           = "h:mm a"
    }
    
    func change_DateIntoString(format:DateCustomFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}
