import UIKit

/**
This is a middle layer that allows VC to inject VM when using a storyboard.
**/
class ViewModelFactory {
	static func getMovieViewModel() -> MovieProvider {
		return MovieViewModel()
	}

	static func getTVViewModel() -> TVProvider {
		return TVViewModel()
	}
}
