import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticsVeiwController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        statisticsVeiwController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, statisticsVeiwController]

        view.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .closeButton
    }
}
