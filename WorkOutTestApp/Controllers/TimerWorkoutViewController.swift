//
//  TimerWorkoutViewController.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 27.01.2022.
//

import UIKit

class TimerWorkoutViewController: UIViewController {
    
    var workoutModel = WorkoutModel()
    
    private var numberOfSet = 1

    private let clouseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "Close Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clouseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let startWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "START WORKOUT"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let elipseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let workoutTimerLabel: UILabel = {
       let label = UILabel()
        label.text = "00:00"
        label.textColor = .specialGray
        label.font = .robotoBold45()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel = UILabel(text: "Details")
    
    private let workoutParametersView = WorkoutParametersView()
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("FINISH", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .robotoBold16()
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setConstraints()
        setWorkoutParameters()
        setDelegate()
        
    }
    
    private func setDelegate() {
        workoutParametersView.cellNextSetDelegate = self
    }
    
    @objc func clouseButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateWorkoutModel(model: workoutModel, bool: true)
        } else {
            alertOkCancel(title: "Warniing", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func setWorkoutParameters() {
        
        let (min, sec) = { (secs: Int) -> (Int, Int) in
            return (secs / 60, secs % 60)}(workoutModel.workoutTimer)
        
        var minTimer: String
        var secTimer: String
        
        if min == 0 {
            minTimer = "00"
        } else if min > 0 && min < 10 {
            minTimer = "0\(min)"
        } else {
            minTimer = String(min)
        }
        
        if sec == 0 {
            secTimer = "00"
        } else if sec > 0 && sec < 10 {
            secTimer = "0\(sec)"
        } else {
            secTimer = String(sec)
        }
 
        workoutParametersView.workoutNameLabel.text = workoutModel.workoutName
        workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        workoutParametersView.numberOfRepsOrTimerLabel.text = min == 0 ? "\(sec) sec" : "\(min) min \(sec) sec"
        workoutTimerLabel.text = "\(minTimer):\(secTimer)"
    }
    
    private func setupView() {
        view.backgroundColor = .specialBackground
        workoutParametersView.repsOrTimerLabel.text = "Timer"
        
        view.addSubview(startWorkoutLabel)
        view.addSubview(clouseButton)
        view.addSubview(elipseImageView)
        view.addSubview(workoutTimerLabel)
        view.addSubview(workoutParametersView)
        view.addSubview(detailsLabel)
        view.addSubview(finishButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clouseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            clouseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clouseButton.widthAnchor.constraint(equalToConstant: 30),
            clouseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            elipseImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20),
            elipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            elipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            elipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            workoutTimerLabel.topAnchor.constraint(equalTo: elipseImageView.topAnchor, constant: 0),
            workoutTimerLabel.bottomAnchor.constraint(equalTo: elipseImageView.bottomAnchor, constant: 0),
            workoutTimerLabel.leadingAnchor.constraint(equalTo: elipseImageView.leadingAnchor, constant: 0),
            workoutTimerLabel.trailingAnchor.constraint(equalTo: elipseImageView.trailingAnchor, constant: 0),
            workoutTimerLabel.centerXAnchor.constraint(equalTo: elipseImageView.centerXAnchor),
            workoutTimerLabel.centerYAnchor.constraint(equalTo: elipseImageView.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: elipseImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            workoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            workoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutParametersView.heightAnchor.constraint(equalToConstant: 220)
        ])

        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: workoutParametersView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
    
    

}

// MARK: - NextSetProtocol


extension TimerWorkoutViewController: NextSetProtocol {

    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            alertOk(title: "Error", message: "Finish your workout")
        }

    }

}
