//
//  ServerNetwork.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

// MARK: - ServerNetwork
class ServerNetwork {
    static let shared = ServerNetwork()
    
    private init() { }
    
    func request<T: Decodable>(_ endpoint: ServerEndpoint) async throws -> T {
        do {
            let response: ServerResponse<T> = try await NetworkService.shared.request(endpoint)
            
            if response.code == "99" {
                throw NetworkError.server
            } else if let data = response.data {
                return data
            } else {
                throw NetworkError.parse
            }
        } catch {
           throw mapError(error)
        }
    }
    
    func request(_ endpoint: ServerEndpoint) async throws -> Void {
        do {
            let response: ServerResponse<EmptyData> = try await NetworkService.shared.request(endpoint)
            
            if response.code == "99" {
                throw NetworkError.server
            }
        } catch {
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.unknown
        }
    }
}

// MARK: - NetworkService
class NetworkService {
    static let shared = NetworkService()
    
    private init () { }

    private func configureURL(_ endpoint: NetworkEndpoint) -> URL? {
        guard let baseURL = endpoint.serverURL else { return nil }
        let url = baseURL.appendingPathComponent(endpoint.path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil}
        components.queryItems = endpoint.parameters
        
        return components.url
    }
    
    private func configureRequest(url: URL, _ endpoint: NetworkEndpoint) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let header = endpoint.header {
            for (key,value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        guard let url = configureURL(endpoint) else {
            throw NetworkError.request
        }
        
        let request = configureRequest(url: url, endpoint)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodeData = try JSONDecoder().decode(T.self, from: data)
            return decodeData
        } catch {
            throw NetworkError.parse
        }
    }
}
