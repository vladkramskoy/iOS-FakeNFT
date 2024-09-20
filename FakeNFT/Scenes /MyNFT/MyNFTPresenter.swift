//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by gimon on 19.09.2024.
//

import Foundation

protocol MyNFTPresenterProtocol {
    var myNFTViewController: MyNFTViewControllerProtocol? { set get }
    func loadAllMyNFT()
    func countMyNFT() -> Int
    func getNFT(indexArray: Int) -> Nft
    func sortMyNft(variant: SortVariant)
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    weak var myNFTViewController: MyNFTViewControllerProtocol?
    
    private var nftService: NftService
    private var myNFTIDArray: [String]
    private var myNFTArray: [Nft] = []
    private var countLoadedNFT = 0
    
    init(nftService: NftService, myNFTIDArray: [String]) {
        self.nftService = nftService
        self.myNFTIDArray = myNFTIDArray
    }
    
    func sortMyNft(variant: SortVariant) {
        switch variant {
        case .price:
            myNFTArray.sort{ $0.price > $1.price }
        case .rating:
            myNFTArray.sort{ $0.rating > $1.rating }
        case .name:
            myNFTArray.sort{ $0.name > $1.name }
        }
        myNFTViewController?.reloadTableMyNFT()
    }
    
    func loadAllMyNFT() {
        if myNFTIDArray.isEmpty {
            myNFTViewController?.showMyNFT(isEmpty: myNFTArray.isEmpty)
            return
        }
        countLoadedNFT = 0
        for id in myNFTIDArray {
            loadNft(id: id)
        }
    }
    
    func countMyNFT() -> Int {
        myNFTArray.count
    }
    
    func getNFT(indexArray: Int) -> Nft {
        myNFTArray[indexArray]
    }
    
    private func loadNft(id: String) {
        nftService.loadNft(id: id) {[weak self] result in
            guard let self else {
                assertionFailure("nftService.loadNft self nil")
                return
            }
            switch result {
            case .success(let nft):
                self.myNFTArray.append(nft)
            case.failure(let error):
                assertionFailure("\(error)")
            }
            self.countLoadedNFT += 1
            if self.countLoadedNFT == self.myNFTIDArray.count {
                self.myNFTViewController?.showMyNFT(isEmpty: self.myNFTArray.isEmpty)
            }
        }
    }
}

enum SortVariant {
    case price
    case rating
    case name
}
