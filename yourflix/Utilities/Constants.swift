import Foundation

/**
	VC and VM will communicate with NotificationCenter
*/
struct NotifName {
	static let NewMoviesArrived = Notification.Name(rawValue: "NewMoviesArrived")
	static let NewTVsArrived = Notification.Name(rawValue: "NewTVsArrived")
}

