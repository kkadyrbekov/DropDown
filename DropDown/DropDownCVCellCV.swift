import UIKit

final class DropDownCVCellCV: UIView, BaseCV {
    
    public lazy var imageView = makeImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubviews() {
        addSubview(imageView)
    }
    
    func setConstraints() {
        imageView.anchor(
            .leading(leadingAnchor, constant: 8),
            .trailing(trailingAnchor, constant: 8),
            .top(topAnchor),
            .bottom(bottomAnchor)
        )
    }
}

private extension DropDownCVCellCV {
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
