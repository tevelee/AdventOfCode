import Utils

public final class AoC_2025_Day4 {
    private let positions: Set<Position>
    private lazy var neighborMap: [Position: Set<Position>] = Dictionary(uniqueKeysWithValues: positions.map {
        (key: $0, value: neighbors(of: $0))
    })
    private let threshold = 4

    public init(_ input: Input) throws {
        positions = Set(try input.wholeInput.lines.enumerated().flatMap { y, line in
            line.enumerated().compactMap { x, character -> Position? in
                guard character == "@" else { return nil }
                return Position(x: x, y: y)
            }
        })
    }

    public func solvePart1() -> Int {
        neighborMap.count {
            $0.value.count < threshold
        }
    }

    public func solvePart2() -> Int {
        var neighborMap = neighborMap
        while true {
            let positionsToRemove = neighborMap.filter {
                $0.value.count < threshold
            }
            if positionsToRemove.isEmpty {
                break
            }
            for (positionBeingRemoved, neighborsOfPositionBeingRemoved) in positionsToRemove {
                neighborMap.removeValue(forKey: positionBeingRemoved)
                for neighbor in neighborsOfPositionBeingRemoved {
                    neighborMap[neighbor]?.remove(positionBeingRemoved)
                }
            }
        }
        return positions.count - neighborMap.count
    }
    
    private func neighbors(of position: Position) -> Set<Position> {
        Set(
            (-1 ... 1).flatMap { dy in
                (-1 ... 1).map { dx in
                    Position(x: position.x + dx, y: position.y + dy)
                }
            }
        )
        .subtracting([position])
        .intersection(positions)
    }
}

private struct Position: Hashable {
    let x: Int
    let y: Int
}
