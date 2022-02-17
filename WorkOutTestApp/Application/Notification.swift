//
//  Notification.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 17.02.2022.
//

import UIKit
import UserNotifications

class Notification: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorizarion() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { setting in
            print(setting)
        }
    }
    
    func scheduleDateNotification(date: Date, id: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "WORKOUT"
        content.body = "Today you have training"
        content.sound = .default
        content.badge = 1
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 16
        triggerDate.minute = 29
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            print("Error \(error?.localizedDescription ?? "error")")
        }
        
    }
    
}

extension Notification: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.removeAllDeliveredNotifications()
    }
    
  
}
