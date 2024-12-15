
 
import SwiftUI

struct WeatherResponseModel: Decodable {
    var location: location?
    var current: Current?
}

struct location: Decodable {
    var name : String?
}

struct Current: Decodable {
    var temp_c,humidity,feelslike_c,uv: Double?

    var condition : condition?
}

struct condition : Decodable {
    var icon : String?
    
    var url : URL? {
        guard let icon else { return nil }
        return URL(string: "https:\(icon)")
    }
}


struct ErrorResponseModel : Decodable {
    var error:ErrorModel?
}

struct ErrorModel: Decodable {
    let message: String?
    let code: Int?
}
