//
//  API.swift
//  DemoApp
//
//  Created by Amzad Khan on 07/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//
import UIKit
import Alamofire
import SystemConfiguration



public protocol APIURLConvertible {
    var url:URL! {get}
    var api:APIRequirement! {get}
}

public typealias APISuccessHandler = (_ jsonObject: [String:Any]?) ->Void
public typealias APIFailureHandler = (_ error: Error?, _ jsonObject: [String:Any]?) ->Void
public typealias APITokenExpireHandler = () ->Void

public protocol APIValidationRequirement {
    func validateAllResponse(_ JSON:Any?, error:Error?, success:APISuccessHandler?, failed:APIFailureHandler?)
}
public protocol APIRequirement {
    static var baseURL: String {get}
    var apiHeader: [String:String]! {get}
    var apiPath: String {get}
    var imagePath: String {get}
    var methodPath: String { get }
    
    func finalParameters(from parameters: [String : Any]) -> [String : Any]
    func tokenDidExpired() -> Void
    
    @discardableResult func request(method: Alamofire.HTTPMethod, with parameters: [String : Any]!) -> Alamofire.DataRequest!
    func requestUpload(with parameters: [String: Any]?, files: [String: Any]?, success:APISuccessHandler?, failed:APIFailureHandler?)
    
    func validatedResponse(_ response: DataResponse<Any>, success:APISuccessHandler?, failed:APIFailureHandler?)
    func validatedResponse(_ response: SessionManager.MultipartFormDataEncodingResult, success:APISuccessHandler?, failed:APIFailureHandler?)
}

extension APIRequirement {
    func finalParameters(from parameters: [String : Any]) -> [String : Any] { return parameters }
    func tokenDidExpired() -> Void { }
}

open class APIReachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable     = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection) ? true : false
    }
}


public enum APIError: Error {
    case emptyDataError
    case invalidData

    var localizedDescription: String {
        switch self {
        case .emptyDataError:
            return NSLocalizedString("Items not available!.", comment: "My error")
        case .invalidData:
            return NSLocalizedString("Server responds with invalid data!.", comment: "My error")
        }
    }
}


public enum APIState<T> {
    case loading
    case loaded(T)
    case empty
    case error(Error)
    
    var data: T? {
        switch self {
        case .loaded(let item):
            return item
        default:
            return nil
        }
    }
}

extension APIState: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .loaded: return "SUCCESS"
        case .error: return "FAILURE"
        case .loading: return "LOADING"
        case .empty: return "NONE"
        }
    }
}

extension APIState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .loaded(let value): return "SUCCESS: \(String(describing: value))"
        case .error(let error): return "FAILURE: \(String(describing: error))"
        case .loading: return "LOADING..."
        case .empty: return "DATA NOT AVAILABLE"
        }
    }
}

public struct JSONArrayEncoding: ParameterEncoding {
    private let array: [Parameters]
    
    init(array: [Parameters]) {
        self.array = array
    }
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        
        return urlRequest
    }
}


extension APIRequirement {
    
    @discardableResult func download(method: Alamofire.HTTPMethod = .post, with parameters: [String : Any]!, fileName:String?) -> Alamofire.DownloadRequest? {
        let fileDestination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName ?? "temp.txt")
            return (documentsURL, [.removePreviousFile])
        }
        
        
        let finalParameters  = self.finalParameters(from: parameters ?? [String:Any]())
        print("\n**** Request method: \(method, apiPath + methodPath)\n")
        print("Header: \(self.apiHeader.json().replacingOccurrences(of: "\\/", with: "/"))")
        let paramJSON  = finalParameters.json()
        print(paramJSON)
        return Alamofire.download(apiPath + methodPath, method: method, parameters: finalParameters, encoding: URLEncoding.default, headers: self.apiHeader, to: fileDestination)
    }
    
    @discardableResult func download(url:String, method: Alamofire.HTTPMethod = .post, with parameters: [String : Any]!, fileName:String?) -> Alamofire.DownloadRequest? {
        
        let fileDestination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName ?? "temp.txt")
            return (documentsURL, [.removePreviousFile])
        }
        
        print("\n**** Request method: \(method.rawValue, url)\n")
        print(parameters.json().replacingOccurrences(of: "\\/", with: "/"))
        return Alamofire.download(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil, to: fileDestination)
        
    }
    
    @discardableResult static func request(url:String, method: Alamofire.HTTPMethod = .post, with parameters: [String : Any]!) -> Alamofire.DataRequest! {
        print("\n**** Request method: \(method.rawValue, url)\n")
        print(parameters.json().replacingOccurrences(of: "\\/", with: "/"))
        let request =  Alamofire.request(url, method: method, parameters:parameters, encoding: URLEncoding.default, headers: nil)
        print("Encoded Request: \(request.request!.httpMethod!) - \(request.request!.url!.absoluteString)\n\(request.request!.httpBody.map { body in String(data: body, encoding: .utf8) ?? "" } ?? "")")
        return request
        //return Alamofire.request(url, method: Alamofire.HTTPMethod.post, parameters: finalParameters, encoding: JSONEncoding.default/*, headers: self.apiHeader*/)
    }
    
    @discardableResult func request(method: Alamofire.HTTPMethod = .post, with parameters: [String : Any]!) -> Alamofire.DataRequest! {
        let finalParameters  = self.finalParameters(from: parameters ?? [String:Any]())
        print("\n**** Request method: \(method, apiPath + methodPath)\n")
        let paramJSON  = finalParameters.json()
        print(paramJSON)
        //print("Parameter JSON: \(Global.stringifyJson(finalParameters))")
        let request = Alamofire.request(apiPath + methodPath, method: method, parameters: finalParameters, encoding: URLEncoding.default, headers: self.apiHeader)
        print("Encoded Request: \(request.request!.httpMethod!) - \(request.request!.url!.absoluteString)\n\(request.request!.httpBody.map { body in String(data: body, encoding: .utf8) ?? "" } ?? "")")
        return request
    }
    
    @discardableResult func request(parameters: [[String : Any]]!) -> Alamofire.DataRequest! {
        
        print("\n**** Request method: \(HTTPMethod.post, apiPath + methodPath)\n")
        print("Header: \(self.apiHeader.json().replacingOccurrences(of: "\\/", with: "/"))")
        let paramJSON  = parameters.json()
        print(paramJSON)
        
        let parameters : [Parameters] = parameters.map({$0})
        let request = Alamofire.request(apiPath + methodPath, method: .post, encoding: JSONArrayEncoding(array: parameters), headers: self.apiHeader)
        print("POST Parameter JSON: \(Global.stringifyJson(parameters))")
        
        return request
    }
    
    func requestUpload(with parameters: [String: Any]? = nil, files: [String: Any]? = nil, success:APISuccessHandler?, failed:APIFailureHandler?) {
        Alamofire.upload( multipartFormData: { multipartFormData in
            // Attach image
            if let files = files {
                for (key, value) in files {
                    if value is UIImage {
                        let imageData = (value as! UIImage).lowestQualityJPEGData
                        //let imageData = UIImageJPEGRepresentation(value as! UIImage , 0.6)
                        multipartFormData.append(imageData ?? NSMutableData() as Data, withName: key, fileName: "\(key)_\(UUID().uuidString).jpg", mimeType: "image/jpg")
                        print("\(key)_\(UUID().uuidString).jpg")
                    } else if value is [UIImage] {
                        for (index, item) in (value as! [UIImage]).enumerated() {
                            let imageData = item.lowestQualityJPEGData
                            //let imageData = UIImageJPEGRepresentation(item ,0.6)
                            multipartFormData.append(imageData, withName: "\(key)[\(index)]", fileName:  "\(key)_\(UUID().uuidString).jpg", mimeType: "image/jpg")
                            print("\(key)_\(UUID().uuidString).jpg")
                        }
                        //Other File Code Later
                    }else if value is URL {
                        let url  = value as! URL
                        let extention = url.pathExtension
                        if extention == "m4a" {
                            multipartFormData.append(value as! URL, withName: key, fileName: "\(key).\(extention)", mimeType: "audio/\(extention)")
                        } else {
                            multipartFormData.append(value as! URL, withName: key, fileName: "\(key).\(extention)", mimeType: "video/\(extention)")
                        }
                    }else if value is [URL] {
                        for (index, item) in (value as! [URL]).enumerated() {
                            let extention = item.pathExtension
                            if extention == "m4a" {
                                multipartFormData.append(item, withName: "\(key)[\(index)]", fileName: "\(key)\(index).\(extention)", mimeType: "audio/\(extention)")
                            } else {
                                multipartFormData.append(item, withName: "\(key)[\(index)]", fileName: "\(key)\(index).\(extention)", mimeType: "video/\(extention)")
                            }
                        }
                    }
                }
            }
            
            let finalParameters  = self.finalParameters(from: parameters ?? [String:Any]())
            print("\n**** Request method: .post, \(self.apiPath + self.methodPath)\n")
            
            for (key, value) in finalParameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        },to: apiPath + methodPath , method: .post , headers: self.apiHeader,
          encodingCompletion: { encodingResult in
            self.validatedResponse(encodingResult, success: success, failed:failed)
        })
    }
}


extension APIValidationRequirement {
    
    func validatedResponse(_ response: DataResponse<Any>, success:APISuccessHandler?, failed:APIFailureHandler?) {
        switch response.result {
        case .success(let JSON):
            self.validateAllResponse(JSON, error: nil, success: success, failed: failed)
        case .failure(let error):
            let data = response.data != nil ? String(data: response.data!, encoding: String.Encoding.utf8) : nil
            self.validateAllResponse(data, error: error, success: success, failed: failed)
        }
    }
    
    func validatedResponse(_ response: SessionManager.MultipartFormDataEncodingResult, success:APISuccessHandler?, failed:APIFailureHandler?) {
        switch response {
        case .success(let JSON,_,_):
            JSON.responseJSON { responseResult in
                guard let response = responseResult.result.value as? [String: Any] else {
                    let data = responseResult.data != nil ? String(data: responseResult.data!, encoding: String.Encoding.utf8) : nil
                    self.validateAllResponse(data, error: NSError(domain: UIApplication.appName, code: 404, userInfo:[NSLocalizedDescriptionKey : "Something went wrong\nPlease try again soon!."]), success: success, failed: failed)
                    return
                }
                self.validateAllResponse(response, error: nil, success: success, failed: failed)
            }
        case .failure(let error):
            self.validateAllResponse(nil, error: error, success: success, failed: failed)
        }
    }
    /*
     func validatedResponse(_ JSON:Any?, error:Error?, success:APISuccessHandler?, failed:APIFailureHandler?) {
     if let apiError = error {
     #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
     if let responseString  = JSON as? String {
     print(responseString)
     }
     #endif
     guard let failedHandler = failed else {
     Global.showAlert(withMessage:apiError.localizedDescription)
     return
     }
     failedHandler(apiError, nil)
     }else if let response = JSON as? [String:Any] {
     print("Success with JSON: \(Global.stringifyJson(response).replacingOccurrences(of: "\\/", with: "/"))")
     success!(response) // Success response
     }
     }
     */
}


