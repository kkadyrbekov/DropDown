import UIKit

open class CollectionViewCell<ContentView: BaseCV>: UICollectionViewCell {
    public let mainContentView = ContentView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainContentView)
        self.mainContentView.fillSuperview()
        self.backgroundColor = .clear
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

public protocol BaseCV: UIView, ContentViewSetupable {
    func setProperties()
}

public extension BaseCV {
    func setProperties() {
        backgroundColor = .white
    }
}

public protocol ContentViewSetupable {
    func setSubviews()
    func setConstraints()
}
