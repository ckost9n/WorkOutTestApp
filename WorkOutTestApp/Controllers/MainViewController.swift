//
//  ViewController.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 14.01.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    private let idWorkOutTableViewCell = "idWorkOutTableViewCell"
    
    private let testDataArray: [WorkoutTestModel] = WorkoutTestModel.getWorkoutModel()
    
    private let userPhotoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//    private let calendarView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .specialGreen
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Hello New User!!!"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.setTitle("Add workout", for: .normal)
        button.titleLabel?.font = .robotoMedium12()
        button.tintColor = .specialDarkGreen
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 20,
                                              bottom: 15,
                                              right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 50,
                                              left: -40,
                                              bottom: 0,
                                              right: 0)
        button.setImage(UIImage(named: "addWorkout"), for: .normal)
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let workoutLabel: UILabel = {
       let label = UILabel()
        label.text = "Workout today"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "FrameWorkout")
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.isHidden = true
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.isHidden = true
        return tableView
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>! = nil
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
        calendarView.layer.cornerRadius = calendarView.frame.height / 7
        addWorkoutButton.layer.cornerRadius = addWorkoutButton.frame.height / 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegate()
        getWotkouts(date: Date())
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: idWorkOutTableViewCell)
        
        workoutImageView.isHidden = true
//        tableView.isHidden = true
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        calendarView.cellCollectionViewDelegate = self
    }
    
    @objc private func addWorkoutButtonTapped() {
        let newWorkoutVC = NewWorkoutViewController()
        newWorkoutVC.modalPresentationStyle = .fullScreen
        present(newWorkoutVC, animated: true)
        
    }
    
    private func getWotkouts(date: Date) {
        
        let dateTimeZone = date.localDate()
        let weekday = dateTimeZone.getWeekdayNumber()
        let dateStart = dateTimeZone.startEndDate().0
        let dateEnd = dateTimeZone.startEndDate().1
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let pridecateUnrepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, pridecateUnrepeat])
        
        workoutArray = localRealm.objects(WorkoutModel.self).filter(compound).sorted(byKeyPath: "workoutName")
        tableView.reloadData()
        
    }

    private func setupViews() {
        
        view.backgroundColor = .specialBackground
        view.addSubview(calendarView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutLabel)
        view.addSubview(workoutImageView)
        view.addSubview(tableView)
        tableView.delaysContentTouches = false
    }

}

// MARK: - SelectCollectionViewItemProtocol

extension MainViewController: SelectCollectionViewItemProtocol {
    
    func selectItem(date: Date) {
        getWotkouts(date: date)
    }

}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idWorkOutTableViewCell, for: indexPath) as! WorkoutTableViewCell
        
        let model = workoutArray[indexPath.row]
        cell.configure(model: model)
        cell.cellStartWorkoutDelegate = self
        
        return cell
    }
 
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            let deleteModel = self.workoutArray[indexPath.row]
            RealmManager.shared.deleteWorkoutModel(model: deleteModel)
            tableView.reloadData()
        }
        
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
}

// MARK: - StartWorkoutProtocol

extension MainViewController: StartWorkoutProtocol {
    
    func startButtonTapped(model: WorkoutModel) {
        
        if model.workoutTimer == 0 {
            
            let repsWorkoutVC = RepsWorkoutViewController()
            repsWorkoutVC.modalPresentationStyle = .fullScreen
            repsWorkoutVC.workoutModel = model
            present(repsWorkoutVC, animated: true)
        } else {
            let timerWorkoutVC = TimerWorkoutViewController()
            timerWorkoutVC.modalPresentationStyle = .fullScreen
            timerWorkoutVC.workoutModel = model
            present(timerWorkoutVC, animated: true)
            
        }
    }
}



// MARK: - Set Constraints

extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 6),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            weatherView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            workoutLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10),
            workoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            workoutImageView.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 20),
            workoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 68),
            workoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
}
