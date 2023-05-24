//
//  Remote.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 23/05/23.
//

import Foundation

class Remote {
    
    func getSuggestions(query: String, completion: @escaping ([Item]?) -> ()) {
        let baseUrl = "https://autocomplete.search.hereapi.com/v1/autocomplete"
        let queryItems = [
            URLQueryItem(name: "apiKey", value: "eXC9zm4wRBKtFJ7Fnyf-kbYvwsaIKFoZw8hpTHCGFqU"),
            URLQueryItem(name: "q", value: query)
        ]
        
        var urlComponents = URLComponents(string: baseUrl)
            urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            guard let data = data, err == nil else {
                DispatchQueue.main.async {
                    print("Error: \(String(describing: err?.localizedDescription))")
                     completion(nil)
                }
                    return
            }
            
            // Log the response data
            if let responseDataString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(responseDataString)")
            }
            
            let place = try? JSONDecoder().decode(Place.self, from: data)
                    DispatchQueue.main.async {
                        completion(place?.items ?? [])
                    }
        }.resume()
    }
}
