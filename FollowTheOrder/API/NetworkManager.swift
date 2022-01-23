//
//  NetworkManager.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 23.01.2022.
//

import Foundation
import UIKit

class NetworkManager {
    
    static var shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
        
    func getPrediction(completion: @escaping (FortunePrediction)->()) {
            let urlString = "http://yerkee.com/api/fortune"
            guard let url = URL(string: urlString) else {return}
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    guard let model = self.parseJSON(prediction: data) else {return}
                    completion(model)
                }
            }
            task.resume()
        }
        
        func parseJSON(prediction: Data) -> FortunePrediction? {
            let decoder = JSONDecoder()
            do {
                let prediction = try decoder.decode(FortunePrediction.self, from: prediction)
                return prediction
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            return nil
        }
    
    private init() {}
}


extension NetworkManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

