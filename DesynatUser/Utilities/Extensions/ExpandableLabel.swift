//
//  ExpandableLabel.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import Foundation
import UIKit

extension UILabel {
    
    // Stored static property for associated object key
    private static var tapActionKey: UInt8 = 0
    
    func setExpandableText(
        fullText: String,
        isExpanded: Bool,
        lineLimit: Int = 3,
        actionText: String = "More",
        collapseText: String = "Short",
        actionColor: UIColor = .systemBlue,
        onTap: @escaping () -> Void
    ) {
        // Remove old tap gestures
        gestureRecognizers?.forEach { removeGestureRecognizer($0) }
        
        // Store tap action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &Self.tapActionKey, onTap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!, // main label font
            .foregroundColor: textColor ?? .label,
            .paragraphStyle: paragraphStyle
        ]
        
        let fullAttributed = NSAttributedString(string: fullText, attributes: attributes)
        
        // Font for action text: Poppins Medium, size 12
        let actionFont = UIFont(name: "Poppins-Medium", size: 13)!
        
        if isExpanded {
            // Show full text + "Short"
            let mutable = NSMutableAttributedString(attributedString: fullAttributed)
            let action = NSAttributedString(string: "  \(collapseText)", attributes: [
                .font: actionFont,
                .foregroundColor: actionColor
            ])
            mutable.append(action)
            attributedText = mutable
            numberOfLines = 0
        } else {
            // Check if text actually exceeds lineLimit
            let maxSize = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
            let neededHeight = fullAttributed.boundingRect(
                with: maxSize,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            ).height
            
            let maxHeight = font!.lineHeight * CGFloat(lineLimit) + 10 // small buffer
            
            if neededHeight <= maxHeight || bounds.width <= 0 {
                // Fits in lineLimit → show full text, no "More"
                text = fullText
                numberOfLines = lineLimit
                return
            }
            
            // Needs truncation → show lineLimit + "... More"
            numberOfLines = lineLimit
            
            // Use smart truncation
            let truncatedText = truncateToFitLines(
                text: fullText,
                font: font!,
                maxLines: lineLimit,
                width: bounds.width,
                trailing: " .\(actionText)",
                trailingAttributes: [
                    .foregroundColor: actionColor,
                    .font: actionFont
                ]
            )
            attributedText = truncatedText
        }
    }
    
    private func truncateToFitLines(
        text: String,
        font: UIFont,
        maxLines: Int,
        width: CGFloat,
        trailing: String,
        trailingAttributes: [NSAttributedString.Key: Any]
    ) -> NSAttributedString {
        
        let trailingAttr = NSAttributedString(string: trailing, attributes: trailingAttributes)
        let trailingWidth = trailingAttr.size().width + 10
        
        var start = 0
        var end = text.count
        var resultText = text
        
        while start < end {
            let mid = (start + end + 1) / 2
            let candidate = String(text.prefix(mid))
            let size = candidate.boundingRect(
                with: CGSize(width: width - trailingWidth, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )
            
            if size.height > font.lineHeight * CGFloat(maxLines) {
                end = mid - 1
            } else {
                start = mid
            }
        }
        
        resultText = String(text.prefix(start))
        let final = NSMutableAttributedString(string: resultText, attributes: [.font: font])
        final.append(trailingAttr)
        return final
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let text = self.text ?? ""
        if text.contains("More") || text.contains("Short") {
            if let action = objc_getAssociatedObject(self, &Self.tapActionKey) as? () -> Void {
                action()
            }
        }
    }
}
