// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public class DynamicLabelViewController: UIViewController {
    @IBOutlet public weak var containerView: UIView!
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var quoteLabel: AdjustableHeightLabel!
    @IBOutlet public weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var closeButton: UIButton!  // Outlet for the close button
    
    public var quoteText = ""
    public var topImage: UIImage?
    public var midImage: UIImage?
    public var bottomImage: UIImage?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("", for: .normal)
        quoteLabel.heightConstraint = self.labelHeightConstraint
        quoteLabel.text = quoteText
        
        setupGestureRecognizers()
    }
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
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
