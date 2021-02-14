import Foundation
import Combine


protocol RESTAPIProtocol {
    typealias RequestModifier = ((URLRequest) -> URLRequest)
    var baseURL:String { get }
    var urlSession:URLSession { get }
}

class Api: RESTAPIProtocol {
    var baseURL: String
    
    init(_ baseURL: String) {
        self.baseURL = baseURL
    }
}

extension RESTAPIProtocol {
    var urlSession: URLSession { URLSession.shared }
    
    func execute(_ request: URLRequest, requestModifier:@escaping RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        return createPublisher(for: request, requestModifier: requestModifier)
    }
    
    
    func createPublisher(for request:URLRequest, requestModifier:@escaping RequestModifier) -> URLSession.ErasedDataTaskPublisher {
        Just(request).setFailureType(to: Error.self)
            .flatMap { request -> URLSession.ErasedDataTaskPublisher in
                return self.urlSession.erasedDataTaskPublisher(for: requestModifier(request))
            }.eraseToAnyPublisher()
    }
}



