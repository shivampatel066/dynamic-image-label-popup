// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public class DynamicLabelViewController: UIViewController {
    @IBOutlet public weak var containerView: UIView!
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var quoteLabel: AdjustableHeightLabel!
    @IBOutlet public weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet weak var rewardBottomBanner: UIImageView!
    @IBOutlet weak var rewardTopBanner: UIImageView!
    
    public var quoteText = ""
    public var topImage: UIImage?
    public var midImage: UIImage?
    public var bottomImage: UIImage?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffectView: UIVisualEffectView?
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let blurEffectView = blurEffectView {
            view.addSubview(blurEffectView)
            scaleToFillView(blurEffectView, in: view)
            fadeInView(blurEffectView)
        }
        closeButton.setTitle("", for: .normal)
        closeButton.tintColor = .white
        quoteLabel.heightConstraint = self.labelHeightConstraint
        quoteLabel.text = quoteText
        // Bring all other subviews to the front except the blur effect view
        for subview in view.subviews {
            if !(subview is UIVisualEffectView) {
                view.bringSubviewToFront(subview)
            }
        }
    }
    
    private func scaleToFillView(_ view: UIView, in parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                view.widthAnchor.constraint(equalTo: parent.widthAnchor),
                view.heightAnchor.constraint(equalTo: parent.heightAnchor)
            ]
        )
    }
    
    func fadeInView(_ view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            view.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    public static func present(from viewController: UIViewController, quoteText: String, topImage: UIImage?, midImage: UIImage?, bottomImage: UIImage?) {
        let storyboard = UIStoryboard(name: "DynamicLabelViewController", bundle: .module)
        guard let dynamicLabelVC = storyboard.instantiateViewController(withIdentifier: "DynamicLabelViewController") as? DynamicLabelViewController else {
            fatalError("Unable to instantiate DynamicLabelViewController from storyboard")
        }
        dynamicLabelVC.quoteText = quoteText
        dynamicLabelVC.topImage = topImage ?? UIImage(named: "rewardTopBanner")
        dynamicLabelVC.midImage = midImage ?? UIImage(named: "rewardMidBanner")
        dynamicLabelVC.bottomImage = bottomImage ?? UIImage(named: "rewardBottomBanner")
        dynamicLabelVC.modalTransitionStyle = .crossDissolve
        dynamicLabelVC.modalPresentationStyle = .overCurrentContext
        viewController.present(dynamicLabelVC, animated: true, completion: nil)
    }
    
    public func updateHeightConstraint() {
        let newHeight = calculateHeightForText(quoteLabel.text ?? "", width: quoteLabel.frame.width)
        labelHeightConstraint.constant = newHeight
    }
    
    private func calculateHeightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = quoteLabel.font ?? UIFont.systemFont(ofSize: 17)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}

public class AdjustableHeightLabel: UILabel {
    public var heightConstraint: NSLayoutConstraint?
    public override var text: String? {
        didSet {
            adjustHeight()
        }
    }
    private func adjustHeight() {
        guard let text = text, let heightConstraint = heightConstraint else { return }
        let newHeight = calculateHeightForText(text, width: frame.width)
        heightConstraint.constant = newHeight
        layoutIfNeeded()
    }
    private func calculateHeightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = self.font ?? UIFont.systemFont(ofSize: 17)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}
