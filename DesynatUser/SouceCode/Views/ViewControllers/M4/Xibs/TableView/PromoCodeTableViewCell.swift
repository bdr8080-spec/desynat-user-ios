//
//  PromoCodeTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PromoCodeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var deiscountLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var fullData: GetPromoCodeListDataModel?
  var isExpanded: Bool = false
  var onExpansionChanged: (() -> Void)?
  var isPromoApplied: (() -> Void)?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if let data = fullData {
      descriptionLabel.setExpandableText(
        fullText: data.descriptionEnglish ?? "",
        isExpanded: isExpanded,
        actionText: "More",
        collapseText: "Short",
        actionColor: .darkBrown,
        onTap: { [weak self] in
          self?.isExpanded.toggle()
          self?.onExpansionChanged?()
        }
      )
    }
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    isPromoApplied?()
  }
  
//  func configure(data: GetPromoCodeListDataModel, expanded: Bool) {
//    self.fullData = data
//    self.isExpanded = expanded
//      titleLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data.nameArabic : data.nameEnglish
//    deiscountLabel.text = "Flat \(data.discountPercent ?? "")% Off On minimum order \(data.minOrderValue ?? "")"
//    self.layoutIfNeeded()
//    descriptionLabel.setExpandableText(
//      fullText: data.descriptionEnglish ?? "",
//      isExpanded: expanded,
//      actionText: "More",
//      collapseText: "Short",
//      actionColor: .darkBrown,
//      onTap: { [weak self] in
//        self?.isExpanded.toggle()
//        self?.onExpansionChanged?()
//      }
//    )
//  }
    
    func configure(data: GetPromoCodeListDataModel, expanded: Bool) {
        
        self.fullData = data
        self.isExpanded = expanded
        
        let isArabic = AppLanguageManager.shared.currentLanguage == .ar
        
        titleLabel.text = isArabic ? data.nameArabic : data.nameEnglish
        
        deiscountLabel.text = isArabic
        ? "خصم ثابت \(data.discountPercent ?? "")٪ على الحد الأدنى للطلب \(data.minOrderValue ?? "")"
        : "Flat \(data.discountPercent ?? "")% Off On minimum order \(data.minOrderValue ?? "")"
        
        self.layoutIfNeeded()
        
        descriptionLabel.setExpandableText(
            fullText: isArabic
            ? (data.descriptionArabic ?? "")
            : (data.descriptionEnglish ?? ""),
            
            isExpanded: expanded,
            
            actionText: isArabic ? "المزيد" : "More",
            
            collapseText: isArabic ? "أقل" : "Short",
            
            actionColor: .darkBrown,
            
            onTap: { [weak self] in
                self?.isExpanded.toggle()
                self?.onExpansionChanged?()
            }
        )
    }
  
}
