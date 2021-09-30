import UIKit
final class DropDownCVCell: CollectionViewCell<DropDownCVCellCV> {
    
    func setupWith(item: DropDownItem) {
        mainContentView.imageView.image = item.image
    }
    
}
