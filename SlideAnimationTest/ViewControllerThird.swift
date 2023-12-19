import UIKit

//third vc, that is being presented
class ViewControllerThird: UIViewController {
    let transitionDelegate = SlideInTransitionDelegate()  // Retain the delegate as a property

    init()
    {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        let interactiveTransition = InteractiveTransition(viewController: self)
        transitionDelegate.interactionController = interactiveTransition
        transitioningDelegate = transitionDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        
        //can trigger dismiss with a button press
        backButton.addTarget(self, action: #selector(dismissself), for: .touchUpInside)
    }

    let backButton :  UIButton = {
        let button = UIButton()
        button.setTitle("dismiss", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func dismissself()
    {
        print("dismiss third view controller")
        dismiss(animated: true)    
    }
}

extension ViewControllerThird: TransitionAnimationProvider
{
    
    //slide from center to right
    func dismissAnimation(completion: ((Bool) -> Void)?) {
        self.view.transform = .identity
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            self.view.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)

        }, completion: completion)
    }
    //slide from right to center
    func presentAniamtion(completion: ((Bool) -> Void)?) {
        
        view.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            self.view.transform = .identity
        }, completion: completion)
    }
    //slide from center to left
    func backgroundAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            self.view.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        })
    }
    //slide from left to center
    func foregroundAnimation() {
        view.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            self.view.transform = .identity

        })
    }
}
