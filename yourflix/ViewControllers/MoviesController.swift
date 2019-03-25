import UIKit


/**
Definded this protocol to describe a VM for this VC. The VM will be introduced by injection.
**/
protocol MovieProvider {
	func localMovies() -> [Movie]
	func downloadMoreMovie()
}

class MoviesController: UICollectionViewController {
	var dataProvider: MovieProvider?

    override func viewDidLoad() {
        super.viewDidLoad()

		collectionView?.dataSource = self
		collectionView?.delegate = self
		dataProvider = ViewModelFactory.getMovieViewModel()
		dataProvider?.downloadMoreMovie()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

		NotificationCenter.default.addObserver(self, selector: #selector(newMoviesArrived), name: NotifName.NewMoviesArrived, object: nil)
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		NotificationCenter.default.removeObserver(self, name: NotifName.NewMoviesArrived, object: nil)
	}

	@objc func newMoviesArrived() {
		collectionView?.reloadData()
	}
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider?.localMovies().count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let moviesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movie", for: indexPath) as? MoviesCell else { fatalError("movie cell dequeue failed") }
        
        return moviesCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
			let moviesCell = cell as? MoviesCell,
			let asset = dataProvider?.localMovies()[indexPath.row]
			else { return }

        guard
            let endpoint = asset.imageString,
            let url = URL(string: "https:\(endpoint)")
            else { return }

		let request = URLRequest(url: url)

		moviesCell.imageDownloadTask = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data else { return }

			DispatchQueue.main.async {
				moviesCell.imageView.image = UIImage(data: data)
			}
		}

		moviesCell.imageDownloadTask?.resume()
    }
}
