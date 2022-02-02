//
//  Int + Extension.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 01.02.2022.
//

import Foundation

extension Int {
    
    func convertSecond() -> (Int, Int) {
        let min = self / 60
        let sec = self % 60
        return (min, sec)
    }
    
    func setZeroForSeconds() -> String {
        return Double(self) / 10.0 < 1 ? "0\(self)" : "\(self)"
    }
    
}
