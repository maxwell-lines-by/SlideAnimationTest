
import UIKit
class AnimationHelper
{
    static func dismissController(_ viewController: UIViewController)
    {
        let interactiveTransition = InteractiveTransition(viewController: viewController)
        let transitionDelegate = SlideInTransitionDelegate()  // Retain the delegate as a property
        viewController.transitioningDelegate = transitionDelegate
        viewController.dismiss(animated: true, completion: {})
    }
    
    static func presentController(viewController toVC: UIViewController, from fromVC: UIViewController)
    {
        toVC.modalPresentationStyle = .custom
        let interactiveTransition = InteractiveTransition(viewController: toVC)
        let transitionDelegate = SlideInTransitionDelegate()  // Retain the delegate as a property
        transitionDelegate.interactionController = interactiveTransition
        toVC.transitioningDelegate = transitionDelegate
        fromVC.present(toVC, animated: true, completion: nil)
    }

}
