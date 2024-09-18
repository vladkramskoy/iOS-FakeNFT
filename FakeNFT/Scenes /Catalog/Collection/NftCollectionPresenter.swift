
import Foundation

//MARK: - Protocol
protocol NftCollectionPresenter {
    func viewDidLoad()
}

//MARK: - State
enum NftCollectionState {
    case initial, loading, failed(Error), collectionData(NftCollection), nftData(Nft)
}

//MARK: - NftCatalogPresenterImpl
final class NftCollectionPresenterImpl: NftCollectionPresenter {
    
    //MARK: - Private Properties
    private let service: NftService
    private var state = NftCollectionState.initial {
        didSet {
            stateDidChanged()
        }
    }
    private let nftCollectionId: String
    private var nftIds: [String] = []
    private var nftCellModels: [NftCellModel] = []
    
    //MARK: - Public Properties
    weak var view: NftCollectionView?
    
    //MARK: - Init
    init(service: NftService, nftCollectionId: String) {
        self.service = service
        self.nftCollectionId = nftCollectionId
    }
    
    //MARK: - Public Functions
    func viewDidLoad() {
        state = .loading
    }
    
    //MARK: - Private Functions
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNftCollections(with: nftCollectionId)
        case .collectionData(let nftCollection):
            view?.hideLoading()
            let collectionModel = NftCollectionModel(
                name: nftCollection.name,
                cover: nftCollection.cover,
                id: nftCollection.id,
                description: nftCollection.description,
                author: nftCollection.author,
                nfts: nftCollection.nfts)
            view?.display(collectionModel)
        case.nftData(let nft):
            let nftCellModel = NftCellModel(
                name: nft.name,
                images: nft.images,
                rating: nft.rating,
                price: nft.price,
                id: nft.id)
            view?.displayCells([nftCellModel])
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func loadNftCollections(with id: String) {
        service.loadNftCollection(id: id) { [weak self] result in
            switch result {
            case .success(let nftCollection):
                nftCollection.nfts.forEach { nftId in
                    self?.loadNft(with: nftId)
                    self?.state = .collectionData(nftCollection)
                }
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func loadNft(with id: String) {
        service.loadNft(id: id) { [weak self] result in
            switch result {
            case .success(let nft):
                let nftCellModel = NftCellModel(
                    name: nft.name,
                    images: nft.images,
                    rating: nft.rating,
                    price: nft.price,
                    id: nft.id
                )
                
                self?.nftCellModels.append(nftCellModel)
                self?.state = .nftData(nft)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
