import UIKit

class TVViewModel: TVProvider {
	private var tvs: [TV] = []
	private var tvIDs: Set<Int> = []

	func localTVs() -> [TV] {
		return tvs
	}

	func downloadMoreTV() {
		DataDownLoader.shared.downloadData(for: "tv") { [unowned self] (data, statusCode, errorMsg) in
			DispatchQueue.global(qos: .userInitiated).async {
				guard
					let data = data,
					let JSONString = String.init(data: data, encoding: .utf8)
					else { return }
				let newTVs = TV.factory(with: JSONString)
				for tv in newTVs {
					if self.tvIDs.insert(tv.id!).inserted {
						self.tvs.append(tv)
					}
				}
				DispatchQueue.main.async {
					NotificationCenter.default.post(name: NotifName.NewTVsArrived, object: nil)
				}
			}
		}
	}
}
