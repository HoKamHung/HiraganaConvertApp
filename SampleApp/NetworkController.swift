//
//  NetworkController.swift
//  SampleApp
//
//  Created by Ho Kam Hung on 2/10/2019.
//  Copyright © 2019 Ho Kam Hung. All rights reserved.
//

import UIKit
protocol NetworkControllerDelegate
{
    func responseStringOfHiragana(_ hiraganaString: String, index:Int);
}

class NetworkController: NSObject {
    let convertToHiraganaUrl: String = #"https://labs.goo.ne.jp/api/hiragana"#
    let getStringResponseUrl: String = #""#
    let gooApplicationId: String = #"2da31164796d7a6b63f6338a9b963d84494301822b5f5e9c529aa59c93513a73"#
    
    var delegate: NetworkControllerDelegate?
    
    override init() {
        
    }
    
    func convertStringToHiragana(inputString:String, index:Int)
    {
        let url: URL = URL(string: convertToHiraganaUrl)!
        var request: URLRequest = URLRequest(url: url as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        let requestBody: [String: Any] = ["app_id":gooApplicationId, "sentence":inputString, "output_type":"hiragana"]
        let requestJson = try? JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = requestJson;
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let responseType : String = responseJSON["output_type"] as! String
                if responseType == "hiragana" {
                    self.delegate?.responseStringOfHiragana(responseJSON["converted"] as! String, index: index);
                }
            }
        }
        
        task.resume()
    }
}
