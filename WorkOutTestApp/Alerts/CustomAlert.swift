//
//  CustomAlert.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 31.01.2022.
//

import UIKit

class CustomAlert {
    
    private let backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private var mainView: UIView?
    private let setsTexField = UITextField()
    private let repsTexField = UITextField()
    let repsOrTimerLabel = UILabel(text: "Reps")
    var buttonAction: ((String, String) -> Void)?
    
    func alertCustom(viewController: UIViewController, complition: @escaping (String, String) -> Void) {
        
        registerForKeyboardNotification()
        
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40,
                                 y: -420,
                                 width: parentView.frame.width - 80,
                                 height: 420)
        scrollView.addSubview(alertView)
        
        let sportsmenImageView = UIImageView(frame: CGRect(
            x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
            y: 30,
            width: alertView.frame.height * 0.4,
            height: alertView.frame.height * 0.4
            )
        )
        
        sportsmenImageView.image = UIImage(named: "Girl")
        sportsmenImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmenImageView)
        
        let editingLabel = UILabel(frame: CGRect(x: 10,
                                                 y: alertView.frame.height * 0.4 + 50,
                                                 width: alertView.frame.width - 20,
                                                 height: 25))
        editingLabel.text = "Editing"
        editingLabel.textAlignment = .center
        editingLabel.font = .robotoMedium22()
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(x: 30,
                                 y: editingLabel.frame.maxY + 10,
                                 width: alertView.frame.width - 60,
                                 height: 20)
        alertView.addSubview(setsLabel)
        
        setsTexField.frame = CGRect(x: 20,
                                    y: setsLabel.frame.maxY,
                                    width: alertView.frame.width - 40,
                                    height: 30)
        setsTexField.backgroundColor = .specialBrown
        setsTexField.borderStyle = .none
        setsTexField.layer.borderWidth = 0
        setsTexField.layer.cornerRadius = 10
        setsTexField.textColor = .specialGray
        setsTexField.font = .robotoBold20()
        setsTexField.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 15,
                                                     height: setsTexField.frame.height))
        setsTexField.leftViewMode = .always
        setsTexField.clearButtonMode = .always
        setsTexField.returnKeyType = .done
        setsTexField.keyboardType = .numberPad
        alertView.addSubview(setsTexField)
        
//        repsOrTimerLabel = UILabel(text: "Rets")
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(x: 30,
                                 y: setsTexField.frame.maxY + 3,
                                 width: alertView.frame.width - 60,
                                 height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTexField.frame = CGRect(x: 20,
                                    y: repsOrTimerLabel.frame.maxY,
                                    width: alertView.frame.width - 40,
                                    height: 30)
        repsTexField.backgroundColor = .specialBrown
        repsTexField.borderStyle = .none
        repsTexField.layer.borderWidth = 0
        repsTexField.layer.cornerRadius = 10
        repsTexField.textColor = .specialGray
        repsTexField.font = .robotoBold20()
        repsTexField.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 15,
                                                     height: repsTexField.frame.height))
        repsTexField.leftViewMode = .always
        repsTexField.clearButtonMode = .always
        repsTexField.returnKeyType = .done
        repsTexField.keyboardType = .numberPad
        alertView.addSubview(repsTexField)
        
        let okButton = UIButton(frame: CGRect(x: 50,
                                              y: repsTexField.frame.maxY + 15,
                                              width: alertView.frame.width - 100,
                                              height: 35))
        okButton.backgroundColor = .specialGreen
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.titleLabel?.font = .robotoMedium18()
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = complition
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func dismissAlert() {
        
        guard let setsNumber = setsTexField.text else { return }
        guard let repsNumber = repsTexField.text else { return }
        
        buttonAction?(setsNumber, repsNumber)
        
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.height,
                                          width: targetView.frame.width - 80,
                                          height: 420)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.alpha = 0
                } completion: { [weak self] done in
                    guard let self = self else { return }
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.scrollView.removeFromSuperview()
                        self.removeKeyboardNotification()
                        self.setsTexField.text = ""
                        self.repsTexField.text = ""
                    }
                }
            }
        }
    }
    
    private func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func removeKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyBoardWillShow() {
        scrollView.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc private func keyBoardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
