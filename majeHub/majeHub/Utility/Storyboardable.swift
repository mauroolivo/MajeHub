import UIKit

protocol Storyboardable {
    
    static var storyboardType: StoryboardType { get }
    static func instantiate() -> Self
}

// MARK: - Storyboardable

/// The default implementation for the UIKit framework.
extension Storyboardable where Self: UIViewController {
    
    /// Instantiates a new UIViewController.
    static func instantiate() -> Self {
        
        guard let stringID = String(describing: type(of: self))
                .components(separatedBy: ".")
                .first else {
            
            fatalError("You missed the naming convention for the ViewController")
        }
        return instantiate(with: stringID)
    }
    
    /// Instantiates a new UIViewController with a given identifier.
    static func instantiate(with identifier: String) -> Self {
        
        let storyboard = UIStoryboard(name: storyboardType.rawValue,
                                      bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(
                withIdentifier: identifier) as? Self else {
            
            fatalError("You missed the naming convention for the ViewController")
        }
        
        return viewController
    }
}
