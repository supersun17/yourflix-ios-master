import UIKit

class MovieViewModel: MovieProvider {
	private var movies: [Movie] = []
	private var movieIDs: Set<Int> = []

	/**
	Acquire all downloaded movies from VM
	- Returns: array of movie
	**/
	func localMovies() -> [Movie] {
		return movies
	}

	/**
	Download more movie data. If paging is implemented, after the first page has been downloaded, will try to download next page.
	Once data is dowloaded, it will be converted to array of movies, and eventually, a notification will be broadcasted.
	**/
	func downloadMoreMovie() {
		DataDownLoader.shared.downloadData(for: "movies") { [unowned self] (data, statusCode, errorMsg) in
			DispatchQueue.global(qos: .userInitiated).async {
				guard
					let data = data,
					let JSONString = String.init(data: data, encoding: .utf8)
					else { return }
				let newMovies = Movie.factory(with: JSONString)
				for movie in newMovies {
					if self.movieIDs.insert(movie.id!).inserted {
						self.movies.append(movie)
					}
				}
				DispatchQueue.main.async {
					NotificationCenter.default.post(name: NotifName.NewMoviesArrived, object: nil)
				}
			}
		}
	}
}
