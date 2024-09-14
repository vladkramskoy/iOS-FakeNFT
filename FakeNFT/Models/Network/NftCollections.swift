
import Foundation

struct NftCollections: Decodable {
    let name: String
    let cover: URL
    let id: String
    let nfts: [String]
}
