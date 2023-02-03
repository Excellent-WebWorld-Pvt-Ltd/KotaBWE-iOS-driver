//
//  WebServices.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 24/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit


typealias CompletionResponse = (_ json: JSON, _ status: Bool) -> ()

class WebService{
    
    static let shared = WebService()
    
    private init() {}

    
    // //-------------------------------------
    // MARK:- Method for Get, post..
    //-------------------------------------
    
    func requestMethod(api: ApiKey, httpMethod:Method,parameters: Any, completion: @escaping CompletionResponse){

        guard isConnected else { completion(JSON(), false); return }
        
        
        var parameterString = ""
        if httpMethod == .get{
            if let param = parameters as? [String:Any]{
                let dictData = param as! [String:String]
                for value in dictData.values {
                    let temp = "/"
                    parameterString = parameterString + temp + String(value) //+ "/"
                }
            }
        }
        else { parameterString = "" }
        
        guard let url = URL(string: NetworkEnvironment.apiURL + api.rawValue + parameterString) else {
            completion(JSON(),false)
            return
        }
        
        print("the url is \(url) and the parameters are \n \(parameters) and the headers are \(NetworkEnvironment.headers)")
        
        let method = Alamofire.HTTPMethod.init(rawValue: httpMethod.rawValue)!

        var params = parameters

        if(method == .get)
        {
            params = [:]
        }

//        Loader.showHUD(with: Helper.currentWindow)
        
        Alamofire.request(url, method: method, parameters: params as? [String : Any], encoding: URLEncoding.httpBody, headers: NetworkEnvironment.headers).validate()
            .responseJSON { (response) in
               // LoaderClass.hideActivityIndicator()
//         Loader.hideHUD()
                
                if let json = response.result.value{
                    let resJson = JSON(json)
                    print("the response is \n \(resJson)")
                    let status = resJson["status"].boolValue
                    completion(resJson, status)
                }
                else {
                  //  LoaderClass.hideActivityIndicator()
                    if let error = response.result.error {

                        if(response.response?.statusCode == 403)
                        {
                            SessionManager.shared.logout()
                            AlertMessage.showMessageForError("Session expired!")
                        }else
                        {
                            print("Error = \(error.localizedDescription)")
                            completion(JSON(), false)
                            AlertMessage.showMessageForError(error.localizedDescription)

                        }
                    }
                }
            }

    }


    func getMethod(url: URL, httpMethod:Method, completion: @escaping CompletionResponse)
    {
        print("The webservice call is for \(url) and  the headers are \(NetworkEnvironment.headers)")
        
        
//        Loader.showHUD(with: Helper.currentWindow)
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: NetworkEnvironment.headers)
            .validate()
            .responseJSON { (response) in
                // LoaderClass.hideActivityIndicator()
//                Loader.hideHUD()
                
                
                if let json = response.result.value{
                    let resJson = JSON(json)
                    print("the response is \(resJson)")
                    
                    if "\(url)".contains("geocode/json?latlng=") {
                        let status = resJson["status"].stringValue.lowercased() == "ok"
                        completion(resJson, status)
                    }
                    else {
                        let status = resJson["status"].boolValue
                        completion(resJson, status)
                    }
                }
                else {
                    //  LoaderClass.hideActivityIndicator()
                    if let error = response.result.error {
                        if(response.response?.statusCode == 403)
                        {
                            SessionManager.shared.logout()
                            AlertMessage.showMessageForError("Session expired!")
                        }
                        else
                        {
                            print("Error = \(error.localizedDescription)")
                            completion(JSON(), false)
                            AlertMessage.showMessageForError(error.localizedDescription)

                        }
                    }
                }
             }
         }

    // //-------------------------------------
    // MARK:- Multiform Data
    //-------------------------------------
    
    func uploadMultipartFormData(api: ApiKey,from images: [String:UIImage],completion: @escaping CompletionResponse){
        
        guard isConnected else { completion(JSON(), false); return }
//        Loader.showHUD(with: Helper.currentWindow)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                    for (key,value) in images{
                        if let imageData = value.jpegData(compressionQuality: 0.6) {
                            multipartFormData.append(imageData, withName: key, mimeType: "image/jpeg")
                        }
                    }
                
        },usingThreshold:10 * 1024 * 1024,
            to: (NetworkEnvironment.apiURL + api.rawValue), method:.post,
            headers:NetworkEnvironment.headers,
            encodingCompletion: { encodingResult in
//                Loader.hideHUD()
                print("the response is \n \(encodingResult)")
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    func postDataWithImage(api: ApiKey, parameter dictParams: [String: Any], image: UIImage?, imageParamName: String, completion: @escaping CompletionResponse) {
        
        guard isConnected else { completion(JSON(), false); return }

//           Loader.showHUD(with: Helper.currentWindow)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = image?.getData(inKb: 500) {
                multipartFormData.append(imageData, withName: imageParamName, fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in dictParams {
                if JSONSerialization.isValidJSONObject(value) {
                    let array = value as! [String]
                    
                    for string in array {
                        if let stringData = string.data(using: .utf8) {
                            multipartFormData.append(stringData, withName: key+"[]")
                        }
                    }
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: 10 *  1024 * 1024, to: (NetworkEnvironment.apiURL + api.rawValue),
           method: .post, headers: NetworkEnvironment.headers) { (encodingResult) in
//            Loader.hideHUD()
             print("the response is \n \(encodingResult)")
            switch encodingResult
            {
            case .success(let upload,_,_):
                
               upload.responseJSON {
                    response in
                    
                    if let json = response.result.value {
                        
                        if (json as AnyObject).object(forKey:("status")) as! Bool == false {
                            let resJson = JSON(json)
                            completion(resJson, false)
                        }
                        else {
                            let resJson = JSON(json)
                            print(resJson)

                            completion(resJson, true)
                        }
                    }
                    else {
                        if let error = response.result.error {
                            print("Error = \(error.localizedDescription)")
                        }
                    }
                }
            case .failure( _):
                print("failure")
                break
            }
        }
    }
    
    func postDataWithArrayImages(api: ApiKey, parameter dictParams: [String: Any], image: [UIImage], imageParamName: [String], completion: @escaping CompletionResponse) {
        
        guard isConnected else { completion(JSON(), false); return }
        
//        Loader.showHUD(with: Helper.currentWindow)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
            for (ind, img) in image.enumerated() {
                if let imageData = img.jpegData(compressionQuality: 0.6) {
                    multipartFormData.append(imageData, withName: imageParamName[ind], fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            }
            
            for (key, value) in dictParams {
                if JSONSerialization.isValidJSONObject(value) {
                    let array = value as! [String]
                    
                    for string in array {
                        if let stringData = string.data(using: .utf8) {
                            multipartFormData.append(stringData, withName: key+"[]")
                        }
                    }
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: 10 *  1024 * 1024, to: (NetworkEnvironment.apiURL + api.rawValue),
           method: .post, headers: NetworkEnvironment.headers) { (encodingResult) in
//            Loader.hideHUD()
             print("the response is \n \(encodingResult)")
            switch encodingResult
            {
            case .success(let upload,_,_):
                
                upload.responseJSON {
                    response in
                    
                    if let json = response.result.value {
                        
                        if (json as AnyObject).object(forKey:("status")) as! Bool == false {
                            let resJson = JSON(json)
                            completion(resJson, false)
                        }
                        else {
                            let resJson = JSON(json)
                            print(resJson)
                            
                            completion(resJson, true)
                        }
                    }
                    else {
                        if let error = response.result.error {
                            print("Error = \(error.localizedDescription)")
                        }
                    }
                }
            case .failure( _):
                print("failure")
                break
            }
        }
    }
    
    
    class func getGoogleMapDirections(origin: String, destination: String, completion: @escaping CompletionResponse) {
        let parameters: [String: Any] = ["origin": origin,
                                         "destination": destination,
                                         "key": (UIApplication.shared.delegate as! AppDelegate).googlApiKey]
        Alamofire.request(baseURLDirections,
                          method: .get,
                          parameters: parameters)
            .validate()
                .responseJSON { (response) in
                    if let json = response.result.value{
                        let resJson = JSON(json)
                        let status = resJson["status"].stringValue.lowercased() == "ok"
                        completion(resJson, status)
                    }
                    else {
                        if let error = response.result.error {
                            print("Error = \(error.localizedDescription)")
                            completion(JSON(), false)
                            AlertMessage.showMessageForError(error.localizedDescription)
                        }
                    }
            }
    }
    
    func uploadDocument(_ data: Any,
                        key: String = "image",
                        resultCallback: @escaping (_ url: String?) -> Void) {
        guard isConnected, let mineType = MimeTypes(data, key: key) else {
            resultCallback(nil)
            return
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(mineType.data, withName: mineType.key, fileName: mineType.fileName, mimeType: mineType.mimeType)
        }, usingThreshold: 10 *  1024 * 1024, to: (NetworkEnvironment.apiURL + ApiKey.docUpload.rawValue),
           method: .post, headers: NetworkEnvironment.headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
               upload.responseJSON {
                    response in
                   if let json = response.result.value {
                       let resJson = JSON(json)
                       print("the response is \n \(resJson)")
                       resultCallback(resJson["url"].stringValue)
                   } else {
                       resultCallback(nil)
                   }
                }
            case .failure( _):
                print("failure")
                resultCallback(nil)
                break
            }
        }
    }
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    var dictionary: [String: Any]? {
            guard let data = try? JSONEncoder().encode(self) else { return nil }
            return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
        }
 }

extension WebService{
    var isConnected : Bool{
        guard isConnectedToInternet() else {
            AlertMessage.showMessageForError("Please Connect to Internet")
            //  LoaderClass.hideActivityIndicator()
            return false
        }
        return true
    }
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

