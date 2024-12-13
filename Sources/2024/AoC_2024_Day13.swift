import Utils

public final class AoC_2024_Day13 {
    private let machines: [ClawMachine]

    public init(_ input: Input) throws {
        machines = try input.wholeInput.paragraphs.map { string in
            let regex = #/
            Button\ A:\ X\+(?<ax>\d+),\ Y\+(?<ay>\d+)\n
            Button\ B:\ X\+(?<bx>\d+),\ Y\+(?<by>\d+)\n
            Prize:\ X=(?<px>\d+),\ Y=(?<py>\d+)
            /#
            let match = try regex.wholeMatch(in: string.joined(separator: "\n"))
            guard let match,
                let ax = Int(match.ax), let ay = Int(match.ay),
                let bx = Int(match.bx), let by = Int(match.by),
                let px = Int(match.px), let py = Int(match.py) else { throw ParseError() }
            return ClawMachine(
                buttonA: Position(x: ax, y: ay),
                buttonB: Position(x: bx, y: by),
                prize: Position(x: px, y: py)
            )
        }
    }

    public func solvePart1() -> Int {
        machines.sum {
            $0.tokensToSolve ?? 0
        }
    }

    public func solvePart2() -> Int {
        machines.sum {
            $0.increasedPrize.tokensToSolve ?? 0
        }
    }
}

private struct ClawMachine {
    let buttonA: Position
    let buttonB: Position
    let prize: Position

    var tokensToSolve: Int? {
        // prize.x = a * buttonA.x + b * buttonB.x
        // prize.y = a * buttonA.y + b * buttonB.y
        // a = (prize.y - b * buttonA.y) / buttonB.y
        // b = (prize.y - a * buttonB.y) / buttonA.y
        let a = (prize.x * buttonB.y - prize.y * buttonB.x) / (buttonA.x * buttonB.y - buttonA.y * buttonB.x)
        let b = (prize.x * buttonA.y - prize.y * buttonA.x) / (buttonB.x * buttonA.y - buttonB.y * buttonA.x)
        if prize == a * buttonA + b * buttonB {
            return 3 * a + b
        } else {
            return nil
        }
    }

    var increasedPrize: Self {
        let diff = 10_000_000_000_000
        return ClawMachine(
            buttonA: buttonA,
            buttonB: buttonB,
            prize: prize + Position(x: diff, y: diff)
        )
    }
}

private struct Position: Equatable {
    let x, y: Int
}

private func + (lhs: Position, rhs: Position) -> Position {
    Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

private func * (lhs: Int, rhs: Position) -> Position {
    Position(x: lhs * rhs.x, y: lhs * rhs.y)
}
