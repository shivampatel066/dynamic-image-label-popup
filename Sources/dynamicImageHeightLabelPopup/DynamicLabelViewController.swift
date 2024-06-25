// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit

/// ViewController to display a dynamic label with adjustable height.
public class DynamicLabelViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet public weak var containerView: UIView!
    @IBOutlet public weak var rewardMidBanner: UIImageView!
    @IBOutlet public weak var quoteLabel: AdjustableHeightLabel!
    @IBOutlet public weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet weak var rewardBottomBanner: UIImageView!
    @IBOutlet weak var rewardTopBanner: UIImageView!
    
    // MARK: - Properties
    
    public var quoteText = "This is a dynamically adjusted height label!"
    public var topImage: UIImage?
    public var midImage: UIImage?
    public var bottomImage: UIImage?
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
        setupCloseButton()
        setupQuoteLabel()
        bringSubviewsToFront()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the blur effect background.
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        scaleToFillView(blurEffectView, in: view)
        fadeInView(blurEffectView)
    }
    
    /// Configures the close button appearance.
    private func setupCloseButton() {
        closeButton.setTitle("", for: .normal)
        closeButton.tintColor = .white
    }
    
    /// Configures the quote label with initial text and height constraint.
    private func setupQuoteLabel() {
        quoteLabel.heightConstraint = self.labelHeightConstraint
        quoteLabel.text = quoteText
    }
    
    /// Brings all subviews to the front except for the blur effect view.
    private func bringSubviewsToFront() {
        for subview in view.subviews where !(subview is UIVisualEffectView) {
            view.bringSubviewToFront(subview)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Scales a view to fill its parent view with constraints.
    /// - Parameters:
    ///   - view: The view to scale.
    ///   - parent: The parent view to scale into.
    private func scaleToFillView(_ view: UIView, in parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            view.widthAnchor.constraint(equalTo: parent.widthAnchor),
            view.heightAnchor.constraint(equalTo: parent.heightAnchor)
        ])
    }
    
    /// Fades in a view with animation.
    /// - Parameter view: The view to fade in.
    private func fadeInView(_ view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            view.alpha = 1
        }
    }
    
    /// Updates the height constraint of the quote label based on its content.
    public func updateHeightConstraint() {
        let newHeight = calculateHeightForText(quoteLabel.text ?? "", width: quoteLabel.frame.width)
        labelHeightConstraint.constant = newHeight
    }
    
    /// Calculates the height needed for a given text and width.
    /// - Parameters:
    ///   - text: The text to calculate the height for.
    ///   - width: The width constraint for the text.
    /// - Returns: The calculated height.
    private func calculateHeightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = quoteLabel.font ?? UIFont.systemFont(ofSize: 17)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    // MARK: - Actions
    
    /// Action for close button tap.
    /// - Parameter sender: The button that triggered the action.
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Static Methods
    
    /// Presents the DynamicLabelViewController from another view controller.
    /// - Parameters:
    ///   - viewController: The view controller to present from.
    ///   - quoteText: The text for the quote label.
    ///   - topImage: The top banner image.
    ///   - midImage: The middle banner image.
    ///   - bottomImage: The bottom banner image.
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
}

/// Custom UILabel that adjusts its height based on its content.
public class AdjustableHeightLabel: UILabel {
    
    // MARK: - Properties
    
    public var heightConstraint: NSLayoutConstraint?
    
    public override var text: String? {
        didSet {
            adjustHeight()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Adjusts the height of the label based on its content.
    private func adjustHeight() {
        guard let text = text else { return }
        let newHeight = calculateHeightForText(text, width: frame.width)
        heightConstraint?.constant = newHeight
        layoutIfNeeded()
    }
    
    /// Calculates the height needed for a given text and width.
    /// - Parameters:
    ///   - text: The text to calculate the height for.
    ///   - width: The width constraint for the text.
    /// - Returns: The calculated height.
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
