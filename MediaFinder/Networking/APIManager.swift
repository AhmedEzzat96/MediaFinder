import Foundation
import Alamofire

class APIManager {
    class func loadMedia(search: String, scope: String, completion: @escaping (_ error: Error?, _ receivedMedia: [Media]?, _ apiData: Int?) -> Void) {
        let parameters = [ParamKeys.media: scope, ParamKeys.term: search]
        
        AF.request(Urls.baseUrl, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil, nil)
                return
            }
            guard let data = response.data else {
                print("didnt get any data from API")
                return
            }
            do {
                let decoder = JSONDecoder()
                let apiResults = try decoder.decode(Results.self, from: data).resultCount
                let apiData = try decoder.decode(Results.self, from: data).results
                
                completion(nil, apiData, apiResults)
            }
            catch let error {
                print(error)
            }
        }
    }
}
