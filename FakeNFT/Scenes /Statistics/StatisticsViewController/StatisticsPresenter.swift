import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func fetchUsers()
    func retrieveUsers() -> [User]
    func sortUsers(by option: StatisticsPresenter.SortOption)
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    private enum StatisticsState {
        case notStarted
        case loadingData
        case errorOccurred
        case dataLoaded
    }
    
    enum SortOption {
        case name
        case rating
    }
    
    private let statisticsService = StatisticsNetworkService.shared
    private var users: [User] = []
    private var state = StatisticsState.notStarted {
        didSet {
            handleStateChange()
        }
    }
    
    weak var view: StatisticsView?
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func attachView(_ view: StatisticsView) {
        self.view = view
    }
    
    func viewDidLoad() {
        state = .loadingData
    }
    
    func fetchUsers() {
        statisticsService.fetchUsers { [weak self] (response: Result<[User], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                self.users = body
                self.state = .dataLoaded
            case .failure:
                self.state = .errorOccurred
            }
        }
    }
    
    func retrieveUsers() -> [User] {
        users
    }
    
    func sortUsers(by option: SortOption) {
        switch option {
        case .name:
            users.sort { $0.name < $1.name }
        case .rating:
            users.sort { $0.nfts.count > $1.nfts.count }
        }
        state = .dataLoaded
    }
    
    private func handleStateChange() {
        view?.hideLoadingIndicator()
        
        switch state {
        case .notStarted:
            assertionFailure("Can't move to initial state")
            
        case .loadingData:
            view?.showLoadingIndicator()
            fetchUsers()
            
        case .dataLoaded:
            view?.updateTableView()
            
        case .errorOccurred:
            view?.showErrorAlert()
        }
    }
}
