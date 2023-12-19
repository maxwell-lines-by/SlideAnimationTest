import UIKit


//initial/ root vc // note that this class does NOT supply a custom animation, so it just... doesnt move! 
class ViewControllerFirst: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        button.addTarget(self, action: #selector(presentController), for: .touchUpInside)
        
    }
    
    let button :  UIButton = {
        let button = UIButton()
        button.setTitle("switch to blue", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func presentController()
    {
        print("present second view controller")
        let viewControllerToPresent = ViewControllerSecond()
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

