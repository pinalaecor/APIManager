//
//  APIManager.swift
//  APICallDemo
//
//  Created by Mac on 16/09/21.
//

import Foundation

//MARK: APIManager Class
public class APIManager: NSObject, APIManagerProtocol {
    
    var sslPinningType : SSLPinningType = .disable
    var isDebugOn : Bool!
    
    var manager: APIManagerProtocol!
    
    /// APIManager is simple api wrapper tool that is made for making ios development fast and easy
    /// - Parameters:
    ///   - statusCodeForCallBack: this is api status code which will be used in case you want to break normal flow and get call back.
    ///   - statusMessageKey: using this key, manager will try to get string message from json and pass it to `statusCodeCallBack`.
    ///   - statusCodeCallBack: when manager encounter code mentioned in `statusCodeForCallBack`, manager will trigger this callback to handle specific case instead of normal flow, e.g. we need to handle token expiry condition in our app we will use this call back, normal flow is broken as we do not want to show error message. call back will give message based on key provided in `statusMessageKey` param.
    ///   - sslPinningType: this is ssl pinning type
    ///   - isDebugOn: using this you can toggle debug api request print.
    public init(sslPinningType : SSLPinningType = .disable, isDebugOn : Bool = false) {
        self.sslPinningType = sslPinningType
        manager = AFAPIManager(sslPinningType: sslPinningType, isDebugOn: isDebugOn)
    }
    
}

//MARK: request with codable support
extension APIManager {
    
    func requestData(url: String, httpMethod: APIHTTPMethod, header: [String : String]? = nil, param: [String : Any]? = nil, requestTimeout: TimeInterval = 60, completion: @escaping (Int, Result<Data, Error>) -> Void) {
        
        guard Reachability.isConnectedToNetwork() == true else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                completion(APIManagerErrors.internetOffline.statusCode,.failure(APIManagerErrors.internetOffline))
            }
            return
        }
        
        manager.requestData(url: url, httpMethod: httpMethod, header: header, param: param, requestTimeout: requestTimeout, completion: completion)
        
    }
    
    /// This method is used for making request to endpoint with provided configurations.
    /// - Parameters:
    ///   - endpoint: Web Service Name
    ///   - httpMethod: Type of api request
    ///   - header: Header to be sent to api
    ///   - param: Parameters to be sent to api, if no parameter then do not pass this parameter
    ///   - requesttimeout: Request timeout
    ///   - completion: Response of API: containing codable or error
    public func requestDecodable<T:Codable>(decodeWith: T.Type, url : String, httpMethod : APIHTTPMethod, header: [String:String]? = nil, param:[String: Any]? = nil, requestTimeout: TimeInterval = 60, completion : @escaping (Int,Result<T, Error>) -> Void) {
        
        guard Reachability.isConnectedToNetwork() == true else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                completion(APIManagerErrors.internetOffline.statusCode,.failure(APIManagerErrors.internetOffline))
            }
            return
        }
        
        manager.requestDecodable(decodeWith: decodeWith, url: url, httpMethod: httpMethod, header: header, param: param, requestTimeout: requestTimeout, completion: completion)
        
    }
    
}

//MARK: request without codable support
extension APIManager {
    /// This method is used for making request to endpoint with provided configurations.
    /// - Parameters:
    ///   - endpoint: Web Service Name
    ///   - httpMethod: Type of api request
    ///   - header: Header to be sent to api
    ///   - param: Parameters to be sent to api, if no parameter then do not pass this parameter
    ///   - requesttimeout: Request timeout
    ///   - completion: Response of API: containing response data or error
    public func requestData(_ endpoint : String, httpMethod : APIHTTPMethod, header: [String:String]? = nil, param:[String: Any]? = nil, requestTimeout: TimeInterval = 60, completion : @escaping (Int,Result<Data, Error>) -> Void){
        
        guard Reachability.isConnectedToNetwork() == true else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                completion(APIManagerErrors.internetOffline.statusCode,.failure(APIManagerErrors.internetOffline))
            }
            return
        }
        
        manager.requestData(url: endpoint, httpMethod: httpMethod, header: header, param: param, requestTimeout: requestTimeout, completion: completion)
        
    }
}

extension APIManager {
    public func cancelAllRequests(){
        manager.cancelAllRequests()
    }
}
