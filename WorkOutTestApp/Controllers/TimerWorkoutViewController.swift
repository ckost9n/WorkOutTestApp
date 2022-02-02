//
//  TimerWorkoutViewController.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 27.01.2022.
//

import UIKit

class TimerWorkoutViewController: UIViewController {
    
    var workoutModel = WorkoutModel()
    let customAlert = CustomAlert()
    
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
        label.font = .robotoBold48()
        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
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
    
    let shapeLayer = CAShapeLayer()
    
    var timer = Timer()
    var durationTimer = 10
    
    override func viewDidLayoutSubviews() {
        clouseButton.layer.cornerRadius = clouseButton.frame.height / 2
        animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setConstraints()
        setWorkoutParameters()
        setDelegate()
        addTaps()
        
    }
    
    private func setDelegate() {
        workoutParametersView.cellNextSetDelegate = self
    }
    
    @objc func clouseButtonTapped() {
        dismiss(animated: true)
        timer.invalidate()
    }
    
    @objc func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel, bool: true)
        } else {
            alertOkCancel(title: "Warniing", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
        timer.invalidate()
    }
    
    private func setWorkoutParameters() {
        
        let (min, sec) = workoutModel.workoutTimer.convertSecond()
 
        workoutParametersView.workoutNameLabel.text = workoutModel.workoutName
        workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        workoutParametersView.numberOfRepsOrTimerLabel.text = min == 0 ? "\(sec) sec" : "\(min) min \(sec) sec"
        
        workoutTimerLabel.text = "\(min):\(sec.setZeroForSeconds())"
        durationTimer = workoutModel.workoutTimer
    }
    
    private func addTaps() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        workoutTimerLabel.isUserInteractionEnabled = true
        workoutTimerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startTimer() {
        
        workoutParametersView.editingButton.isEnabled = false
        workoutParametersView.nextSetsButton.isEnabled = false
        
        if numberOfSet == workoutModel.workoutSets {
            alertOk(title: "Error", message: "Finish your workout")
        } else  {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        }
        
        
    }
    
    @objc private func timerAction() {

        durationTimer -= 1
        print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
            
            workoutParametersView.editingButton.isEnabled = true
            workoutParametersView.nextSetsButton.isEnabled = true

        }
        
        let (min, sec) = durationTimer.convertSecond()
        workoutTimerLabel.text = "\(min):\(sec.setZeroForSeconds())"
        
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
    
}

// MARK: - Animation Circular

extension TimerWorkoutViewController {
    
    private func animationCircular() {
        
        let center = CGPoint(x: elipseImageView.frame.width / 2, y: elipseImageView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 135,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        elipseImageView.layer.addSublayer(shapeLayer)
        
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
}

// MARK: - SetConstraints

extension TimerWorkoutViewController {
    
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
    
    func editingTapped() {
        customAlert.repsOrTimerLabel.text = "Timer"
        customAlert.alertCustom(viewController: self) { sets, reps in
            if sets != "" && reps != "" {
                print("2")
            }
        }
    }

    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            alertOk(title: "Error", message: "Finish your workout")
        }

    }

}
