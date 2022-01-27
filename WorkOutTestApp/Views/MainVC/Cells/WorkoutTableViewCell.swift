//
//  WorkoutTableViewCell.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 15.01.2022.
//

import UIKit

protocol StartWorkoutProtocol: AnyObject {
    func startButtonTapped(model: WorkoutModel)
}

class WorkoutTableViewCell: UITableViewCell {
    
    private var workoutModel = WorkoutModel()
    
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
    
    var workoutImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Push Ups")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameExerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "Konstantin"
        label.font = .robotoMedium24()
        label.textColor = .specialBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var repsLabel: UILabel = {
       let label = UILabel()
        label.text = "Reps: 20"
        label.font = .robotoMedium14()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var setsLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Sets: 3"
        label.font = .robotoMedium14()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var numberOfExercisesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .none
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var startButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = .specialYellow
        button.titleLabel?.font = .robotoMedium24()
//        button.tintColor = .specialDarkGreen
        button.layer.cornerRadius = 10
//        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(addStartButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var cellStartWorkoutDelegate: StartWorkoutProtocol?
    
    @objc private func addStartButtonTapped() {
        cellStartWorkoutDelegate?.startButtonTapped(model: workoutModel)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: WorkoutModel) {
        workoutModel = model
        
        nameExerciseLabel.text = workoutModel.workoutName
        
        let (min, sec) = { (secs: Int) -> (Int, Int) in
            return (secs / 60, secs % 60)}(workoutModel.workoutTimer)
        
        repsLabel.text = (workoutModel.workoutTimer == 0 ? "Reps: \(workoutModel.workoutReps)" : "Timer: \(min) min \(sec) sec")
        
        setsLabel.text = "Sets: \(workoutModel.workoutSets)"
        
        guard let imageData = workoutModel.workoutImage else { return }
        guard let image = UIImage(data: imageData) else { return }
        workoutImageView.image = image
        
        if model.status {
            startButton.setTitle("COMPLETE", for: .normal)
            startButton.tintColor = .white
            startButton.backgroundColor = .specialGreen
            startButton.isEnabled = false
        } else {
            startButton.setTitle("START", for: .normal)
            startButton.tintColor = .specialDarkGreen
            startButton.backgroundColor = .specialYellow
            startButton.isEnabled = true
        }
        
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
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
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
            nameExerciseLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 5),
            nameExerciseLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10),
            nameExerciseLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            workoutImageView.topAnchor.constraint(equalTo: pictureView.topAnchor, constant: 7),
            workoutImageView.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor, constant: 12),
            workoutImageView.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -12),
            workoutImageView.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: -7)
        ])
        
        NSLayoutConstraint.activate([
            numberOfExercisesStackView.topAnchor.constraint(equalTo: nameExerciseLabel.bottomAnchor, constant: 0),
            numberOfExercisesStackView.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10),
            numberOfExercisesStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: numberOfExercisesStackView.bottomAnchor, constant: 3),
            startButton.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 29)
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
