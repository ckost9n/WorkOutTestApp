//
//  CalendarView.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 14.01.2022.
//

import UIKit

protocol SelectCollectionViewItemProtocol: AnyObject {
    func selectItem(date: Date)
}

class CalendarView: UIView {
    
    private let idCalendarCell = "idCalendarCell"
    
    weak var cellCollectionViewDelegate: SelectCollectionViewItemProtocol?
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegates()
        
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: idCalendarCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialGreen
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
//    private func weekArray() -> [[String]] {
//
//        let dateFormater = DateFormatter()
//        dateFormater.locale = Locale(identifier: "ru_RU")
//        dateFormater.dateFormat = "EEEEEE"
//
//        var weekArray: [[String]] = [[], []]
//        let calendar = Calendar.current
//        let today = Date()
//
//        for i in -6...0 {
//            let date = calendar.date(byAdding: .weekday, value: i, to: today)
//            guard let date = date else { return weekArray }
//            let components = calendar.dateComponents([.day], from: date)
//            weekArray[1].append(String(components.day ?? 0))
//            let weekday = dateFormater.string(from: date)
//            weekArray[0].append(String(weekday))
//        }
//        return weekArray
//    }

}

// MARK: - UICollectionViewDataSource

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCalendarCell, for: indexPath) as! CalendarCollectionViewCell
        let dateTimeZone = Date().localDate()
        let weekArray = dateTimeZone.getWeekArray()
        cell.configure(numberOfDay: weekArray[1][indexPath.item],
                       dayOfWeek: weekArray[0][indexPath.item])
        
        if indexPath.row == 6 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension CalendarView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dateTimeZone = Date().localDate()
        
        switch indexPath.item {
        case 0:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 6))
        case 1:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 5))
        case 2:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 4))
        case 3:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 3))
        case 4:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 2))
        case 5:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 1))
        default:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 0))
        }
 
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 7.5, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
}

// MARK: - SetConstrains

extension CalendarView {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 105),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
