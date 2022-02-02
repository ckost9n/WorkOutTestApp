//
//  WorkoutParametersView.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 25.01.2022.
//

import UIKit

protocol NextSetProtocol: AnyObject {
    func nextSetTapped()
    func editingTapped()
}

class WorkoutParametersView: UIView {
    
    let workoutNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let setsLabel: UILabel = {
       let label = UILabel()
        label.text = "Sets"
        label.textColor = .specialGray
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfSetsLabel: UILabel = {
       let label = UILabel()
        label.text = "1/4"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let repsOrTimerLabel: UILabel = {
       let label = UILabel()
        label.text = "Reps"
        label.textColor = .specialGray
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfRepsOrTimerLabel: UILabel = {
       let label = UILabel()
        label.text = "20"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let repsLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "editButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialLightBrown
        button.titleLabel?.font = .robotoMedium16()
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextSetsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT SET", for: .normal)
        button.backgroundColor = .specialYellow
        button.tintColor = .specialGray
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .robotoBold16()
        button.addTarget(self, action: #selector(nextSetsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var repsStackView = UIStackView()
    private var setsStackView = UIStackView()
    
    weak var cellNextSetDelegate: NextSetProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    @objc func editingButtonTapped() {
        cellNextSetDelegate?.editingTapped()
    }
    
    @objc func nextSetsButtonTapped() {
        cellNextSetDelegate?.nextSetTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(workoutNameLabel)
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel, numberOfSetsLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        
        addSubview(setsStackView)
        addSubview(setsLineView)
        
        repsStackView = UIStackView(arrangedSubviews: [repsOrTimerLabel, numberOfRepsOrTimerLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        addSubview(repsStackView)
        addSubview(repsLineView)
        addSubview(editingButton)
        addSubview(nextSetsButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            setsStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 10),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            setsStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            setsLineView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 2),
            setsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            setsLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            repsStackView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 10),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            repsStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            repsLineView.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 2),
            repsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            repsLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            editingButton.topAnchor.constraint(equalTo: repsLineView.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            editingButton.heightAnchor.constraint(equalToConstant: 20),
            editingButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            nextSetsButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 10),
            nextSetsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextSetsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextSetsButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
    
}
