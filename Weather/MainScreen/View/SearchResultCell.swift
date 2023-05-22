//
//  SearchResultCell.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

class SearchResultCell: UITableViewCell {
    static let identifier = "SearchResultCell"
    
    lazy var cityLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
        
    func setUpView(content: SearchResultElement) {
        self.selectionStyle = .none
        
        self.cityLabel.text = content.fullName
        
        self.contentView.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
