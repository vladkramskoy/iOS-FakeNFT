
import Foundation

//MARK: - Protocol
protocol NftCatalogPresenter {
    func viewDidLoad()
    func sortCollections(by option: SortOption)
}

//MARK: - State
enum NftCatalogState {
    case initial, loading, failed(Error), data([NftCollection])
}

//MARK: - SortOption
enum SortOption {
    case byName
    case byNftCount
}

//MARK: - NftCatalogPresenterImpl
final class NftCatalogPresenterImpl: NftCatalogPresenter {
    
    //MARK: - Private Properties
    private let service: NftService
    private var state = NftCatalogState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private var nftCollections: [NftCollection] = []
    
    //MARK: - Public Properties
    weak var view: NftCatalogView?
    
    //MARK: - Init
    init(service: NftService) {
        self.service = service
    }
    
    //MARK: - Public Functions
    func viewDidLoad() {
        state = .loading
    }
    
    func sortCollections(by option: SortOption) {
            switch option {
            case .byName:
                nftCollections.sort { $0.name < $1.name }
            case .byNftCount:
                nftCollections.sort { $0.nfts.count < $1.nfts.count }
            }
            updateViewWithSortedCollections()
        }
    
    //MARK: - Private Functions
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNftCollections()
        case .data(let nftCollections):
            view?.hideLoading()
            self.nftCollections = nftCollections
            updateViewWithSortedCollections()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func loadNftCollections() {
        service.loadNftCollections { [weak self] result in
            switch result {
            case .success(let nftCollections):
                self?.state = .data(nftCollections)
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
    
    private func updateViewWithSortedCollections() {
            let cellModels = nftCollections.map { NftCatalogCellModel(name: $0.name, cover: $0.cover, id: $0.id, nfts: $0.nfts)}
            view?.displayCells(cellModels)
        }
}
