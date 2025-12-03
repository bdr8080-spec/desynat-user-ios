//
//  PromoCodeTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PromoCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var fullText: String = ""
    var isExpanded: Bool = false
    var onExpansionChanged: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // This is the key: reconfigure after bounds are correct
        if !fullText.isEmpty {
            configure(text: fullText, expanded: isExpanded)
        }
    }
    
    func configure(text: String, expanded: Bool) {
        self.fullText = text
        self.isExpanded = expanded
        
        // Only proceed if label has valid width
        if descriptionLabel.bounds.width <= 0 {
            return // Will be called again in layoutSubviews
        }
        
        descriptionLabel.setExpandableText(
            fullText: text,
            isExpanded: expanded,
            actionText: "More",
            collapseText: "Short",
            actionColor: expanded ? .darkBrown : .darkBrown,
            onTap: { [weak self] in
                self?.isExpanded.toggle()
                self?.onExpansionChanged?()
            }
        )
    }
}
