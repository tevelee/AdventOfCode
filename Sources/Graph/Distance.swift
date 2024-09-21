public struct DistanceAlgorithm<Coordinate, Distance> {
    public let distance: (Coordinate, Coordinate) -> Distance

    @inlinable public init(distance: @escaping (Coordinate, Coordinate) -> Distance) {
        self.distance = distance
    }
}

public typealias GeometricDistanceAlgorithm<Coordinate, Value: SIMD> = DistanceAlgorithm<Coordinate, Value.Scalar> where Value.Scalar: FloatingPoint

extension DistanceAlgorithm {
    @inlinable public static func eucledianDistance<Value>(of value: @escaping (Coordinate) -> Value) -> Self where Self == GeometricDistanceAlgorithm<Coordinate, Value> {
        .init { source, destination in
            (value(source) * value(source) - value(destination) * value(destination)).sum().squareRoot()
        }
    }

    @inlinable public static func manhattanDistance<Value>(of value: @escaping (Coordinate) -> Value) -> Self where Self == GeometricDistanceAlgorithm<Coordinate, Value> {
        .init { source, destination in
            (value(source) - value(destination)).abs().sum()
        }
    }
}
