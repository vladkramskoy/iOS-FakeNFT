import UIKit

public final class NftCollectionAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build(with id: String) -> UIViewController {
        let presenter = NftCollectionPresenterImpl(service: servicesAssembler.nftService, nftCollectionId: id)
        let viewController = NftCollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
