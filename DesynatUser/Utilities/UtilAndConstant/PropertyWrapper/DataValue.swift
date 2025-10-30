import Foundation

/// A protocol for providing a custom strategy for encoding and decoding data as strings.
///
/// `DataValueCodableStrategy` provides a generic strategy type that the `DataValue` property wrapper can use to inject
///  custom strategies for encoding and decoding data values.
///
public protocol DataValueCodableStrategy {
    associatedtype DataType: MutableDataProtocol
    static func decode(_ value: String) throws -> DataType
    static func encode(_ data: DataType) -> String
}

/// Decodes and encodes data using a strategy type.
///
/// `@DataValue` decodes data using a `DataValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct DataValue<Coder: DataValueCodableStrategy> {
    public var wrappedValue: Coder.DataType

    public init(wrappedValue: Coder.DataType) {
        self.wrappedValue = wrappedValue
    }
}

extension DataValue: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try Coder.decode(String(from: decoder))
    }
}

extension DataValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        try Coder.encode(wrappedValue).encode(to: encoder)
    }
}

extension DataValue: Equatable where Coder.DataType: Equatable {}
extension DataValue: Hashable where Coder.DataType: Hashable {}

//@propertyWrapper struct Flexible<T: FlexibleDecodable>: Decodable {
//    var wrappedValue: T
//    
//    init(from decoder: Decoder) throws {
//        wrappedValue = try T(container: decoder.singleValueContainer())
//    }
//}

@propertyWrapper struct Flexible<T: FlexibleDecodable>: Decodable {
    var wrappedValue: T
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try T(container: container)
    }
    
    init(from decoder: Decoder, default value: T) throws {
        if let container = try? decoder.singleValueContainer() {
            wrappedValue = (try? T(container: container)) ?? value
        } else {
            wrappedValue = value
        }
    }
}


protocol FlexibleDecodable {
    init(container: SingleValueDecodingContainer) throws
}

extension String: FlexibleDecodable {
    init(container: SingleValueDecodingContainer) throws {
        if let string = try? container.decode(String.self) {
            self = string
        }
        else if let int = try? container.decode(Int.self) {
            self = String(int)
        }
        else if let double = try? container.decode(Double.self){
           self = String(format: "%.2f", double)
        }
        else if container.decodeNil() {
            self = "" // Handle null values by setting the string to an empty string
        }
        else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Invalid int value"))
        }
    }
}

@propertyWrapper struct FlexibleInt<T: FlexibleIntDecodable>: Decodable {
    var wrappedValue: T
    
    init(from decoder: Decoder) throws {
        wrappedValue = try T(container: decoder.singleValueContainer())
    }
}

protocol FlexibleIntDecodable {
    init(container: SingleValueDecodingContainer) throws
}

extension Int: FlexibleIntDecodable {
    init(container: SingleValueDecodingContainer) throws {
        if let int = try? container.decode(Int.self) {
            self = int
        } 
        else if let string = try? container.decode(String.self), let int = Int(string) {
            self = int
        }
        else if let float = try? container.decode(Float.self){
           self = Int(float)
        }
        else if container.decodeNil() {
           self = 0 // Handle null values by setting the string to an empty string
        }
        
        else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Invalid int value"))
        }
    }
}



