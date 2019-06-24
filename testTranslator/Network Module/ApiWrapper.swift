//
//  ApiWrapper.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol ApiWrapperProtocolInput {
    func translateText(text: String, lang: String) -> Void
}

protocol ApiWrapperProtocolOutput: class {
    func translatedTextFromApiWrapper(text: DecodableResultText)
}

class ApiWrapper: ApiWrapperProtocolInput {
   
    var interactor: TranslateInteractorProtocolInput!
    
    func translateText(text: String, lang: String) {
        self.translateText(text: text, lang: lang) { (decodableResult, error) in
            guard let decodable = decodableResult else {
                print("ERROR: \(String(describing: error?.localizedDescription))")
            return
            }
            self.interactor.translatedTextFromApiWrapper(text: decodable)
        }
    }
    
    private func request(params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
     
        let paramStr = params.map { "\($0)\($1)" }.joined(separator: "&")
        
        let urlString = "\(ConstantsForRequest.url)?key=\(ConstantsForRequest.apiKey)&\(paramStr)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlString!)
        let request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    func translateText(text: String, lang: String, completion: @escaping (DecodableResultText?, Error?) -> Void) {
        
        let params = ["text=": text, "lang=": lang]
        request(params: params) { (data, error) in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let response = try? JSONDecoder().decode(DecodableResultText.self, from: data)
            completion(response, nil)
        }
    }
}
