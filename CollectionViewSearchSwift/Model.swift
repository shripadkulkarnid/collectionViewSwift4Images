


import Foundation

typealias Model = [ModelElement]

class ModelElement: Codable {
    
    let format: Format?
    let width, height: Int?
    let filename: String?
    let id: Int?
    let author: String?
    let authorURL, postURL: String?
    var baseURl:String? = "https://picsum.photos/300/300?image="
    enum CodingKeys: String, CodingKey {
        case format, width, height, filename, id, author,baseURl
        case authorURL = "author_url"
        case postURL = "post_url"
    }
    
    init(format: Format?, width: Int?, height: Int?, filename: String?, id: Int?, author: String?, authorURL: String?, postURL: String?,baseURl:String?) {
        self.format = format
        self.width = width
        self.height = height
        self.filename = filename
        self.id = id
        self.author = author
        self.authorURL = authorURL
        self.postURL = postURL
        self.baseURl = baseURl!
    }
}

enum Format: String, Codable {
    case jpeg = "jpeg"
    case png = "png"
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func modelTask(with url: URL, completionHandler: @escaping (Model?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
