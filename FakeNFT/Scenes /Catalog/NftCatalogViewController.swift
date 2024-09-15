
import UIKit

protocol NftCatalogView: AnyObject, ErrorView, LoadingView {
    func displayCells(_ cellModels: [NftCatalogCellModel])
}

//MARK: - CatalogViewController
final class NftCatalogViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: NftCatalogPresenter
    private var cellModels: [NftCatalogCellModel] = []
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    //MARK: - UIModels
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .sortButton), for: .normal)
        return button
    }()
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NftCatalogCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //MARK: - Init
    init(presenter: NftCatalogPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifyCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

//MARK: - UITableViewDataSource
extension NftCatalogViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NftCatalogCell = tableView.dequeueReusableCell()
        let cellModel = cellModels[indexPath.section]
        cell.configure(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

//MARK: - UITableViewDelegate
extension NftCatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nftCollectionViewController = NftCollectionViewController()
        present(nftCollectionViewController, animated: true)
    }
}

extension NftCatalogViewController: NftCatalogView {
    func displayCells(_ cellModels: [NftCatalogCellModel]) {
        self.cellModels = cellModels
        nftTableView.reloadData()
    }
}

//MARK: - AutoLayout
extension NftCatalogViewController {
    private func setupViews() {
        [sortButton,
         nftTableView,
         activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view?.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            nftTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        activityIndicator.constraintCenters(to: view)
    }
}
