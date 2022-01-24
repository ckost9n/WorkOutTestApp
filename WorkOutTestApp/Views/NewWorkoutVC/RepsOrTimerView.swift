//
//  RepsOrTimerView.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 20.01.2022.
//

import UIKit

class RepsOrTimerView: UIView {
    
    private var mainStackView: UIStackView = {
       let stackView = UIStackView()
        
        return stackView
    }()
    
    private let setsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.textAlignment = .left
        label.text = "Sets"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfSetsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.textAlignment = .right
        label.text = "0"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var setsSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 50
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.addTarget(self, action: #selector(setsSliderChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var repeatOrTimerLabel = UILabel.init(text: "Choose repeat or timer")
    
    private let repsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.textAlignment = .left
        label.text = "Reps"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfRepsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.textAlignment = .right
        label.text = "0"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var repsSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 50
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.addTarget(self, action: #selector(repsSliderChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let timerLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.textAlignment = .left
        label.text = "Timer"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfTimerLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.textAlignment = .right
        label.text = "0 min"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timerSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 600
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.addTarget(self, action: #selector(timerSliderChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var setsStackView = UIStackView()
    private var repsStackView = UIStackView()
    private var timerStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    @objc private func setsSliderChanged() {
        numberOfSetsLabel.text = "\(Int(setsSlider.value))"
    }
    
    @objc private func repsSliderChanged() {
        numberOfRepsLabel.text = "\(Int(repsSlider.value))"
        
        setNegative(label: timerLabel, numberLabel: numberOfTimerLabel, slider: timerSlider)
        setActive(label: repsLabel, numberLabel: numberOfRepsLabel, slider: repsSlider)
    }
    
    @objc private func timerSliderChanged() {
        
        
        let (min, sec) = { (secs: Int) -> (Int, Int) in
            return (secs / 60, secs % 60)
        }(Int(timerSlider.value))
        
        if min == 0, sec != 0 {
            numberOfTimerLabel.text = "\(sec) sec"
        } else if sec != 0 {
            numberOfTimerLabel.text = "\(min) min, \(sec) sec"
        } else {
            numberOfTimerLabel.text = "\(min) min"
        }
        
        setNegative(label: repsLabel, numberLabel: numberOfRepsLabel, slider: repsSlider)
        setActive(label: timerLabel, numberLabel: numberOfTimerLabel, slider: timerSlider)
        
    }
    
    private func setActive(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 1
        numberLabel.alpha = 1
        slider.alpha = 1
    }
    
    private func setNegative(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 0.5
        numberLabel.alpha = 0.5
        slider.alpha = 0.5
        numberLabel.text = "0"
        slider.value = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        repeatOrTimerLabel.textAlignment = .center
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel, numberOfSetsLabel],
                                    axis: .horizontal, spacing: 10)
        
        repsStackView = UIStackView(arrangedSubviews: [repsLabel, numberOfRepsLabel],
                                    axis: .horizontal, spacing: 10)
        
        timerStackView = UIStackView(arrangedSubviews: [timerLabel, numberOfTimerLabel],
                                    axis: .horizontal, spacing: 10)
        
        mainStackView = UIStackView(arrangedSubviews: [setsStackView, setsSlider, repeatOrTimerLabel, repsStackView, repsSlider, timerStackView, timerSlider],
                                    axis: .vertical, spacing: 10)
        
        addSubview(mainStackView)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
    }

}
