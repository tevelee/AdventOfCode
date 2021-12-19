import Accelerate
import Algorithms
import Foundation
import Parsing
import SpriteKit

public final class AoC_2021_Day19 {
    typealias Point = SIMD3<Double>

    private let scanners: [Int: Set<Point>]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        let scannerParser = "--- scanner ".take(Int.parser()).skip(" ---").skip(End())
        let pointParser = Double.parser().skip(",").take(Double.parser()).skip(",").take(Double.parser()).map(Point.init(x:y:z:))
        let raw = input.paragraphs
            .map { lines -> (scanner: Int, beacons: Set<Point>) in
                let headAndTail = lines.headAndTail!
                let scanner = scannerParser.parse(headAndTail.head)!
                let beacons = Set(headAndTail.tail.compactMap(pointParser.parse))
                return (scanner, beacons)
            }
        scanners = Dictionary(grouping: raw, by: \.scanner).compactMapValues { $0.first?.beacons }
        precondition(rotationMatrices.count == 24)
    }

    public func solvePart1() async throws -> Int {
        let scannerPositions = scannerPositionsRelativeToScanner0()
        let beacons = allBeacons(of: scannerPositions)
        return beacons.count
    }

    public func solvePart2() async throws -> Int {
        let scannerPositions = scannerPositionsRelativeToScanner0().map(\.value.coordinate)
        return product(scannerPositions, scannerPositions)
            .map(distance)
            .map(Int.init)
            .max()!
    }

    private struct RelativePosition: Codable {
        let coordinate: Point
        let rotationColumns: [Point]

        var rotation: simd_double3x3 { simd_double3x3(columns: (rotationColumns[0], rotationColumns[1], rotationColumns[2])) }

        init(coordinate: Point, rotation: simd_double3x3) {
            self.coordinate = coordinate
            self.rotationColumns = [rotation.columns.0, rotation.columns.1, rotation.columns.2]
        }
    }

    private func allBeacons(of scannerPositions: [Int: RelativePosition]) -> Set<Point> {
        var beacons: Set<Point> = scanners[0]!
        for (scanner, location) in scannerPositions {
            let pointsWithRelativeCoordinates = scanners[scanner]!
            let pointsWithAbsoluteCoordinates = pointsWithRelativeCoordinates.map { $0 * location.rotation.inverse + location.coordinate }
            for beacon in pointsWithAbsoluteCoordinates {
                beacons.insert(beacon)
            }
        }
        return beacons
    }

    private var _scannerPositions: [Int: RelativePosition]?

    private func scannerPositionsRelativeToScanner0() -> [Int: RelativePosition] {
        if let scannerPositions = _scannerPositions {
            return scannerPositions
        }
        let keys = scanners.keys.sorted()
        let results = keys.flatMap { key1 in
            keys.filter { $0 != 0 && $0 != key1 }.compactMap { key2 in
                relativeLocation(self.scanners[key1]!, self.scanners[key2]!, info: "\(key1)-\(key2)")
                    .map { (key1: key1, key2: key2, relativeLocation: $0) }
            }
        }
        var absolutePositions: [Int: RelativePosition] = [:]
        while absolutePositions.count != scanners.count - 1 {
            for result in results {
                if result.key1 == 0 {
                    if absolutePositions[result.key2] == nil {
                        absolutePositions[result.key2] = result.relativeLocation
                    }
                } else {
                    if absolutePositions[result.key2] == nil, let resultForKey1 = absolutePositions[result.key1] {
                        let coordinate = (resultForKey1.coordinate * resultForKey1.rotation + result.relativeLocation.coordinate) * resultForKey1.rotation.inverse
                        absolutePositions[result.key2] = RelativePosition(coordinate: coordinate, rotation: resultForKey1.rotation * result.relativeLocation.rotation)
                    }
                    //if absolutePositions[result.key1] == nil, let resultForKey2 = absolutePositions[result.key2] {
                    //    let coordinate = (resultForKey2.coordinate * result.relativeLocation.rotation * resultForKey2.rotation.inverse - result.relativeLocation.coordinate) * result.relativeLocation.rotation * resultForKey2.rotation.inverse
                    //    absolutePositions[result.key1] = RelativePosition(coordinate: coordinate, rotation: result.relativeLocation.rotation * resultForKey2.rotation.inverse)
                    //}
                }
            }
        }
        _scannerPositions = absolutePositions
        return absolutePositions
    }

    private func relativeLocation(_ one: Set<Point>, _ two: Set<Point>, info: String) -> RelativePosition? {
        for rotated in possibleRotations(of: two) {
            if let translation = matches(one, rotated.points) {
                print(info)
                return RelativePosition(coordinate: translation, rotation: rotated.rotation)
            }
        }
        return nil
    }

    private func possibleRotations(of points: Set<Point>) -> [(rotation: simd_double3x3, points: Set<Point>)] {
        rotationMatrices.map { rotation in
            (rotation, Set(points.map { rotation * $0 }))
        }
    }

    private func matches(_ one: Set<Point>, _ two: Set<Point>) -> Point? {
        let translations = product(one, two).map { $0 - $1 }
        for translation in translations {
            var count = 0
            for item in two where one.contains(item + translation) {
                count += 1
                if count == 12 {
                    return translation
                }
            }
        }
        return nil
    }

    private lazy var rotationMatrices: [simd_double3x3] = {
        let angles = Array(stride(from: 0, to: 360, by: 90))
        return product3(angles).map(rotationMatrix).removingDuplicates()
    }()

    private func product3<C: Collection>(_ c: C) -> [SIMD3<C.Element>] {
        product(product(c, c), c).map { p, z -> SIMD3<C.Element> in
            let (x,y) = p
            return SIMD3(x: x, y: y, z: z)
        }
    }

    private func rotationMatrix(_ v: SIMD3<Int>) -> simd_double3x3 {
        double3x3(rows: [
            simd_double3(cos(v.x) * cos(v.y),
                         -cos(v.x) * sin(v.y) * cos(v.z) + sin(v.x) * sin(v.z),
                         cos(v.x) * sin(v.y) * sin(v.z) + sin(v.x) * cos(v.z)),
            simd_double3(sin(v.y),
                         cos(v.y) * cos(v.z),
                         -cos(v.y) * sin(v.z)),
            simd_double3(-sin(v.x) * cos(v.y),
                          sin(v.x) * sin(v.y) * cos(v.z) + cos(v.x) * sin(v.z),
                          -sin(v.x) * sin(v.y) * sin(v.z) + cos(v.x) * cos(v.z))
        ])
    }

    private func cos(_ value: Int) -> Double {
        switch value {
            case 0: return 1
            case 90, 270: return 0
            case 180: return -1
            default: fatalError("Shouldn't reach")
        }
    }

    private func sin(_ value: Int) -> Double {
        switch value {
            case 0, 180: return 0
            case 90: return 1
            case 270: return -1
            default: fatalError("Shouldn't reach")
        }
    }

    private func distance(from one: Point, to two: Point) -> Double {
        abs(two.x - one.x) + abs(two.y - one.y) + abs(two.z - one.z)
    }
}

extension simd_double3x3: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(columns.0)
        hasher.combine(columns.1)
        hasher.combine(columns.2)
    }
}
