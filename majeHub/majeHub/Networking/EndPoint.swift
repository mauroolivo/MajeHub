import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String: Any]

protocol EndPoint {
    var url: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get } 
    var headers: HTTPHeaders? { get }
    var body: Data? { get }
    var urlParams: Parameters? { get }
}

extension EndPoint {
    
    func request()-> URLRequest {
        
            var request = URLRequest(url: url.appendingPathComponent(path))
            
            request.httpMethod = httpMethod.rawValue
            request.setHeaders(headers)
            request.setUrlParams(urlParams)
            request.httpBody = body
        
            return request
        
    }

}

struct UsersEndPoint: EndPoint {
    let url = URL(string: ApiConfig.DOMAIN)!
    var path = "/users"
    let httpMethod = HTTPMethod.get
    var body: Data?
    var headers: HTTPHeaders?
    var urlParams: Parameters?

    init() {}
    
}

struct SearchUsersEndPoint: EndPoint {
    let url = URL(string: ApiConfig.DOMAIN)!
    var path = "/search/users"
    let httpMethod = HTTPMethod.get
    var body: Data?
    var headers: HTTPHeaders?
    var urlParams: Parameters?

    init(_ q: String) {
        self.urlParams = ["q": q]
    }
    
}

struct UserEndPoint: EndPoint {
    let url = URL(string: ApiConfig.DOMAIN)!
    var path = "/users"
    let httpMethod = HTTPMethod.get
    var body: Data?
    var headers: HTTPHeaders?
    var urlParams: Parameters?

    init(_ user: String) {
        path = "\(path)/\(user)"
    }
    
}

struct ReposEndPoint: EndPoint {
    let url = URL(string: ApiConfig.DOMAIN)!
    var path = "/users"
    let httpMethod = HTTPMethod.get
    var body: Data?
    var headers: HTTPHeaders?
    var urlParams: Parameters?

    init(_ user: String) {
        path = "\(path)/\(user)/repos"
    }
    
}

struct SearchRepositoriesEndPoint: EndPoint {
    let url = URL(string: ApiConfig.DOMAIN)!
    var path = "/search/repositories"
    let httpMethod = HTTPMethod.get
    var body: Data?
    var headers: HTTPHeaders?
    var urlParams: Parameters?

    init(_ q: String) {
        self.urlParams = ["q": q]
    }
    
}
