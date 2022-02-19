//
//  UITextField + Extansion.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 11.02.2022.
//

import Foundation
import UIKit

extension UITextField {
    
    convenience init(cornerRadius: CGFloat, leftViewWidth: CGFloat) {
        self.init()
        self.backgroundColor = .specialBrown
        self.borderStyle = .none
        self.layer.cornerRadius = cornerRadius
        self.textColor = .specialGray
        self.font = .robotoBold20()
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewWidth, height: self.frame.height))
        self.leftViewMode = .always
        self.clearButtonMode = .always
        self.returnKeyType = .done
//        self.keyboardType = .numberPad
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
