//
//  AppDelegate.swift
//  macOSLocalNotifications
//
//  Created by Diggory Laycock on 02/10/2022.
//

import Cocoa
import UserNotifications

@main
class AppDelegate: NSObject, NSApplicationDelegate {


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		print("app finished launching")
		UNUserNotificationCenter.current().delegate = self
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}


}



extension AppDelegate: UNUserNotificationCenterDelegate {
	//	Allow notifications to be presesnted when app is foremost.
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		return completionHandler([.list, .sound])
	}
}
