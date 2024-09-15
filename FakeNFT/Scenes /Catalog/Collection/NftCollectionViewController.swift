
import UIKit

//MARK: - NftCollectionViewController
final class NftCollectionViewController: UIViewController {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let coverImageViewCornerRadius: CGFloat = 12
    }
    
    private let params: GeometricParams = {
        let params = GeometricParams(cellCount: 3,
                                     topInset: 0,
                                     leftInset: 0,
                                     bottomInset: 8,
                                     rightInset: 0,
                                     cellSpacing: 10)
        return params
    }()
    
    //MARK: - UIModels
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = UIConstants.coverImageViewCornerRadius
        imageView.image = UIImage(resource: .nftCollectionMock)
        return imageView
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.text = "Title"
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
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Autor", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .caption2
        label.numberOfLines = .bitWidth
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
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
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .white
    }
    
    @objc private func didTapAuthorButton() {
        //TODO: Переход на страницу автора
    }
}

//MARK: - UICollectionViewDataSource
extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCell = collectionView.dequeueReusableCell(indexPath: indexPath)
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

//MARK: - AutoLayout
extension NftCollectionViewController {
    private func setupViews() {
        [coverImageView,
         collectionNameLabel,
         authorLabel,
         authorButton,
         descriptionLabel,
         nftsCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view?.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            coverImageView.heightAnchor.constraint(equalToConstant: 310),
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            authorButton.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 10),
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
//        activityIndicator.constraintCenters(to: view)
    }
}
