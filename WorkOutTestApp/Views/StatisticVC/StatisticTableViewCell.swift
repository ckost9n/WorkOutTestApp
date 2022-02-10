//
//  StatisticTableViewCell.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 02.02.2022.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {
    
//    private var workoutModel = WorkoutModel()
//    private var workoutModel = DifferenceWorkout()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutBeforeLabel = UILabel(text: "Before: 20")

    private let workoutNowLabel = UILabel(text: "Now: 20")
    
    private var beforeAndNowStackView = UIStackView()
    
    private let workoutNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+2"
        label.textColor = .specialGreen
        label.font = .robotoMedium24()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .specialLine
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(model: WorkoutModel) {
//        workoutModel = model
//
//        workoutNameLabel.text = workoutModel.workoutName
//        let (min, sec) = workoutModel.workoutTimer.convertSecond()
//
//        if workoutModel.workoutTimer == 0 {
//            workoutBeforeLabel.text = "Before: \(workoutModel.workoutReps)"
//            workoutNowLabel.text = "Before: \(workoutModel.workoutReps)"
//        } else {
//            workoutBeforeLabel.text = min == 0 ? "Before: \(sec) sec" : "Before: \(min) min \(sec) sec"
//            workoutNowLabel.text = min == 0 ? "Now: \(sec) sec" : "Now: \(min) min \(sec) sec"
//        }
//
//    }
    
    func configure(differenceWorkout: DifferenceWorkout) {
//        workoutModel = model
        
        workoutNameLabel.text = differenceWorkout.name
        let (lastMin, lastSec) = differenceWorkout.lastTimer.convertSecond()
        let (firstMin, firstSec) = differenceWorkout.firstTimer.convertSecond()
        
        var difference = 0
        
        if differenceWorkout.isOneEx {
            workoutNumberLabel.text = "No data"
        } else if differenceWorkout.lastTimer == 0 {
            workoutBeforeLabel.text = "Before: \(differenceWorkout.firstReps)"
            workoutNowLabel.text = "Now: \(differenceWorkout.lastReps)"
            
            difference = differenceWorkout.lastReps - differenceWorkout.firstReps
            workoutNumberLabel.text = "\(difference)"
        } else {
            workoutBeforeLabel.text = firstMin == 0 ? "Before: \(firstSec) sec" : "Before: \(firstMin) min \(firstSec) sec"
            workoutNowLabel.text = lastMin == 0 ? "Now: \(lastSec) sec" : "Now: \(lastMin) min \(lastSec) sec"
            
            difference = differenceWorkout.lastTimer - differenceWorkout.firstTimer
            let (min, sec) = difference.convertSecond()
            
            if min < 0 {
                workoutNumberLabel.text = min == 0 ? "\(sec) sec" : "\(min) min \(-sec) sec"
            } else {
                workoutNumberLabel.text = min == 0 ? "\(sec) sec" : "\(min) min \(sec) sec"
            }
        }
        
        switch difference {
        case ..<0: workoutNumberLabel.textColor = .specialGreen
        case 1...: workoutNumberLabel.textColor  = .specialYellow
        default:
            workoutNumberLabel.textColor = .specialGray
        }
        
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(workoutNameLabel)
        addSubview(workoutNumberLabel)
        beforeAndNowStackView = UIStackView(arrangedSubviews: [workoutBeforeLabel, workoutNowLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        addSubview(beforeAndNowStackView)
        addSubview(workoutLineView)
    }

}

// MARK: - Set Constraints

extension StatisticTableViewCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            workoutNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            workoutNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            beforeAndNowStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 1),
            beforeAndNowStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            workoutLineView.topAnchor.constraint(equalTo: beforeAndNowStackView.bottomAnchor, constant: 3),
            workoutLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            workoutLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            workoutLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
    }
    
}

