import UIKit

protocol DropDownVCDelegate: AnyObject {
    func openCloseButtonAction(_ vc: DropDownVC)
}

struct DropDownItem {
    let id: Int
    let image: UIImage
}

enum DropDownType {
    case down
    case up
}

class DropDownVC: UIViewController {
    
    private lazy var openCloseButton = makeOpenCloseButton()
    private lazy var collectionView = makeCollectionView()
    
    private var type: DropDownType
    private var initialFrame: CGRect
    private var parentVC: UIViewController?
    private var items: [DropDownItem] = []
    private var padding: CGFloat = 0
    private var openedImage: UIImage?
    private var closedImage: UIImage?
    
    weak var delegate: DropDownVCDelegate?
    var isOpened: Bool = false
    var tag: String?
    
    init(type: DropDownType, initialFrame: CGRect) {
        self.type = type
        self.initialFrame = initialFrame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "settings_button_color")
        
        view.addSubview(openCloseButton)
        view.addSubview(collectionView)
        
        
        switch type {
        case .down:
            openCloseButton.anchor(
                .leading(view.leadingAnchor),
                .trailing(view.trailingAnchor),
                .top(view.topAnchor),
                .height(initialFrame.height)
            )
            
            collectionView.anchor(
                .leading(view.leadingAnchor),
                .trailing(view.trailingAnchor),
                .top(openCloseButton.bottomAnchor),
                .bottom(view.bottomAnchor)
            )
        case .up:
            openCloseButton.anchor(
                .leading(view.leadingAnchor),
                .trailing(view.trailingAnchor),
                .bottom(view.bottomAnchor),
                .height(initialFrame.height)
            )
            
            collectionView.anchor(
                .leading(view.leadingAnchor),
                .trailing(view.trailingAnchor),
                .top(view.topAnchor),
                .bottom(openCloseButton.topAnchor)
            )
        }
    }
    
    func setup(with parentVC: UIViewController,
               items: [DropDownItem],
               padding: CGFloat,
               openedImage: UIImage? = nil,
               closedImage: UIImage? = nil,
               tag: String? = nil) {
        self.padding = padding
        self.items = items
        self.parentVC = parentVC
        self.openedImage = openedImage
        self.closedImage = closedImage
        self.tag = tag
        
        parentVC.addChild(self)
        parentVC.view.addSubview(self.view)
        self.view.frame = initialFrame
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.didMove(toParent: self)
    }
    
    func animate(with frame: CGRect) {
        let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9) {
            switch self.type {
            case .down:
                self.view.frame.size.height = frame.height
            case .up:
                self.view.frame.origin.y = frame.origin.y
                self.view.frame.size.height = frame.height
            }
        }
        
        animation.startAnimation()
    }
    
    @objc func openCloseButtonAction() {
        delegate?.openCloseButtonAction(self)
        if isOpened {
            animate(with: initialFrame)
            isOpened = false
            UIView.transition(with: openCloseButton,
                              duration: 0.2,
                              options: .transitionCrossDissolve) { [weak self] in
                self?.openCloseButton.setImage(self?.closedImage, for: .normal)
            }
        } else {
            let height = (initialFrame.height * CGFloat(items.count)) + (padding * CGFloat(items.count)) + initialFrame.height
            
            switch type {
            case .down:
                animate(with: CGRect(x: initialFrame.origin.x, y: initialFrame.origin.y, width: initialFrame.width, height: height))
            case .up:
                animate(with: CGRect(x: initialFrame.origin.x, y: initialFrame.origin.y - height + initialFrame.height, width: initialFrame.width, height: height))
            }
            isOpened = true
            UIView.transition(with: openCloseButton,
                              duration: 0.2,
                              options: .transitionCrossDissolve) { [weak self] in
                self?.openCloseButton.setImage(self?.openedImage, for: .normal)
            }
        }
    }
}

extension DropDownVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DropDownCVCell", for: indexPath) as! DropDownCVCell
        cell.setupWith(item: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
}

extension DropDownVC {
    func makeOpenCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.addTarget(self, action: #selector(openCloseButtonAction), for: .touchUpInside)
        return button
    }
    
    func makeCollectionView() -> UICollectionView {
        let collectionView = CollectionView(
            collectionViewFlowLayout: UICollectionViewFlowLayout(),
            scrollDirection: .vertical,
            cells: [ DropDownCVCell.self ]
        )
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
}
