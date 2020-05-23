//
//  BaseNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Remove square brackets for POST request
struct CustomPostEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        let httpBody = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!
        request.httpBody = httpBody.replacingOccurrences(of: "%5B%5D=", with: "=").data(using: .utf8)
        return request
    }
}

class BaseNetworking {
    
    lazy var constant: Constant = { return Constant() }()
    lazy var preference: Preference = { return Preference() }()
    lazy var function: PublicFunction = { return PublicFunction() }()
    
    func getHeaders() -> [String: String] {
        return [ "Authorization": "Bearer \(preference.getString(key: constant.TOKEN))" ]
    }
    
    func baseUrl() -> String {
        return preference.getBool(key: constant.IS_RELEASE) ? constant.base_url_prod : constant.base_url_dev
    }
    
    func alamofirePost<T: Decodable>(url: String, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        AF.request(url, method: .post, parameters: body, headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                print(JSON(success))
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 {
                    guard let mData = response.data else { return}

                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }

                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }

            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
    func alamofirePostFile<T: Decodable>(data: Data, keyParameter: String, fileName: String, fileType: String, url: String, body: [String: Any]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: keyParameter, fileName: fileName, mimeType: fileType)
            
            if let _body = body {
                for (key, value) in _body { multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key) }
            }
            
        }, to: url, method: .post, headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                print(JSON(success))
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 || status == 403 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }
            case .failure(let error): 
                completion(error.localizedDescription, nil, nil)
                print(error.localizedDescription)
            }
        }
    }
    
//    func alamofirePostListImage<T: Decodable>(listFiles: [LampiranModel], url: String, headers: [String: String], body: [String: String], completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            for (index, item) in listFiles.enumerated() {
//                var fileType = ""
//
//                if item.file.contains(".") {
//                    fileType = item.file.components(separatedBy: ".")[1]
//                }
//
//                multipartFormData.append(item.data, withName: "attachment[\(index)]", fileName: item.file, mimeType: fileType)
//            }
//
//            for (key, value) in body { multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key) }
//
//        }, to: url, method: .post, headers: getHeaders())
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
//
//                upload.responseJSON { response in
//
//                    switch response.result {
//                    case .success(let success):
//                        print(JSON(success))
//
//                        let status = JSON(success)["status"].int
//                        let message = JSON(success)["message"].string
//
//                        if status == 200 || status == 201 {
//                            guard let mData = response.data else { return}
//
//                            do {
//                                let data = try JSONDecoder().decode(T.self, from: mData)
//                                completion(nil, data, nil)
//                            } catch let err { completion(err.localizedDescription, nil, nil) }
//
//                        } else if status == 401 {
//                            completion(nil, nil, true)
//                        } else {
//                            completion(message, nil, nil)
//                        }
//                    case .failure(let error): completion(error.localizedDescription, nil, nil)
//                    }
//                }
//
//            case .failure(let encodingError): completion(encodingError.localizedDescription, nil, nil)
//            }
//        }
//    }
    
    func alamofirePostFormData<T: Decodable>(url: String, body: [String: Any]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        
        AF.request(url, method: .post, parameters: body, encoding: CustomPostEncoding(), headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                print("success \(JSON(success))")
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err {
                        print(err.localizedDescription)
                        completion(err.localizedDescription, nil, nil)
                    }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
    func alamofirePostFormData<T: Decodable>(url: String, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        AF.request(url, method: .post, parameters: body, headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                print("success \(JSON(success))")
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err {
                        print(err.localizedDescription)
                        completion(err.localizedDescription, nil, nil)
                    }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
    func alamofirePostJSONRequest<T: Decodable>(url: String, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                print(JSON(success))
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
    func alamofireGet<T: Decodable>(url: String, body: [String: String]?, completion: @escaping (_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        AF.request(url, method: .get, parameters: body, headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                print(JSON(success))
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
    func alamofireDelete<T: Decodable>(url: String, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        print(url)
        AF.request(url, method: .delete, parameters: body, headers: HTTPHeaders(getHeaders())).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                print(JSON(success))
                let status = response.response?.statusCode
                print("status code \(status ?? 0)")
                let messages = JSON(success)["messages"].arrayObject as? [String]
                
                if status == 200 || status == 201 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(messages?[0] ?? "networking_error".localize(), nil, nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
}
