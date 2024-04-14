//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Carlos E. Alvarez-Berrios on 4/14/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

final class SearchResultController {
    
    enum HTTPMethod:  String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var searchResults = [SearchResult]()
    
    private let baseURL = URL(string: "https://itunes.apple.com")
    private lazy var searchURL = URL(string: "/search", relativeTo: baseURL)!
    private var task: URLSessionTask?
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        task?.cancel()
        
        var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let searchQueryItem = URLQueryItem(name: "term", value: searchTerm)
        let resultTypeQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)
        urlComponents?.queryItems = [searchQueryItem, resultTypeQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            let error = NSError(domain: "com.emanicomputers.iTunesSearch", code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "Request URL  is nil"])
            completion(error)
            return
        }
        
        let request = URLRequest(url: requestURL) // HttpMethod is get by default
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let self = self else { return }
            
            guard let data = data else {
                let error = NSError(domain: "com.emanicomputers.iTunesSearch", code: NSURLErrorBadServerResponse, userInfo: [NSLocalizedDescriptionKey: "No data returned from dataTask"])
                completion(error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let iTunesSearch = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = iTunesSearch.results
                completion(nil)
            } catch {
                completion(error)
            }
            
        }
        task?.resume()
        
    }
    
}
