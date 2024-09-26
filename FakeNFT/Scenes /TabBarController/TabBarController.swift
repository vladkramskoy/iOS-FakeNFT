import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString(Localizable.tabBarСart, comment: ""),
        image: UIImage(named: "cart"),
        tag: 2
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let servicesAssembly = self.servicesAssembly else { return }
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let profilePresenter = ProfilePresenter(servicesAssembler: servicesAssembly)
        let profileController = ProfileViewController(presenter: profilePresenter)
        profileController.tabBarItem = profileTabBarItem
        
        let cartController = CartViewController()
        let cartPresenter = CartPresenter(view: cartController, servicesAssembly: servicesAssembly)
        cartController.presenter = cartPresenter
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartController.tabBarItem = cartTabBarItem
        
        viewControllers = [profileController, catalogController, cartNavigationController]
        tabBar.unselectedItemTintColor = UIColor(named: "darkObjectColor")
        
        view.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .closeButton
    }
}
