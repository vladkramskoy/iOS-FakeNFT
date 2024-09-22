import Foundation

final class StatisticsNetworkService {
    
    static let shared = StatisticsNetworkService()
    
    private init() {}
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        assert(Thread.isMainThread, "Must be called on the main thread")
        
        guard let request = usersRequest() else {
            assertionFailure("Invalid users request")
            return
        }
        
        URLSession.shared.objectTask(for: request) { (response: Result<[User], Error>) in
            switch response {
            case .success(let body):
                completion(.success(body))
            case .failure(let error):
                completion(.failure(error))
                print("[StatisticsService]: \(error.localizedDescription) Request: \(request)")
            }
        }
    }
    
    private func usersRequest() -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/v1/users",
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        )
        
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        request?.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        print("Decoding error: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                        fulfillCompletion(.failure(NetworkError.serviceError))
                    }
                } else {
                    print("HTTP error: \(statusCode)")
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("URLSession error: \(error)")
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Unknown error")
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
    }
}

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL?
    ) -> URLRequest? {
        guard let requestURL = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod
        
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case serviceError
}
