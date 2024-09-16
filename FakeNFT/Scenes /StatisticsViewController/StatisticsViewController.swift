import UIKit
import ProgressHUD

protocol StatisticsView: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateTableView()
    func showErrorAlert()
}

import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController, StatisticsView {
    
    private var statisticsServiceObserver: NSObjectProtocol?
    private let servicesAssembly: ServicesAssembly
    private lazy var presenter: StatisticsPresenterProtocol = {
        let presenter = StatisticsPresenter(servicesAssembly: servicesAssembly)
        presenter.attachView(self)
        return presenter
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 88
        tableView.separatorStyle = .none
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(sortButton)
        
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Не удалось получить данные",
            message: nil,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        let action = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter.viewDidLoad()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func showLoadingIndicator() {
        ProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        ProgressHUD.dismiss()
    }
    
    @objc
    private func sortButtonDidTap() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.presenter.sortUsers(by: .name)
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter.sortUsers(by: .rating)
        }
        
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alertController.addAction(sortByNameAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
}

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.retrieveUsers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatisticsTableViewCell
        let user = presenter.retrieveUsers()[indexPath.row]
        cell.configureCell(at: indexPath.row + 1, with: user)
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
}
