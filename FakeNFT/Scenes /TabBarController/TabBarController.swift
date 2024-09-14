import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .catalogTabBarItem),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let assembly = NftCatalogAssembly(servicesAssembler: servicesAssembly)
        let nftCatalogViewController = assembly.build()
        
        nftCatalogViewController.tabBarItem = catalogTabBarItem
        
        viewControllers = [nftCatalogViewController]
        
        view.backgroundColor = .systemBackground
    }
}
