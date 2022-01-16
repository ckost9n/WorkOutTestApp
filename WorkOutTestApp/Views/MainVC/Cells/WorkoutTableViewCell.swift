//
//  WorkoutTableViewCell.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 15.01.2022.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    private let backgroundCell: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .specialBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pictureView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .specialBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Push Ups")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameExerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "Konstantin"
        label.font = .robotoMedium24()
        label.textColor = .specialBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let repsLabel: UILabel = {
       let label = UILabel()
        label.text = "Reps: 20"
        label.font = .robotoMedium14()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Sets: 3"
        label.font = .robotoMedium14()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfExercisesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .none
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.titleLabel?.font = .robotoMedium24()
        button.tintColor = .specialDarkGreen
        button.layer.cornerRadius = 10
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(addStartButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func addStartButtonTapped() {
        print("addStartButtonTapped")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(backgroundCell)
        addSubview(pictureView)
        addSubview(nameExerciseLabel)
        addSubview(workoutImageView)
        addSubview(numberOfExercisesStackView)
        numberOfExercisesStackView.addArrangedSubview(repsLabel)
        numberOfExercisesStackView.addArrangedSubview(setsLabel)
        contentView.addSubview(startButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            pictureView.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 8),
            pictureView.bottomAnchor.constraint(equalTo: backgroundCell.bottomAnchor, constant: -10),
            pictureView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            nameExerciseLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            nameExerciseLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            workoutImageView.topAnchor.constraint(equalTo: pictureView.topAnchor, constant: 7),
            workoutImageView.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor, constant: 12),
            workoutImageView.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            numberOfExercisesStackView.topAnchor.constraint(equalTo: nameExerciseLabel.bottomAnchor, constant: 0),
            numberOfExercisesStackView.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10),
            numberOfExercisesStackView.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: numberOfExercisesStackView.bottomAnchor, constant: 3),
            startButton.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 27)
        ])
        
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
