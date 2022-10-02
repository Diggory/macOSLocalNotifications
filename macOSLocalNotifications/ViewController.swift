//
//  ViewController.swift
//  macOSLocalNotifications
//
//  Created by Diggory Laycock on 02/10/2022.
//

import Cocoa
import Foundation
import UserNotifications

class ViewController: NSViewController {
	
	let userNotificationCentre = UNUserNotificationCenter.current()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func sendNotification(_ sender: Any) {
		print("sending notification")
		
		//	Request for the right to send notifications
		userNotificationCentre.requestAuthorization(options: [.alert, .sound]) { authorised, error in
			if authorised {
				print("App is now authorised to send notifications")
			} else if !authorised {
				print("App is NOT authorised to send notifications!")
			} else {
				print(error?.localizedDescription as Any)
			}
		}
		
		userNotificationCentre.getNotificationSettings { settings in
			if settings.authorizationStatus != .authorized {
				print("can't send notification, not authorised")
				return
			}
		}
		
		let noteContent = UNMutableNotificationContent()
		
		noteContent.title = "Notified!"
		noteContent.subtitle = "We sent a notification"
		noteContent.body = "You have successfully sent a User Notification"
		//		noteContent.sound = .default

		//	Custom sound.
		//	DOES NOT WORK - Always uses the default (Tritone).  Grrr...
		let blipCafSubfolderNotificationSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notificationSoundBlip.caf"))
		noteContent.sound = blipCafSubfolderNotificationSound

		
		let id = "test"
		
		//	Send just after now…
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
		let request = UNNotificationRequest(identifier: id, content: noteContent, trigger: trigger)
		
		//	Actually schedule it
		userNotificationCentre.add(request) { error in
			if error != nil {
				print("Error requesting notification: \(error?.localizedDescription as Any)")
			}
		}

	}
	
}

