import UIKit
class SlideInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = true
    let springAnimationDuration = 0.5
    let springAnimationDamping = 0.9
    let springAnimationInitialVelocity = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return springAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        if isPresenting
        {
            presentAnimation(fromVC: fromVC, toVC: toVC, withContext: transitionContext)
        }
        else
        {
            dismissAnimation(fromVC: fromVC, toVC: toVC, withContext: transitionContext)
        }
    }
    
    private func presentAnimation(fromVC: UIViewController, toVC: UIViewController, withContext transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        containerView.addSubview(toVC.view)
        toVC.view.frame = finalFrame.offsetBy(dx: containerView.bounds.width, dy: 0)
        UIView.animate(withDuration: springAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: springAnimationDamping,
                       initialSpringVelocity: springAnimationInitialVelocity,
                       options: [.allowUserInteraction],
                       animations: {
            
            toVC.view.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
            fromVC.view.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            fromVC.view.transform = .identity // Reset the view's transform
        })
        
    }
    
    private func dismissAnimation(fromVC: UIViewController, toVC: UIViewController, withContext transitionContext: UIViewControllerContextTransitioning)
    {
        print("dismiss animation")
        let containerView = transitionContext.containerView
        toVC.view.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)

        UIView.animate(withDuration: springAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: springAnimationDamping,
                       initialSpringVelocity: springAnimationInitialVelocity,
                       options: [.allowUserInteraction],
                       animations: {
            toVC.view.transform = .identity
            fromVC.view.transform = .identity
        }, completion: { finished in
            let wasCancelled = transitionContext.transitionWasCancelled
                  if wasCancelled {
                      print("was cancelled")
                      // Reset any changes made during the transition
                      toVC.view.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
                      toVC.view.transform = .identity
                  } else {
                      // Remove the fromVC's view from the container view if the transition completed
                      fromVC.view.removeFromSuperview()
                  }
                  transitionContext.completeTransition(!wasCancelled)
        })
    }
}

class SlideInTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let animator = SlideInTransitionAnimator()
    weak var interactionController: InteractiveTransition?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController?.interactionInProgress == true ? interactionController : nil
    }
}

// this sets up that swiping from the left edge will trigger the dismissal
class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc
    func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        var progress = translation.x / 400 // Adjust the divisor as needed for sensitivity
        progress = min(max(progress, 0.0), 1.0)
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController?.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
        default:
            break
        }
    }
}


