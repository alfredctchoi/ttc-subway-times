//
//  Http.swift
//  ttc-subway-times
//
//  Created by Alfred Choi on 2017-04-24.
//  Copyright © 2017 Alfred Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class HttpService {
    static func get(url: String, queryString: Dictionary<String, String>, complete: @escaping (JSON?, URLResponse?, Error?) -> Void){
        var queryStringArray = [String]()
        
        for (key, value) in queryString {
            queryStringArray.append("\(key)=\(value)")
        }
        
        let combinedQueryString = queryStringArray.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlObj = URL(string: "\(url)?\(combinedQueryString)")
        
        let task = URLSession.shared.dataTask(with: urlObj!){
            data, response, error in
            if let data = data {
                let json = JSON(data)
                complete(json, response, error)
                return
            }
            
            complete(nil, response, error)
        }
        
        
        
        //        { data, response, error in
        //            guard error == nil else {
        //                print(error!)
        //                return
        //            }
        //
        //            guard let data = data else {
        //                print("Data is empty")
        //                return
        //            }
        //
        //            let json = JSON(data)
        //            print(json)
        //            complete(json)
        //        }
        
        task.resume()
        
    }
}
