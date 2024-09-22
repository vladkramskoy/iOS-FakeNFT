//
//  MyFavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by gimon on 22.09.2024.
//

import Foundation

protocol MyFavoritesNFTPresenterProtocol {
    func loadAllMyFavoritesNFT()
    func countMyFavoritesNFT() -> Int
    func getFavoritesNFT(indexArray: Int) -> Nft
}

final class MyFavoritesNFTPresenter: MyFavoritesNFTPresenterProtocol {
    weak var myFavoritesNFTViewController: MyFavoritesNFTViewControllerProtocol?
    
    private var nftService: NftService
    private var myFavoritesNFTIDArray: [String]
    private var myFavoritesNFTArray: [Nft] = []
    private var countLoadedNFT = 0
    
    init(nftService: NftService, myFavoritesNFTIDArray: [String]) {
        self.nftService = nftService
        self.myFavoritesNFTIDArray = myFavoritesNFTIDArray
    }
    
    func loadAllMyFavoritesNFT() {
        if myFavoritesNFTIDArray.isEmpty {
            myFavoritesNFTViewController?.showMyNFT(isEmpty: myFavoritesNFTArray.isEmpty)
            return
        }
        countLoadedNFT = 0
        for id in myFavoritesNFTIDArray {
            loadNft(id: id)
        }
    }
    
    func countMyFavoritesNFT() -> Int {
        myFavoritesNFTArray.count
    }
    
    func getFavoritesNFT(indexArray: Int) -> Nft {
        myFavoritesNFTArray[indexArray]
    }
    
    private func loadNft(id: String) {
        nftService.loadNft(id: id) {[weak self] result in
            guard let self else {
                assertionFailure("nftService.loadNft self nil")
                return
            }
            switch result {
            case .success(let nft):
                self.myFavoritesNFTArray.append(nft)
            case.failure(let error):
                assertionFailure("\(error)")
            }
            self.countLoadedNFT += 1
            if self.countLoadedNFT == self.myFavoritesNFTIDArray.count {
                self.myFavoritesNFTViewController?.showMyNFT(isEmpty: self.myFavoritesNFTArray.isEmpty)
                let countNftError = self.myFavoritesNFTIDArray.count - self.myFavoritesNFTArray.count
                if countNftError > 0 {
                    self.myFavoritesNFTViewController?.showErrorAlert(countNftError: countNftError)
                }
            }
        }
    }    
}
