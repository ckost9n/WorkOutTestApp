//
//  ProfileCollectionViewCell.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 10.02.2022.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "PUSH UPS"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .robotoBold24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutsImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Push Ups")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let numberLabel: UILabel = {
      let label = UILabel()
        label.text = "180"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .robotoBold48()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        layer.cornerRadius = 20
        backgroundColor = .specialYellow
        
        addSubview(nameLabel)
        addSubview(workoutsImageView)
        addSubview(numberLabel)
    }
    
    func cellConfigure(model: ResultWorkout) {
        nameLabel.text = model.name
        numberLabel.text = "\(model.result)"
        
        guard let data = model.imageDate else { return }
        let image = UIImage(data: data)
        workoutsImageView.image = image
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            workoutsImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            workoutsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutsImageView.heightAnchor.constraint(equalToConstant: 57),
            workoutsImageView.widthAnchor.constraint(equalToConstant: 57)
        ])
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: workoutsImageView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: workoutsImageView.trailingAnchor, constant: 10)
        ])
        
    }
    
}
