final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let nftCollectionsStorage: NftCollectionsStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        nftCollectionsStorage: NftCollectionsStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftCollectionsStorage = nftCollectionsStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage, 
            collectionsStorage: nftCollectionsStorage
        )
    }
}
