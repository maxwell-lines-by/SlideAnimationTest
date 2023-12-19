import UIKit

//second vc, that is being presented
class ViewControllerSecond: UIViewController {

    init()
    {
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        view.addSubview(forwardButton)
        NSLayoutConstraint.activate([
            forwardButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 100),
            forwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        //can trigger dismiss with a button press
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(goForward), for: .touchUpInside)

    }

    let backButton :  UIButton = {
        let button = UIButton()
        button.setTitle("dismiss", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forwardButton :  UIButton = {
        let button = UIButton()
        button.setTitle("go to red", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func dismissSelf()
    {
        print("dismiss second view controller")
        AnimationHelper.dismissController(self)
    }
    
    @objc
    private func goForward()
    {
        print("present third view controller")
        let viewControllerToPresent = ViewControllerThird()
        AnimationHelper.presentController(viewController: viewControllerToPresent, from: self)
    }
}
