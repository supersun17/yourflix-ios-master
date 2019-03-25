import UIKit

protocol TVProvider {
	func localTVs() -> [TV]
	func downloadMoreTV()
}

class TVViewController: UICollectionViewController {
    var dataProvider: TVProvider?

    override func viewDidLoad() {
        super.viewDidLoad()

		collectionView?.dataSource = self
		collectionView?.delegate = self
		dataProvider = ViewModelFactory.getTVViewModel()
		dataProvider?.downloadMoreTV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(newTVsArrived), name: NotifName.NewTVsArrived, object: nil)
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		NotificationCenter.default.removeObserver(self, name: NotifName.NewTVsArrived, object: nil)
	}

	@objc func newTVsArrived() {
		collectionView?.reloadData()
	}

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider?.localTVs().count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tv", for: indexPath) as? TVCell else { fatalError("tv cell dequeue failed") }
        
        return tvCell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard
			let tvCell = cell as? TVCell,
			let asset = dataProvider?.localTVs()[indexPath.row]
			else { return }

		guard
			let endpoint = asset.imageString,
			let url = URL(string: "https:\(endpoint)")
			else { return }
		
		let request = URLRequest(url: url)

		tvCell.imageDownloadTask = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data else { return }

			DispatchQueue.main.async {
				tvCell.imageView.image = UIImage(data: data)
			}
		}

		tvCell.imageDownloadTask?.resume()
    }
}
