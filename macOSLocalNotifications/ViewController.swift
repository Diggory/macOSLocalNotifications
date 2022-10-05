//
//  ViewController.swift
//  macOSLocalNotifications
//
//  Created by Diggory Laycock on 02/10/2022.
//

import Cocoa
import Foundation
import UserNotifications

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
	
	var sounds: [String] = []
	let userNotificationCentre = UNUserNotificationCenter.current()
	@IBOutlet var filenamesTable: NSTableView!


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		filenamesTable.doubleAction = #selector(tableViewDoubleAction)

		sounds.append("audacity_wav_16bitPCM.wav")
		sounds.append("audacity.mp3")

		sounds.append("test.caf")
		sounds.append("test-1.caf")
		sounds.append("test.m4a")
		sounds.append("test.wav")
		
		sounds.append("dbl08s.wav")
		sounds.append("ima08s.wav")
		sounds.append("pcm3208s.wav")
		sounds.append("sngl08s.wav")
		sounds.append("ulaw08s.wav")

		sounds.append("M1F1-AlawC-AFsp.aif")
		sounds.append("M1F1-mulawC-AFsp.aif")
		
		sounds.append("notificationSoundBlip_stereo.mp3")
		sounds.append("notificationSoundBlip.mp3")

		sounds.append("toast.caf")
		sounds.append("toast.mp3")

	}
	

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	fileprivate func sendNotification(withSound sound: String) {
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
		noteContent.body = "You have successfully sent a User Notification with soundFile: \(sound)"
		//		noteContent.sound = .default
		
		//	Check that sound file actually exists
		let filePath = Bundle.main.bundlePath + "/contents/resources/" + sound
		print(filePath)
		let exists = FileManager.default.fileExists(atPath: filePath, isDirectory: nil)
		guard exists else {
			print("Sound file not found at: \(filePath)")
			return
		}
		
		//	Custom sound.
		//	DOES NOT WORK - Always uses the default (Tritone).  Grrr...
		let blipCafSubfolderNotificationSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: sound))
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
	
	// MARK: IB Actions

	@IBAction func sendNotification(_ sender: Any) {
//		sendNotification(withSound: "toast.mp3")
		
		guard filenamesTable.selectedRow != -1 else {
			print("cannot send notification. No Sound selected")
			return
		}
		sendNotification(withSound: sounds[filenamesTable.selectedRow])
	}

	@objc func tableViewDoubleAction(sender: AnyObject) {
//		print("row double clicked")
		sendNotification(self)
	}
	
	// MARK: TableView protocols

	func numberOfRows(in tableView: NSTableView) -> Int {
		return sounds.count
	}
	
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		return sounds[row]
	}
	
}

