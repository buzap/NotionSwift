//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

public enum DatabaseFilter {
    case databaseProperty(DatabasePropertyFilter)
    case compound(CompountFilterType)
}

extension DatabaseFilter {
    public static func property(name: String, type: DatabasePropertyFilter.PropertyType) -> DatabaseFilter {
        .databaseProperty(.init(property: name, filterType: type))
    }

    public static func or(_ filters: [DatabaseFilter]) -> DatabaseFilter {
        .compound(.or(filters))
    }

    public static func and(_ filters: [DatabaseFilter]) -> DatabaseFilter {
        .compound(.and(filters))
    }
}


extension DatabaseFilter: Codable {
    enum CodingKeys: String, CodingKey {
        case property
        case and
        case or
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.property) {
            self = .databaseProperty(try .init(from: decoder))
            return
        }
        self = .compound(try .init(from: decoder))
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .databaseProperty(let value):
            try value.encode(to: encoder)
        case .compound(let value):
            try value.encode(to: encoder)
        }
    }
}

extension DatabaseFilter: Equatable {}
