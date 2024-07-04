//
//  CartoonListingVM.swift
//  SwiftUIDemoApp
//
//  Created by Rafaiy Rehman on 13/06/24.
//

import Foundation

enum APIErrors: Error {
case invalidRequest
case invalidResponse
case invalidResponseJSON
case emptyData
}

class CartoonListingVM {
    var apiresponseHandler: HandleAPIResponse
    var responseParser: ParseAPIResponse

    init(_ responseHandler: HandleAPIResponse = HandleAPIResponse(), _ responseParser: ParseAPIResponse = ParseAPIResponse()) {
        self.apiresponseHandler = responseHandler
        self.responseParser = responseParser
    }

    func downloadCartoonListing() async throws -> [Cartoon] {
        do {
            let listingAPI = ApisType.cartoonListing.url
            let respose = try await URLSession.shared.data(from: listingAPI)
            let result = apiresponseHandler.handleResponse(respose.0, respose.1)
                switch result {
                case .success(let success1):
                    let parsingResult = responseParser.parseResponse(success1, [Cartoon].self)
                        switch parsingResult {
                        case .success(let success):
                            print(success)
                            return success
                        case .failure(let failure):
                            print(failure)
                        }

                case .failure(let failure):
                    print(failure)
                }
        }
        catch {
            print("something went wrong \(error)")
        }
        return [Cartoon]()
    }


}

class ParseAPIResponse {
    func parseResponse<T: Decodable>(_ data: Data,_ model: T.Type)  -> Result<T, APIErrors>{
                guard let modelJson =  try? JSONDecoder().decode(model.self, from: data) else {
                    return .failure(APIErrors.invalidResponseJSON)
                }
        return .success(modelJson)
    }
}

class HandleAPIResponse {
    func handleResponse(_ data: Data?,_ response: URLResponse?) -> Result<Data, APIErrors> {
        guard let data = data else {
            return .failure(.emptyData)
        }
        guard let response = response as? HTTPURLResponse,
        200 ... 299 ~= response.statusCode else {
        return .failure(.invalidResponse)
        }
        return .success(data)
    }
}

// MARK: - Cartooon
struct Cartoon: Codable, Hashable {
    let title: String
    let year: Int
    let creator: [String]
    let rating: String
    let genre: [Genre]
    let runtimeInMinutes, episodes: Int
    let image: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case title, year, creator, rating, genre
        case runtimeInMinutes = "runtime_in_minutes"
        case episodes, image, id
    }
}

enum Genre: String, Codable {
    case action = "Action"
    case adventure = "Adventure"
    case comedy = "Comedy"
    case drama = "Drama"
    case family = "Family"
    case short = "Short"
}

typealias cartoonList = [Cartoon]
