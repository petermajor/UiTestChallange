import Foundation

class FreesatShowcaseQuery: ShowcaseQuery {
    
    private let configuration: Configuration
    private let batId = 280
    private let regionId = 50
    private let format = "json"
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    var url: URL {
        return configuration.baseRegionalUrl.appendingPathComponent("sc/\(format)/\(batId)/\(regionId)")
    }
    
    func execute(completion: @escaping (ShowcaseResponse?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            guard let result = try? decoder.decode(ShowcaseResponse.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(result)
        }
        dataTask.resume()
    }
}
