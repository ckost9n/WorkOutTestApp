//
//  WorkoutTestModel.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 15.01.2022.
//

import UIKit

struct WorkoutTestModel {
    let nameExercise: String
    let duration: String
    let durationNumber: String
    let setsNumber: Int
    let exerciseImage: UIImage
    
    static func getWorkoutModel() -> [WorkoutTestModel] {
        var workArray: [WorkoutTestModel] = []
        workArray.append(WorkoutTestModel(nameExercise: "Pull Ups",
                             duration: "Reps",
                             durationNumber: "10",
                             setsNumber: 2,
                             exerciseImage: UIImage(named: "Pull Ups")!))
        workArray.append(WorkoutTestModel(nameExercise: "Push Ups",
                             duration: "Reps",
                             durationNumber: "20",
                             setsNumber: 4,
                             exerciseImage: UIImage(named: "Push Ups")!))
        workArray.append(WorkoutTestModel(nameExercise: "Biceps",
                             duration: "Reps",
                             durationNumber: "15",
                             setsNumber: 3,
                             exerciseImage: UIImage(named: "Biceps")!))
        workArray.append(WorkoutTestModel(nameExercise: "Triceps",
                             duration: "Reps",
                             durationNumber: "10",
                             setsNumber: 4,
                             exerciseImage: UIImage(named: "Triceps")!))
        workArray.append(WorkoutTestModel(nameExercise: "Squats",
                             duration: "Timer",
                             durationNumber: "1 min 10 sec",
                             setsNumber: 4,
                             exerciseImage: UIImage(named: "Squats")!))
       
        return workArray
    }
}
