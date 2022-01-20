//
//  WhetherView.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 15.01.2022.
//

import UIKit

class WeatherView: UIView {
    
    private let weatherLabel: UILabel = {
       let label = UILabel()
        label.text = "Солнечно"
        label.font = .robotoMedium18()
        label.textColor = .specialGray
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "Хорошая погода, чтобы позаниматься на улице"
        label.font = .robotoMedium14()
        label.textColor = .specialLightGray
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sun")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadowOnView()
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weatherLabel)
        addSubview(descriptionLabel)
        addSubview(weatherImageView)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -78)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            weatherImageView.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 6),
            weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13)
        ])
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
