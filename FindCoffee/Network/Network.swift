//
//  AuthService.swift
//  FindCoffee
//
//  Created by Anton on 06.02.24.
//
import Foundation

enum AuthError: Error {
    case invalidResponse
    case networkError
}

struct Endpoints {
    static let login = "http://147.78.66.203:3210/auth/login"
    static let register = "http://147.78.66.203:3210/auth/register"
    static let locations = "http://147.78.66.203:3210/locations"
}

class Network {
    static let shared = Network()
    
    private func sendRequest(urlString: String, parameters: [String: Any], completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(AuthError.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(AuthError.networkError))
                return
            }
            
            if let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                completion(.success(authResponse))
            } else {
                completion(.failure(AuthError.invalidResponse))
            }
        }.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let parameters: [String: Any] = ["login": email, "password": password]
        sendRequest(urlString: Endpoints.login, parameters: parameters, completion: completion)
    }
    
    func register(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let parameters: [String: Any] = ["login": email, "password": password]
        sendRequest(urlString: Endpoints.register, parameters: parameters, completion: completion)
    }
    
    func fetchLocations(token: String, completion: @escaping (Result<[Location], Error>) -> Void) {
            let urlString = Endpoints.locations
            guard let url = URL(string: urlString) else {
                completion(.failure(AuthError.invalidResponse))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(AuthError.networkError))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let locations = try decoder.decode([Location].self, from: data)
                        completion(.success(locations))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(AuthError.invalidResponse))
                }
            }.resume()
        }
    
    func fetchMenu(locationID: Int, token: String, completion: @escaping (Result<[Menu], Error>) -> Void) {
        let urlString = "http://147.78.66.203:3210/location/\(locationID)/menu"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.networkError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let menu = try decoder.decode([Menu].self, from: data)
                completion(.success(menu))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}




