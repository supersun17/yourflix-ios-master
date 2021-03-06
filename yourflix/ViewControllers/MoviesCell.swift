import UIKit

class MoviesCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
	var imageDownloadTask: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
		imageDownloadTask?.cancel()
    }
}
