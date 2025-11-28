//
//  CustomDropDownWithImage.swift
//  DesynatUser
//
//  Created by fluper on 28/11/25.
//

import UIKit
import SDWebImage  // Make sure you have SDWebImage pod

// MARK: - Dropdown Cell (MUST be declared BEFORE CustomDropdown)
class DropdownCell: UITableViewCell {
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
    }
}

// MARK: - CustomDropdown (Now sees DropdownCell)
class CustomDropdown: UIView {
    
    private let tableView = UITableView()
    private var heightConstraint: NSLayoutConstraint?
    
    var countries: [GetAllUserCountryModel] = [] {
        didSet {
            tableView.reloadData()
            updateHeight()
        }
    }
    
    var onSelect: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
        tableView.rowHeight = 52
        tableView.layer.cornerRadius = 12
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.separator.cgColor
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.masksToBounds = false
    }
    
    private func updateHeight() {
        let maxVisibleRows: CGFloat = 5.5
        let rowHeight = tableView.rowHeight
        let calculatedHeight = CGFloat(countries.count) * rowHeight
        let maxHeight = maxVisibleRows * rowHeight
        
        heightConstraint?.isActive = false
        heightConstraint = heightAnchor.constraint(equalToConstant: min(calculatedHeight, maxHeight))
        heightConstraint?.isActive = true
    }
}

// MARK: - UITableView DataSource & Delegate
extension CustomDropdown: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        
        let country = countries[indexPath.row]
        
        // Display: +91 India (you can customize)
      let displayText = " (\(country.dialCode ?? "")) \(country.name ?? "")"
        cell.titleLabel.text = displayText
        
        // Load flag
        if let flagURLString = country.flag,
           let url = URL(string: flagURLString) {
            cell.iconImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: ""),
                options: [.highPriority, .continueInBackground]
            )
        } else {
            cell.iconImageView.image = UIImage(systemName: "")
            cell.iconImageView.tintColor = .systemGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect?(indexPath.row)
    }
}
