
import Foundation


// method of api
enum Method : String{
    case get = "GET",post = "POST",delete = "DELETE",put = "PUT",patch = "PATCH"
}

// Enum for network errors
enum NetworkError: Error {
    case invalidUrl, networkError(Error), decodingError(Error), unauthorized, invalidResponse, errorResponse(Decodable?)
}

struct RequestParameters {
    let url: URL
    let httpMethod: Method = .get
    var header: [String: String]? = nil
    var parameters: [String: Any]? = nil
    var timeOut: TimeInterval = 60
}

extension URLSession :  @retroactive URLSessionDelegate{
    
    private func createURLRequest(_ resource: RequestParameters,url : URL) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: resource.timeOut)
        request.httpMethod = resource.httpMethod.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept": "application/json"]
        resource.header?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
    
    func request<T: Decodable, D: Decodable>(_ resource: RequestParameters, successModel: T.Type, failureModel: D.Type) async throws -> T {
        guard let encodedURL = resource.url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else { throw NetworkError.invalidUrl }
        
        var request = createURLRequest(resource, url: url)
        
        if resource.httpMethod == .get, let parameters = resource.parameters {
            var urlComponents = URLComponents(string: encodedURL)
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
            request.url = urlComponents?.url
        } else if let parameters = resource.parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        return try await urlRequest(request: request, successModel: successModel, failureModel: failureModel)
    }
    
    private func urlRequest<T: Decodable, D: Decodable>(request: URLRequest, successModel: T.Type, failureModel: D.Type) async throws -> T {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        do {
            let (data, response) = try await session.data(for: request)
            print(
        """
        response is
        =================
        \(String(data: data, encoding: .utf8)?.toJsonObject() ?? "NO Response")
        =================
        """)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorResponse = try JSONDecoder().decode(failureModel.self, from: data)
                throw NetworkError.errorResponse(errorResponse)
            }
            
            do {
                let success = try JSONDecoder().decode(successModel.self, from: data)
                return success
            } catch {
                print("Partial decoding failed: \(error)")
                throw NetworkError.invalidResponse
            }
            
            
        }catch{
            throw error // Rethrow other errors
        }
    }
}

extension String{
    func toJsonObject() -> Any? {
        if let data = self.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }
        return nil
    }
}
