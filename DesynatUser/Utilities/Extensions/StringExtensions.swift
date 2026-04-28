//
//  StringExtensions.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func localiz(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func formattedPlacedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = inputFormatter.date(from: self) else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yy 'at' h:mm a"
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date)
    }
    var removingSpaces: String {
          return self.replacingOccurrences(of: " ", with: "")
      }
      
      // Format into XXXX XXXX XXXX XXXX
      func formatCardNumber() -> String {
          let clean = self.removingSpaces
          var result = ""
          
          for (index, char) in clean.enumerated() {
              if index != 0 && index % 4 == 0 {
                  result.append(" ")
              }
              result.append(char)
          }
          
          return result
      }
    func isValidCardNumber() -> Bool {
        let number = self.replacingOccurrences(of: " ", with: "")
        
        // Only digits allowed
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: number)) else {
            return false
        }
        // Length check
//        guard number.count >= 13 && number.count <= 19 else {
//            return false
//        }
        
        guard number.count == 16 else {
            return false
        }
        
//        // Luhn Algorithm
//        var sum = 0
//        let reversedDigits = number.reversed().compactMap { Int(String($0)) }
//        
//        for (index, digit) in reversedDigits.enumerated() {
//            if index % 2 == 1 {
//                let doubled = digit * 2
//                sum += doubled > 9 ? doubled - 9 : doubled
//            } else {
//                sum += digit
//            }
//        }
//        
//        return sum % 10 == 0
        return true
    }
}
