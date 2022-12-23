


import Foundation
import SwiftyJSON

struct ThemeModel: Codable{
    
    var fontSize : FontSize!
    var customFonts : CustomFont!
    var colors: Colors!
    var API: CustomAPI!
    
 init(data: Data) throws {
    self = try JSONDecoder().decode(ThemeModel.self, from: data)
    }
}


