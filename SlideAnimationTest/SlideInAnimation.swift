import UIKit
import os
class SlideInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = true
    let springAnimationDuration = 0.5
    let springAnimationDamping = 0.9
    let springAnimationInitialVelocity = 1.0
    let logger = Logger(subsystem: "TEST APP", category: "SlideTransitionAnimator")
    
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
        print("present animation")
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        
        if let customFromVC = fromVC as? TransitionAnimationProvider
        {
            customFromVC.backgroundAnimation()
        }
        else
        {
            logger.log("presenting VC has no custom animations")
        }
        
        if let customToVC = toVC as? TransitionAnimationProvider
        {
            customToVC.presentAniamtion(completion: {_ in print("present completed")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)})
        }
        else
        {
            logger.log("view being presented has no custom animations")
            toView.frame = finalFrame.offsetBy(dx: containerView.bounds.width, dy: 0)
            UIView.animate(withDuration: springAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: springAnimationDamping,
                           initialSpringVelocity: springAnimationInitialVelocity,
                           options: [.allowUserInteraction],
                           animations: {
                
                toView.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
            }, completion: { finished in
            })
        }
    }
    
    private func dismissAnimation(fromVC: UIViewController, toVC: UIViewController, withContext transitionContext: UIViewControllerContextTransitioning)
    {
        print("dismiss animation")
        let fromView = transitionContext.view(forKey: .from)!
    
        if let customFromVC = fromVC as? TransitionAnimationProvider
        {
            customFromVC.dismissAnimation(completion:{ finished in
                                          let wasCancelled = transitionContext.transitionWasCancelled
                                                if wasCancelled {
                                                    print("was cancelled")
                                                } else {
                                                    fromView.removeFromSuperview()
                                                }
                                          print("dismiss completed")
                                          transitionContext.completeTransition(!wasCancelled)})
        }
        else
        {
            logger.log("dismissed  VC has no custom animations")
            UIView.animate(withDuration: springAnimationDuration,
                           delay: 0,
                           options: [.allowUserInteraction],
                           animations: {
                fromView.transform = .identity
            }, completion: { finished in
                let wasCancelled = transitionContext.transitionWasCancelled
                      if wasCancelled {
                          print("was cancelled")
                      } else {
                          fromView.removeFromSuperview()
                      }
                print("dismiss completed")
                    transitionContext.completeTransition(!wasCancelled)
            })
        }
        
        if let customToVC = toVC as? TransitionAnimationProvider
        {
            customToVC.foregroundAnimation()
        }
        else
        {
            logger.log("view being put into forground has no custom animations")
        }
    }
}

class SlideInTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let animator = SlideInTransitionAnimator()
    var interactionController: InteractiveTransition?
    
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
        let position = gestureRecognizer.location(in: gestureRecognizer.view?.superview)
        var progress = position.x / UIScreen.main.bounds.width

        // Adjust the divisor as needed for sensitivity
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


