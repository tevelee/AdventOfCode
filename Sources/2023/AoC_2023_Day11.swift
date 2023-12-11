import Algorithms

final class AoC_2023_Day11 {
    private let map: Map
    private lazy var pairsOfGalaxies = map.positionsOfStars.lazy.combinations(ofCount: 2).map { combination in
        (one: combination[0], two: combination[1])
    }
    private lazy var indicesOfEmptyRows = map.indicesOfEmptyRows
    private lazy var indicesOfEmptyColumns = map.indicesOfEmptyColumns
    private lazy var distancesBetweenGalaxies = pairsOfGalaxies.map { [indicesOfEmptyRows, indicesOfEmptyColumns] one, two in
        let xRange = min(one.x, two.x) ..< max(one.x, two.x)
        let yRange = min(one.y, two.y) ..< max(one.y, two.y)
        return (
            distance: xRange.count + yRange.count,
            emptySpace: indicesOfEmptyColumns.count(where: xRange.contains) + indicesOfEmptyRows.count(where: yRange.contains)
        )
    }
    private lazy var result = distancesBetweenGalaxies.reduce(into: (sumOfDistances: 0, sumOfEmptySpacesBetweenGalaxies: 0)) {
        $0.sumOfDistances += $1.distance
        $0.sumOfEmptySpacesBetweenGalaxies += $1.emptySpace
    }

    init(_ input: Input) throws {
        map = try Map(characters: input.wholeInput.lines.map(Array.init))
    }

    func solve(expansionSize: Int) -> Int {
        let (sumOfDistances, sumOfEmptySpacesBetweenGalaxies) = result
        return sumOfDistances + (expansionSize - 1) * sumOfEmptySpacesBetweenGalaxies
    }
}

private struct Map {
    typealias Coordinate = (x: Int, y: Int)

    let characters: [[Character]]
    let width: Int
    let height: Int

    init(characters: [[Character]]) {
        self.characters = characters
        self.width = characters[0].count
        self.height = characters.count
    }

    subscript(coordinate: Coordinate) -> Character {
        characters[coordinate.y][coordinate.x]
    }


    var positionsOfStars: [Coordinate] {
        coordinates.filter { self[$0] == "#" }
    }

    var indicesOfEmptyRows: [Int] {
        (0..<height).filter { y in
            characters[y].allSatisfy { $0 != "#" }
        }
    }

    var indicesOfEmptyColumns: [Int] {
        (0..<width).filter { x in
            (0..<height).allSatisfy { y in
                characters[y][x] != "#"
            }
        }
    }

    private var coordinates: [Coordinate] {
        (0..<height).flatMap { y in
            (0..<width).map { x in
                (x, y)
            }
        }
    }
}

private extension Range<Int> {
    var count: Int {
        upperBound - lowerBound
    }

    func contains(_ element: Int) -> Bool {
        lowerBound <= element && element < upperBound
    }
}
