import Foundation
import ObjectMapper

class TV: Mappable {
	var imageString: String?
	var id: Int?

	required init?(map: Map) {}

	// Mappable
	func mapping(map: Map) {
		imageString    <- map["imageUrl"]
		id <- map["id"]
	}

	static func factory(with JSONString: String) -> [TV] {
		if let tvs = Mapper<TV>().mapArray(JSONString: JSONString) {
			return tvs
		} else {
			return []
		}
	}
}
