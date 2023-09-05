//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

public enum CompountFilterType {
    case or([DatabaseFilter])
    case and([DatabaseFilter])
}

// MARK: - Codable

extension CompountFilterType: Codable {
    enum CodingKeys: String, CodingKey {
        case and
        case or
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try values.decodeIfPresent([DatabaseFilter].self, forKey: .and) {
            self = .and(value)
            return
        }
        if let value = try values.decodeIfPresent([DatabaseFilter].self, forKey: .or) {
            self = .or(value)
            return
        }
        
        throw DecodingError.valueNotFound(
            Self.self,
            .init(codingPath: decoder.codingPath, debugDescription: "no known coding key found, allKeys: \(values.allKeys)")
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .and(let value):
            try container.encode(value, forKey: .and)
        case .or(let value):
            try container.encode(value, forKey: .or)
        }
    }
}

extension CompountFilterType: Equatable {}
