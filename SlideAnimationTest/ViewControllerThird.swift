import UIKit

//second vc, that is being presented
class ViewControllerThird: UIViewController {

    init()
    {
        super.init(nibName: nil, bundle: nil)
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
        modalPresentationStyle = .custom
        var interactiveTransition = InteractiveTransition(viewController: self)
        let transitionDelegate = SlideInTransitionDelegate()  // Retain the delegate as a property
        transitionDelegate.interactionController = interactiveTransition
        self.transitioningDelegate = transitionDelegate
        dismiss(animated: true, completion: {})
    }
}
