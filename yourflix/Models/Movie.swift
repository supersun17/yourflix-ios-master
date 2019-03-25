import Foundation
import ObjectMapper

/**
This is a Data Model mapping a single Movie JSON
**/
class Movie: Mappable {
	var imageString: String?
	var id: Int?

	required init?(map: Map) {}

	// Mappable
	func mapping(map: Map) {
		imageString    <- map["imageUrl"]
		id <- map["id"]
	}

	/**
	Use this funciton to convert JSONString to Movie objects array.
	**/
	static func factory(with JSONString: String) -> [Movie] {
		if let movies = Mapper<Movie>().mapArray(JSONString: JSONString) {
			return movies
		} else {
			return []
		}
	}
}
