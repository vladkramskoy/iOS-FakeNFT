//
//  OrderService.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 10.09.2024.
//

import UIKit

final class OrderService {
    private let baseUrl = RequestConstants.baseURL
    private let token = RequestConstants.token
    
    func fetchOrderNfts(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/api/v1/orders/1") else { return }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let orderResponce = try JSONDecoder().decode(Order.self, from: data)
                    completion(.success(orderResponce.nfts))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchNftDetails(for id: String, completion: @escaping (Result<NftDetail, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/api/v1/nft/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let nftDetailResponse = try JSONDecoder().decode(NftDetail.self, from: data)
                    completion(.success(nftDetailResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func convertToCartNft(from nftDetail: NftDetail, completion: @escaping (CartNft?) -> Void) {
        guard let imageUrlString = nftDetail.images.first,
              let imageUrl = URL(string: imageUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            let cartNft = CartNft(name: nftDetail.name, image: image, rating: nftDetail.rating, price: nftDetail.price, id: nftDetail.id)
            completion(cartNft)
            
        }.resume()
    }
}
