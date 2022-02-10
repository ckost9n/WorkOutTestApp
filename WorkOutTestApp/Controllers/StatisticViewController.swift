//
//  StaisticViewController.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 20.01.2022.
//

import UIKit
import RealmSwift

struct DifferenceWorkout {
    let name: String
    let lastReps: Int
    let firstReps: Int
    let lastTimer: Int
    let firstTimer: Int
    let isOneEx: Bool
}

class StatisticViewController: UIViewController {
    
    private let cellIdentifier = "statisticTableViewCell"
    let dateToday = Date().localDate()
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>! = nil
    
    var differenceArray = [DifferenceWorkout]()
    
    private let statisticLabel: UILabel = {
        let label = UILabel()
        label.text = "STATISTICS"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var mySegmentedControl: UISegmentedControl = {
        let mySegmentedControl = UISegmentedControl(items: ["Неделя", "Месяц"])
        mySegmentedControl.selectedSegmentIndex = 0
        mySegmentedControl.selectedSegmentTintColor = .specialYellow
        mySegmentedControl.backgroundColor = .specialGreen
        mySegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.robotoMedium16() as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white],
                                                  for: .normal)
        mySegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.robotoMedium16() as Any,
            NSAttributedString.Key.foregroundColor: UIColor.specialGray],
                                                  for: .selected)
        mySegmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
        mySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return mySegmentedControl
    }()

    private let exercisesLabel = UILabel(text: "Exercises")

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: - Life Cycle View Controller
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        getDate()
        setupViews()
        setConstraints()
        setDelegate()
        setStartScreen()

    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(statisticLabel)
        view.addSubview(mySegmentedControl)
        view.addSubview(exercisesLabel)
        view.addSubview(tableView)
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setStartScreen() {
        getDifferenceModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getWorkoutsName() -> [String] {
        
        var nameArray: [String] = []
        workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        
        let dateEnd = dateToday
        let nameArray = getWorkoutsName()
        
        for name in nameArray {

            let predicateDifference = NSPredicate(
                format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])
            workoutArray = localRealm.objects(WorkoutModel.self)
                .filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            
            var lastOfTimer = 0
            var firstOfTimer = 0
            var lastOfReps = 0
            var firstOfReps = 0
            
            let isEx = (workoutArray.count == 1)

            if workoutArray.last?.workoutTimer == 0 {
                lastOfReps = workoutArray.last?.workoutReps ?? 0
                lastOfTimer = 0
            } else {
                lastOfTimer = workoutArray.last?.workoutTimer ?? 0
                lastOfReps = 0
            }
            
            if workoutArray.first?.workoutTimer == 0 {
                firstOfReps = workoutArray.first?.workoutReps ?? 0
                firstOfTimer = 0
            } else {
                firstOfTimer = workoutArray.first?.workoutTimer ?? 0
                firstOfReps = 0
            }
            
//            guard let last = workoutArray.last?.workoutReps,
//                  let first = workoutArray.first?.workoutReps else {
//                      return
//                  }
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: lastOfReps, firstReps: firstOfReps, lastTimer: lastOfTimer, firstTimer: firstOfTimer, isOneEx: isEx)
            differenceArray.append(differenceWorkout)
        }
    }

    @objc private func segmentedControlTapped() {
        
        print("Tap")
        
        switch mySegmentedControl.selectedSegmentIndex {
        case 0:
            print("Неделя")
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        case 1:
            print("Месяц")
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        default:
            print("segmented error")
        }
    }

}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        workoutArray.count
        differenceArray.count
//        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StatisticTableViewCell
        
        let differenceModel = differenceArray[indexPath.row]
        cell.configure(differenceWorkout: differenceModel)

//        let model = workoutArray[indexPath.row]
//        cell.configure(model: model)

        return cell
    }


}

// MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

// MARK: - Set Constraints

extension StatisticViewController {

    private func setConstraints() {

        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            mySegmentedControl.topAnchor.constraint(equalTo: statisticLabel.bottomAnchor, constant: 30),
            mySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            exercisesLabel.topAnchor.constraint(equalTo: mySegmentedControl.bottomAnchor, constant: 10),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }

}
