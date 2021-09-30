import UIKit

class BaseViewController: UIViewController {
    
    lazy var dropDownVC = makeDropDownVC()
    lazy var dropDownVC2 = makeDropDownVC2()
    
    
    var items: [DropDownItem] = [.init(id: 0, image: UIImage(named: "mic")!),
                                 .init(id: 1, image: UIImage(named: "volume")!),
                                 .init(id: 2, image: UIImage(named: "camera")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dropDownVC.delegate = self
        dropDownVC.setup(with: self,
                         items: items,
                         padding: 8,
                         openedImage: UIImage(named: "arrow_top"),
                         closedImage: UIImage(named: "settings"),
                         tag: "dropDownVC")
        
        dropDownVC2.delegate = self
        dropDownVC2.setup(with: self,
                          items: items,
                          padding: 8,
                          openedImage: UIImage(named: "arrow_top"),
                          closedImage: UIImage(named: "settings"),
                          tag: "dropDownVC2")
        
        
    }
}

extension BaseViewController: DropDownVCDelegate {
    func openCloseButtonAction(_ vc: DropDownVC) {
        print(vc.tag ?? "")
    }
}

extension BaseViewController {
    func makeDropDownVC() -> DropDownVC {
        let vc = DropDownVC(type: .down, initialFrame: CGRect(x: view.frame.width - 20 - 40, y: 80, width: 40, height: 40))
        vc.view.layer.cornerRadius = 20
        return vc
    }
    
    func makeDropDownVC2() -> DropDownVC {
        let vc = DropDownVC(type: .up, initialFrame: CGRect(x: view.frame.width - 20 - 40, y: view.frame.height - 40 - 80, width: 40, height: 40))
        vc.view.layer.cornerRadius = 20
        return vc
    }
}


