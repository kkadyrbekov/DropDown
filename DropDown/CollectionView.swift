import UIKit

public class CollectionView: UICollectionView {
    public init(
        collectionViewFlowLayout: UICollectionViewFlowLayout? = nil,
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        backgroundColor: UIColor = .clear,
        cells: [AnyClass],
        isPagingEnabled: Bool = false,
        dataSource: UICollectionViewDataSource? = nil,
        delegate: UICollectionViewDelegateFlowLayout? = nil,
        contentInset: UIEdgeInsets = .zero,
        refreshControl: UIRefreshControl? = nil) {
        collectionViewFlowLayout?.scrollDirection = scrollDirection
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout ?? UICollectionViewFlowLayout())
        self.backgroundColor = backgroundColor
        self.delegate = delegate
        self.dataSource = dataSource
        self.contentInset = contentInset
        self.refreshControl = refreshControl
        self.isPagingEnabled = isPagingEnabled
        self.backgroundView?.isHidden = false
        self.backgroundView?.alpha = 0
        cells.forEach { register($0, forCellWithReuseIdentifier: String(describing: $0)) }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}

extension UICollectionViewFlowLayout {
    static func with(estimatedItemSize: CGSize) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = estimatedItemSize
        return layout
    }
}
