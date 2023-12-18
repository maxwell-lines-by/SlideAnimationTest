import UIKit

//second vc, that is being presented
class ViewControllerSecond: UIViewController {
    var interactiveTransition: InteractiveTransition?
    let transitionDelegate = SlideInTransitionDelegate()  // Retain the delegate as a property

    init()
    {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        interactiveTransition = InteractiveTransition(viewController: self)
        transitionDelegate.interactionController = interactiveTransition
        self.transitioningDelegate = transitionDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        //can trigger dismiss with a button press
        button.addTarget(self, action: #selector(dismissself), for: .touchUpInside)
    }

    let button :  UIButton = {
        let button = UIButton()
        button.setTitle("dismiss", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func dismissself()
    {
        dismiss(animated: true, completion: {})
    }
}
