
import UIKit

//MARK: - CatalogCell
final class NftCatalogCell: UITableViewCell, ReuseIdentifying {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let nftCollectionImageViewCornerRadius: CGFloat = 12
        static let nftCountLabelFontSize: CGFloat = 17
    }
    
    //MARK: - Static properties
    static let nftCatalogCellIdentifier = "nftCatalogCell"
    
    //MARK: - UIModels
    private lazy var nftCollectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCollectionMock)
        imageView.layer.cornerRadius = UIConstants.nftCollectionImageViewCornerRadius
        return imageView
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach (1)"
        label.font = .boldSystemFont(ofSize: UIConstants.nftCountLabelFontSize)
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}

//MARK: - AutoLayout
extension NftCatalogCell {
    private func setupViews() {
        [nftCollectionImageView,
         nftCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftCollectionImageView.heightAnchor.constraint(equalToConstant: 140),
            nftCollectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCollectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nftCountLabel.topAnchor.constraint(equalTo: nftCollectionImageView.bottomAnchor, constant: 4),
            nftCountLabel.leadingAnchor.constraint(equalTo: nftCollectionImageView.leadingAnchor),
        ])
    }
}
