//
//  RequestService.swift
//  NYTestApp
//
//  Created by Hariharan jaganathan on 12/08/19.
//  Copyright © 2019 Hariharan jaganathan. All rights reserved.
//

import Foundation
import Reachability

final class RequestService {
    
    func loadData(urlString: String, session: URLSession = URLSession(configuration: .default), completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        
        var request = RequestFactory.request(method: .GET, url: url)
        
        if let reachability = Reachability(), reachability.connection == .none {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(string: kNetworkErrorMessgae + error.localizedDescription)))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}
