//
//  Repository.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import Foundation
import UIKit


let kTimeoutInterval : Double = 45.0

enum NetworkError: Error {
    case badURL
    case badResponseError
    case parsingError
    case imageConversionError
    case networkError(error: String)
}

protocol RepositoryProtocol {
    func callSingaporeTrafficCameraAPI(completionHandler: @escaping (Result<ResponseDataModel, NetworkError>) ->Void)
    func fetchCameraImage(url: URL, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void)
}


class Repository: NSObject, RepositoryProtocol, URLSessionDelegate {
    
    var imageCache = NSCache<NSString, UIImage>()
    
    private lazy var onloadURL : URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.data.gov.sg"
        components.path = "/v1/transport/traffic-images"
        let dateQueryItem = URLQueryItem(name: "date-time", value: self.getTimeStamp())
        components.queryItems = [dateQueryItem]
        return components
    }()
    
    
    func getTimeStamp() -> String {
        let date = Date()
        print(date)
        return "2020-08-01T09:09:09"
    }
    
    
    func callSingaporeTrafficCameraAPI(completionHandler: @escaping (Result<ResponseDataModel, NetworkError>) ->Void) {
        
        guard let url = self.onloadURL.url else {
            DispatchQueue.main.async {
                completionHandler(.failure(.badURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = kTimeoutInterval
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                //error found
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error.localizedDescription)))
                }
                return
            }

            //error NOT found
            guard let httpStatus = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.badResponseError))
                }
                return
            }

            if (httpStatus.statusCode == 200 || httpStatus.statusCode == 201) {
                //StatusCode == 200 || 201
                guard let responseDataModel = ResponseDataModel.convert(fromJSONData : data) else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.parsingError))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completionHandler(.success(responseDataModel))
                }
            }
        }
        task.resume()
    }
    
    func fetchCameraImage(url: URL, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        //Check if Image cached already
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            //If pre-cached return cachedImage
            completionHandler(.success(cachedImage))
        } else {
            //If NOT pre-cached
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            let task = session.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    //error found
                    DispatchQueue.main.async {
                        completionHandler(.failure(.networkError(error: error.localizedDescription)))
                    }
                    return
                }
                
                //error NOT found
                guard let httpStatus = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.badResponseError))
                    }
                    return
                }
                
                if (httpStatus.statusCode == 200 || httpStatus.statusCode == 201) {
                    //StatusCode == 200 || 201
                    guard let dataReceived = data, let image = UIImage(data: dataReceived) else {
                        DispatchQueue.main.async {
                            completionHandler(.failure(.imageConversionError))
                        }
                        return
                    }
                    //save in cache
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        completionHandler(.success(image))
                    }
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: - Status Bar Setup Related Methods
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}



