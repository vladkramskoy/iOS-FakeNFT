final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let nftCollectionsStorage: NftCollectionsStorage
    private let profileStorage: ProfileStorage
    private let orderStorage: OrderStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        nftCollectionsStorage: NftCollectionsStorage,
        profileStorage: ProfileStorage,
        orderStorage: OrderStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftCollectionsStorage = nftCollectionsStorage
        self.profileStorage = profileStorage
        self.orderStorage = orderStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage, 
            collectionsStorage: nftCollectionsStorage
        )
    }
    
    var editProfileServices: EditProfileServices {
        EditProfileServicesImpl(
            networkClient: networkClient,
            profileStorage: profileStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            profileStorage: profileStorage
        )
    }
    
    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient,
            orderStorage: orderStorage
        )
    }
    
    var editOrderServices: EditOrderService {
        EditOrderServiceImpl(
            networkClient: networkClient,
            orderStorage: orderStorage
        )
    }
}
