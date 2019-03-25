import UIKit

/**
This is a singleton for network activities
Seperate utilities from VM and can dive deeper in the future wihtout affecting VM.
**/
class DataDownLoader {
	private init() {}

	static let shared = DataDownLoader()

	private let main = DispatchQueue.main
	private let serverQ = DispatchQueue.init(label: "serverQ", qos: .userInitiated)
	private let concurrentQ = DispatchQueue.init(label: "concurrentQ", qos: .background, attributes: .concurrent)

	/**
	Dowload resource.
	- Parameters:
		- for resource: local resource name
	- Note:
		- runs in background queue, complete in main queue.
	**/
	func downloadData(for resource: String, completion: @escaping (_ data: Data?, _ statusCode: Int, _ errorMsg: String) -> Void) {
		serverQ.async { [unowned self] in
			let data = self.downloadData(for: resource)

			self.main.async { completion(data, 200, "") }
		}
	}

	private func downloadData(for resource: String) -> Data? {
		guard
			let location = Bundle.main.path(forResource: resource, ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: location))
			else { return nil }
		return data
	}
}
