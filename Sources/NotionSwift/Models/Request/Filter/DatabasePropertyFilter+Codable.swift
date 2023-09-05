//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

extension DatabasePropertyFilter: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case richText = "rich_text"
        case url
        case email
        case phoneNumber = "phone_number"
        case number
        case checkbox
        case select
        case multiSelect = "multi_select"
        case date
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
        case files
        case relation
        case formula
        case property
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.property = try values.decode(String.self, forKey: .property)
        
        if let value = try values.decodeIfPresent(TextCondition.self, forKey: .title) {
            self.filterType = .title(value)
            return
        }
        if let value = try values.decodeIfPresent(TextCondition.self, forKey: .richText) {
            self.filterType = .richText(value)
            return
        }
        if let value = try values.decodeIfPresent(TextCondition.self, forKey: .url) {
            self.filterType = .url(value)
            return
        }
        if let value = try values.decodeIfPresent(TextCondition.self, forKey: .email) {
            self.filterType = .email(value)
            return
        }
        if let value = try values.decodeIfPresent(TextCondition.self, forKey: .phoneNumber) {
            self.filterType = .phoneNumber(value)
            return
        }
        if let value = try values.decodeIfPresent(NumberCondition.self, forKey: .number) {
            self.filterType = .number(value)
            return
        }
        if let value = try values.decodeIfPresent(CheckboxCondition.self, forKey: .checkbox) {
            self.filterType = .checkbox(value)
            return
        }
        if let value = try values.decodeIfPresent(SimpleGenericCondition<String>.self, forKey: .select) {
            self.filterType = .select(value)
            return
        }
        if let value = try values.decodeIfPresent(SimpleGenericCondition<String>.self, forKey: .multiSelect) {
            self.filterType = .multiSelect(value)
            return
        }
        if let value = try values.decodeIfPresent(DateCondition.self, forKey: .date) {
            self.filterType = .date(value)
            return
        }
        if let value = try values.decodeIfPresent(DateCondition.self, forKey: .createdTime) {
            self.filterType = .createdTime(value)
            return
        }
        if let value = try values.decodeIfPresent(DateCondition.self, forKey: .lastEditedTime) {
            self.filterType = .lastEditedTime(value)
            return
        }
        if let value = try values.decodeIfPresent(SimpleGenericCondition<UUIDv4>.self, forKey: .createdBy) {
            self.filterType = .createdBy(value)
            return
        }
        if let value = try values.decodeIfPresent(SimpleGenericCondition<UUIDv4>.self, forKey: .lastEditedBy) {
            self.filterType = .lastEditedBy(value)
            return
        }
        if let value = try values.decodeIfPresent(FilesCondition.self, forKey: .files) {
            self.filterType = .files(value)
            return
        }
        if let value = try values.decodeIfPresent(SimpleGenericCondition<UUIDv4>.self, forKey: .relation) {
            self.filterType = .relation(value)
            return
        }
        if let value = try values.decodeIfPresent(FormulaCondition.self, forKey: .formula) {
            self.filterType = .formula(value)
            return
        }
        
        throw DecodingError.valueNotFound(
            Self.self,
            .init(codingPath: decoder.codingPath, debugDescription: "no known coding key found, allKeys: \(values.allKeys)")
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(property, forKey: .property)

        switch filterType {
        case .title(let contition):
            try container.encode(contition, forKey: .title)
        case .richText(let contition):
            try container.encode(contition, forKey: .richText)
        case .url(let contition):
            try container.encode(contition, forKey: .url)
        case .email(let contition):
            try container.encode(contition, forKey: .email)
        case .phoneNumber(let contition):
            try container.encode(contition, forKey: .phoneNumber)
        case .number(let contition):
            try container.encode(contition, forKey: .number)
        case .checkbox(let contition):
            try container.encode(contition, forKey: .checkbox)
        case .select(let contition):
            try container.encode(contition, forKey: .select)
        case .multiSelect(let contition):
            try container.encode(contition, forKey: .multiSelect)
        case .date(let contition):
            try container.encode(contition, forKey: .date)
        case .createdTime(let contition):
            try container.encode(contition, forKey: .createdTime)
        case .lastEditedTime(let contition):
            try container.encode(contition, forKey: .lastEditedTime)
        case .dateBy(let contition):
            try container.encode(contition, forKey: .date) // date by is operating also on .date !!!
        case .createdBy(let contition):
            try container.encode(contition, forKey: .createdBy)
        case .lastEditedBy(let contition):
            try container.encode(contition, forKey: .lastEditedBy)
        case .files(let contition):
            try container.encode(contition, forKey: .files)
        case .relation(let contition):
            try container.encode(contition, forKey: .relation)
        case .formula(let contition):
            try container.encode(contition, forKey: .formula)
        }
    }
}

extension DatabasePropertyFilter.CheckboxCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case equals
        case doesNotEqual = "does_not_equal"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try values.decodeIfPresent(Bool.self, forKey: .equals) {
            self = .equals(value)
            return
        }
        if let value = try values.decodeIfPresent(Bool.self, forKey: .doesNotEqual) {
            self = .doesNotEqual(value)
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
        case .equals(let value):
            try container.encode(value, forKey: .equals)
        case .doesNotEqual(let value):
            try container.encode(value, forKey: .doesNotEqual)
        }
    }
}

extension DatabasePropertyFilter.DateCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case equals
        case before
        case after
        case onOrBefore = "on_or_before"
        case isEmpty = "is_empty"
        case isNotEmpty = "is_not_empty"
        case onOrAfter = "on_or_after"
        case pastWeek = "past_week"
        case pastMonth = "past_month"
        case pastYear = "past_year"
        case thisWeek = "this_week"
        case nextWeek = "next_week"
        case nextMonth = "next_month"
        case nextYear = "next_year"
    }

    private struct Empty: Codable {}
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try values.decodeIfPresent(Date.self, forKey: .equals) {
            self = .equals(value)
            return
        }
        if let value = try values.decodeIfPresent(Date.self, forKey: .before) {
            self = .before(value)
            return
        }
        if let value = try values.decodeIfPresent(Date.self, forKey: .after) {
            self = .after(value)
            return
        }
        if let value = try values.decodeIfPresent(Date.self, forKey: .onOrBefore) {
            self = .onOrBefore(value)
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isEmpty)) != nil {
            self = .isEmpty
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isNotEmpty)) != nil {
            self = .isNotEmpty
            return
        }
        if let value = try values.decodeIfPresent(Date.self, forKey: .onOrAfter) {
            self = .onOrAfter(value)
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .pastWeek)) != nil {
            self = .pastWeek
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .pastMonth)) != nil {
            self = .pastMonth
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .pastYear)) != nil {
            self = .pastYear
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .thisWeek)) != nil {
            self = .thisWeek
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .nextWeek)) != nil {
            self = .nextWeek
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .nextMonth)) != nil {
            self = .nextMonth
            return
        }
        if (try values.decodeIfPresent(Empty.self, forKey: .nextYear)) != nil {
            self = .nextYear
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
        case .equals(let value):
            try container.encode(value, forKey: .equals)
        case .before(let value):
            try container.encode(value, forKey: .before)
        case .after(let value):
            try container.encode(value, forKey: .after)
        case .onOrBefore(let value):
            try container.encode(value, forKey: .onOrBefore)
        case .isEmpty:
            try container.encode(true, forKey: .isEmpty)
        case .isNotEmpty:
            try container.encode(true, forKey: .isNotEmpty)
        case .onOrAfter(let value):
            try container.encode(value, forKey: .onOrAfter)
        case .pastWeek:
            try container.encode(Empty(), forKey: .pastWeek)
        case .pastMonth:
            try container.encode(Empty(), forKey: .pastMonth)
        case .pastYear:
            try container.encode(Empty(), forKey: .pastYear)
        case .thisWeek:
            try container.encode(Empty(), forKey: .thisWeek)
        case .nextWeek:
            try container.encode(Empty(), forKey: .nextWeek)
        case .nextMonth:
            try container.encode(Empty(), forKey: .nextMonth)
        case .nextYear:
            try container.encode(Empty(), forKey: .nextYear)
        }
    }
}

extension DatabasePropertyFilter.FormulaCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case string
        case checkbox
        case number
        case date
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try values.decodeIfPresent(DatabasePropertyFilter.TextCondition.self, forKey: .string) {
            self = .string(value)
            return
        }
        if let value = try values.decodeIfPresent(DatabasePropertyFilter.CheckboxCondition.self, forKey: .checkbox) {
            self = .checkbox(value)
            return
        }
        if let value = try values.decodeIfPresent(DatabasePropertyFilter.NumberCondition.self, forKey: .number) {
            self = .number(value)
            return
        }
        if let value = try values.decodeIfPresent(DatabasePropertyFilter.DateCondition.self, forKey: .date) {
            self = .date(value)
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
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .checkbox(let value):
            try container.encode(value, forKey: .checkbox)
        case .number(let value):
            try container.encode(value, forKey: .number)
        case .date(let value):
            try container.encode(value, forKey: .date)
        }
    }
}

extension DatabasePropertyFilter.FilesCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case isEmpty = "is_empty"
        case isNotEmpty = "is_not_empty"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if (try values.decodeIfPresent(Bool.self, forKey: .isEmpty)) != nil {
            self = .isEmpty
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isNotEmpty)) != nil {
            self = .isNotEmpty
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
        case .isEmpty:
            try container.encode(true, forKey: .isEmpty)
        case .isNotEmpty:
            try container.encode(true, forKey: .isNotEmpty)
        }
    }
}

extension DatabasePropertyFilter.NumberCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case equals
        case doesNotEqual = "does_not_equal"
        case greaterThan = "greater_than"
        case lessThan = "less_than"
        case greaterThanOrEqualTo = "greater_than_or_equal_to"
        case lessThanOrEqualTo = "less_than_or_equal_to"
        case isEmpty = "is_empty"
        case isNotEmpty = "is_not_empty"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try values.decodeIfPresent(Double.self, forKey: .equals) {
            self = .equals(value)
            return
        }
        if let value = try values.decodeIfPresent(Double.self, forKey: .doesNotEqual) {
            self = .doesNotEqual(value)
            return
        }
        if let value = try values.decodeIfPresent(Double.self, forKey: .greaterThan) {
            self = .greaterThan(value)
            return
        }
        if let value = try values.decodeIfPresent(Double.self, forKey: .lessThan) {
            self = .lessThan(value)
            return
        }
        if let value = try values.decodeIfPresent(Double.self, forKey: .greaterThanOrEqualTo) {
            self = .greaterThanOrEqualTo(value)
            return
        }
        if let value = try values.decodeIfPresent(Double.self, forKey: .lessThanOrEqualTo) {
            self = .lessThanOrEqualTo(value)
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isEmpty)) != nil {
            self = .isEmpty
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isNotEmpty)) != nil {
            self = .isNotEmpty
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
        case .equals(let number):
            try container.encode(number, forKey: .equals)
        case .doesNotEqual(let number):
            try container.encode(number, forKey: .doesNotEqual)
        case .greaterThan(let number):
            try container.encode(number, forKey: .greaterThan)
        case .lessThan(let number):
            try container.encode(number, forKey: .lessThan)
        case .greaterThanOrEqualTo(let number):
            try container.encode(number, forKey: .greaterThanOrEqualTo)
        case .lessThanOrEqualTo(let number):
            try container.encode(number, forKey: .lessThanOrEqualTo)
        case .isEmpty:
            try container.encode(true, forKey: .isEmpty)
        case .isNotEmpty:
            try container.encode(true, forKey: .isNotEmpty)
        }
    }
}

extension DatabasePropertyFilter.SimpleGenericCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case contains
        case doesNotContain = "does_not_contain"
        case isEmpty = "is_empty"
        case isNotEmpty = "is_not_empty"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try values.decodeIfPresent(Self.Value.self, forKey: .contains) {
            self = .contains(value)
            return
        }
        if let value = try values.decodeIfPresent(Value.self, forKey: .doesNotContain) {
            self = .doesNotContain(value)
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isEmpty)) != nil {
            self = .isEmpty
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isNotEmpty)) != nil {
            self = .isNotEmpty
        }
        
        throw DecodingError.valueNotFound(
            Self.self,
            .init(codingPath: decoder.codingPath, debugDescription: "no known coding key found, allKeys: \(values.allKeys)")
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .contains(let value):
            try container.encode(value, forKey: .contains)
        case .doesNotContain(let value):
            try container.encode(value, forKey: .doesNotContain)
        case .isEmpty:
            try container.encode(true, forKey: .isEmpty)
        case .isNotEmpty:
            try container.encode(true, forKey: .isNotEmpty)
        }
    }
}

extension DatabasePropertyFilter.TextCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case equals
        case doesNotEqual = "does_not_equal"
        case contains
        case doesNotContain = "does_not_contain"
        case startsWith = "starts_with"
        case endsWith = "ends_with"
        case isEmpty = "is_empty"
        case isNotEmpty = "is_not_empty"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try values.decodeIfPresent(String.self, forKey: .equals) {
            self = .equals(value)
            return
        }
        if let value = try values.decodeIfPresent(String.self, forKey: .doesNotEqual) {
            self = .doesNotEqual(value)
            return
        }
        if let value = try values.decodeIfPresent(String.self, forKey: .contains) {
            self = .contains(value)
            return
        }
        if let value = try values.decodeIfPresent(String.self, forKey: .doesNotContain) {
            self = .doesNotContain(value)
            return
        }
        if let value = try values.decodeIfPresent(String.self, forKey: .startsWith) {
            self = .startsWith(value)
            return
        }
        if let value = try values.decodeIfPresent(String.self, forKey: .endsWith) {
            self = .endsWith(value)
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isEmpty)) != nil {
            self = .isEmpty
            return
        }
        if (try values.decodeIfPresent(Bool.self, forKey: .isNotEmpty)) != nil {
            self = .isNotEmpty
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
        case .equals(let value):
            try container.encode(value, forKey: .equals)
        case .doesNotEqual(let value):
            try container.encode(value, forKey: .doesNotEqual)
        case .contains(let value):
            try container.encode(value, forKey: .contains)
        case .doesNotContain(let value):
            try container.encode(value, forKey: .doesNotContain)
        case .startsWith(let value):
            try container.encode(value, forKey: .startsWith)
        case .endsWith(let value):
            try container.encode(value, forKey: .endsWith)
        case .isEmpty:
            try container.encode(true, forKey: .isEmpty)
        case .isNotEmpty:
            try container.encode(true, forKey: .isNotEmpty)
        }
    }
}
