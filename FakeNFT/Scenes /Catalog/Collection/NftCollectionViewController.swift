
import UIKit

protocol NftCollectionView: AnyObject, ErrorView, LoadingView {
    func displayCells(_ cellModel: [NftCellModel])
    func display(_ model: NftCollectionModel)
}

//MARK: - NftCollectionViewController
final class NftCollectionViewController: UIViewController {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let coverImageViewCornerRadius: CGFloat = 12
    }
    
    //MARK: - Private Properties
    private let params: GeometricParams = {
        let params = GeometricParams(cellCount: 3,
                                     topInset: 0,
                                     leftInset: 0,
                                     bottomInset: 8,
                                     rightInset: 0,
                                     cellSpacing: 10)
        return params
    }()
    private let presenter: NftCollectionPresenter
    private var collectionModel: NftCollectionModel?
    private var nftCellModel: [NftCellModel] = []
    
    //MARK: - Public Properties
    lazy var activityIndicator = UIActivityIndicatorView()
    
    //MARK: - UIModels
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = UIConstants.coverImageViewCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        return label
    }()
    
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Автор коллекции:"
        return label
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .caption1
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = .bitWidth
        return label
    }()
    
    private lazy var nftsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NftCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Init
    init(presenter: NftCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @objc private func didTapAuthorButton() {
        //TODO: Переход на страницу автора
    }
}

//MARK: - UICollectionViewDataSource
extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftCellModel.isEmpty ? 0 : nftCellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cellModel = nftCellModel[indexPath.item]
        cell.configure(cellModel: cellModel)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 192)
    }
}

//MARK: - NftCatalogView
extension NftCollectionViewController: NftCollectionView {
    func display(_ model: NftCollectionModel) {
        self.collectionModel = model
        collectionNameLabel.text = model.name
        authorButton.setTitle(model.author, for: .normal)
        descriptionLabel.text = model.description
        coverImageView.kf.setImage(with: model.cover)
        nftsCollectionView.reloadData()
    }
    
    func displayCells(_ cellModel: [NftCellModel]) {
        guard !cellModel.isEmpty else { return }
        
        nftCellModel.append(contentsOf: cellModel)
        nftsCollectionView.reloadData()
    }
}

//MARK: - AutoLayout
extension NftCollectionViewController {
    private func setupViews() {
        [placeholderImageView,
         coverImageView,
         collectionNameLabel,
         authorLabel,
         authorButton,
         descriptionLabel,
         nftsCollectionView,
         activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view?.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderImageView.heightAnchor.constraint(equalToConstant: 310),
            placeholderImageView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            coverImageView.heightAnchor.constraint(equalToConstant: 310),
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            authorButton.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 8),
            authorButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            authorButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            nftsCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            nftsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
        activityIndicator.constraintCenters(to: nftsCollectionView)
    }
}
