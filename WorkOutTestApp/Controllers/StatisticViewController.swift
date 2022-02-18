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
    
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>! = nil
    
    private var differenceArray = [DifferenceWorkout]()
    private var filtredArray = [DifferenceWorkout]()
    
    private let dateToday = Date().localDate()
    private var isFiltred = false
    
    private let searchTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
        
        view.addSubview(searchTextField)
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
        searchTextField.delegate = self
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
        
        switch mySegmentedControl.selectedSegmentIndex {
        case 0:
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        case 1:
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        default:
            print("segmented error")
        }
    }
    
    private func filtringWorkouts(text: String) {
        
        for workout in differenceArray {
            if workout.name.lowercased().contains(text.lowercased()) {
                filtredArray.append(workout)
            }
        }
        
    }

}

// MARK: - UITextFieldDelegate

extension StatisticViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else { return false}
        let updateText = text.replacingCharacters(in: textRange, with: string)
        filtredArray = [DifferenceWorkout]()
        isFiltred = updateText.count > 0 ? true : false
        filtringWorkouts(text: updateText)
        tableView.reloadData()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isFiltred = false
        differenceArray = [DifferenceWorkout]()
        
        let dateStart = mySegmentedControl.selectedSegmentIndex == 0
        ? dateToday.offsetDays(days: 7) : dateToday.offsetMonth(month: 1)
        
        getDifferenceModel(dateStart: dateStart)
        tableView.reloadData()
        return true
    }
    
}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltred ? filtredArray.count : differenceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StatisticTableViewCell
        
        let differenceModel = isFiltred ? filtredArray[indexPath.row] : differenceArray[indexPath.row]
        cell.configure(differenceWorkout: differenceModel)

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
            searchTextField.topAnchor.constraint(equalTo: mySegmentedControl.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            exercisesLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
