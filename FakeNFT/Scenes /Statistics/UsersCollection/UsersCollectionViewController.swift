import ProgressHUD
import UIKit

final class UsersCollectionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        setupNaviBar()
    }
    
    private func setupNaviBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
}
