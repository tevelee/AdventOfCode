import Algorithms

final class AoC_2023_Day16 {
    private let mirrors: [[Character]]

    init(_ input: Input) throws {
        mirrors = try input.wholeInput.lines.map(Array.init)
    }

    func solvePart1() -> Int {
        numberOfEnergizedFields(from: Laser(position: Position(x: 0, y: 0), direction: .right))
    }

    func solvePart2() -> Int {
        let firstRow = mirrors[0].indices.map { x in
            Laser(position: Position(x: x, y: 0), direction: .down)
        }
        let lastRow = mirrors.last!.indices.map { x in
            Laser(position: Position(x: x, y: mirrors.count - 1), direction: .up)
        }
        let firstColumn = mirrors.indices.map { y in
            Laser(position: Position(x: 0, y: y), direction: .right)
        }
        let lastColumn = mirrors.indices.map { y in
            Laser(position: Position(x: mirrors[0].count - 1, y: y), direction: .left)
        }
        let lasers = firstRow + lastRow + firstColumn + lastColumn
        return lasers.max(of: numberOfEnergizedFields) ?? 0
    }

    private func numberOfEnergizedFields(from laser: Laser) -> Int {
        var visited: Set<Laser> = []
        shoot(laser: laser, visited: &visited)
        return Set(visited.map(\.position)).count
    }

    private func shoot(laser: Laser, visited: inout Set<Laser>) {
        visited.insert(laser)
        var laser = laser
        while true {
            laser.move()
            guard isValid(position: laser.position), !visited.contains(laser) else {
                return
            }
            visited.insert(laser)
            let mirror = mirrors[laser.position.y][laser.position.x]
            switch mirror {
            case "|" where laser.direction == .left || laser.direction == .right:
                shoot(laser: laser.with(direction: .up), visited: &visited)
                shoot(laser: laser.with(direction: .down), visited: &visited)
                return
            case "-" where laser.direction == .up || laser.direction == .down:
                shoot(laser: laser.with(direction: .left), visited: &visited)
                shoot(laser: laser.with(direction: .right), visited: &visited)
                return
            case "/":
                laser.direction = switch laser.direction {
                case .up: .right
                case .right: .up
                case .down: .left
                case .left: .down
                }
            case #"\"#:
                laser.direction = switch laser.direction {
                case .up: .left
                case .left: .up
                case .down: .right
                case .right: .down
                }
            default:
                break
            }
        }
    }

    private func isValid(position: Position) -> Bool {
        mirrors.indices.contains(position.y) && mirrors[position.y].indices.contains(position.x)
    }
}

private struct Laser: Hashable {
    var position: Position
    var direction: Direction

    mutating func move() {
        switch direction {
        case .up: position.y -= 1
        case .left: position.x -= 1
        case .down: position.y += 1
        case .right: position.x += 1
        }
    }

    func with(direction: Direction) -> Laser {
        Laser(position: position, direction: direction)
    }
}

private struct Position: Hashable {
    var x, y: Int
}

private enum Direction: CaseIterable {
    case up, left, down, right
}
