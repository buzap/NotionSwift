//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation
//
//public struct DatabaseFilter {
//    let array: [DatabaseFilterType]
//}
//
//extension DatabaseFilter {
//    public static func property(name: String, type: DatabasePropertyFilter.PropertyType) -> DatabaseFilter {
//        DatabaseFilter(array: [.databaseProperty(.init(property: name, filterType: type))])
//    }
//
//    public static func or(_ filters: [DatabaseFilter]) -> DatabaseFilter {
//        let flatFilters: [DatabaseFilterType] = filters.map(\.array).flatMap({ $0 })
//        let array: [DatabaseFilterType] = [
//            .compound(.or(flatFilters))
//        ]
//
//        return .init(array: array)
//    }
//
//    public static func and(_ filters: [DatabaseFilter]) -> DatabaseFilter {
//        let flatFilters: [DatabaseFilterType] = filters.map(\.array).flatMap({ $0 })
//        let array: [DatabaseFilterType] = [
//            .compound(.and(flatFilters))
//        ]
//
//        return .init(array: array)
//    }
//}
//
//// MARK: - Codable
//
//extension DatabaseFilter: Codable {
//    enum CodingKeys: String, CodingKey {
//        case property
//        case and
//        case or
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if values.contains(.property) {
//            let filter = try DatabaseFilterT
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        for element in array {
//            try element.encode(to: encoder)
//        }
//    }
//}
