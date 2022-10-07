//
//  NetworkManager.swift
//  GORA_TestTask
//
//  Created by Kirill Drozdov on 13.06.2022.
//

import Alamofire
import UIKit

final class NetworkManager {
    
    static var shared = NetworkManager()
    private init?(){}
    
    private var apiKey: String {
        return "3dfa27f44b9f44c6a4dd934434fcf7d3"
    }
    
    private var url: String {
        return "https://newsapi.org/v2/top-headlines?country=us&pageSize=25&category="
    }
    
    func fetchNews(completion: @escaping (_ news: [NewsCategories: News]) -> Void) {
        var result = [NewsCategories: News]()
        let group = DispatchGroup()
        
        NewsCategories.allCases.forEach { category in
            let request = AF.request(url + category.title + "&apiKey=\(apiKey)")
            group.enter()
            
            request.responseDecodable(of: News.self) { response in
                switch response.result {
                case .success(let data):
                    guard data.articles != nil else {return}
                    result[category] = data
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(result)
        }
    }
    
}
