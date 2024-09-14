
import Foundation

protocol NftCollectionsStorage: AnyObject {
    func saveNftCollections(_ nftCollections: [NftCollections])
    func getNftCollections(with id: String) -> NftCollections?
    func getAllNftCollections() -> [NftCollections]?
}

final class NftCollectionsStorageImpl: NftCollectionsStorage {
    private var storage: [String: NftCollections] = [:]
    private let syncQueue = DispatchQueue(label: "sync-nftCollections-queue")

    func saveNftCollections(_ nftCollections: [NftCollections]) {
        syncQueue.async { [weak self] in
            for nftCollection in nftCollections {
                self?.storage[nftCollection.id] = nftCollection
            }
        }
    }
    
    func getNftCollections(with id: String) -> NftCollections? {
        syncQueue.sync {
            storage[id]
        }
    }

    func getAllNftCollections() -> [NftCollections]? {
        syncQueue.sync {
            Array(storage.values)
        }
    }
}
