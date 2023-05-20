//
//  SelectedCityWeatherCell.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit

class SelectedCityWeatherCell: UITableViewCell {
    static let identifier = "SelectedCityWeatherCell"
    
    lazy var fieldView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
    
    lazy var descriptionView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 0
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
        
    func setUpView(field: String, description: String) {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        fieldView.text = field
        descriptionView.text = description
        
        self.contentView.addSubview(fieldView)
        self.contentView.addSubview(descriptionView)

        NSLayoutConstraint.activate([
            fieldView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            fieldView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            fieldView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            fieldView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),

            descriptionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: fieldView.safeAreaLayoutGuide.trailingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

