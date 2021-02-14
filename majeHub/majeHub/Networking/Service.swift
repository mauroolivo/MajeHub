import Foundation
import Combine
import PromiseKit

class Service {
    
    var api = Api(ApiConfig.DOMAIN)
    
    var subscribers = Set<AnyCancellable>()
    var urlSession: URLSession { URLSession.shared }
    
    func execute<T: Decodable>(_ endPoint: EndPoint) -> Promise<T> {
        
        return Promise { seal in
            api.execute(endPoint.request()) {
                $0.acceptingJSON()
                  .basichAuth()
            }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    seal.resolve(nil, error)
                    break
                }
            }) { (value) in
                seal.resolve(value, nil)
            }.store(in: &subscribers)
        }
    }
    
}

