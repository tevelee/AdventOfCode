import Algorithms
import GameplayKit

public final class AoC_2021_Day15: GraphDelegate {
    private let data: [[Int]]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        data = contents.lines.map { line in
            line.compactMap(\.wholeNumberValue)
        }
    }

    public func solvePart1() -> Int {
        findShortestPathInGraph()
    }

    public func solvePart2() -> Int {
        findShortestPathInGraph(dimensions: 5)
    }

    private func findShortestPathInGraph(dimensions: Int = 1) -> Int {
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(x: 0, y: 0),
                                width: Int32(data.count * dimensions),
                                height: Int32(data.count * dimensions),
                                diagonalsAllowed: false,
                                nodeClass: Node.self)
        graph.nodes?.compactMap { $0 as? Node }.forEach { [weak self] in $0.delegate = self }
        let path = graph.findPath(from: graph.nodes!.first!, to: graph.nodes!.last!)
        return path
            .lazy
            .dropFirst()
            .compactMap { $0 as? GKGridGraphNode }
            .map(\.gridPosition)
            .sum(of: cost)
    }

    func cost(to node: vector_int2) -> Int {
        let x = Int(node.x)
        let y = Int(node.y)
        let maxX = data[0].count
        let maxY = data.count
        if x < maxX, y < maxY {
            return data[y][x]
        }
        var value = data[y % maxY][x % maxX] + Int(Double(x) / Double(maxX)) + Int(Double(y) / Double(maxY))
        while value > 9 { value -= 9 }
        return value
    }
}

protocol GraphDelegate: AnyObject {
    func cost(to node: vector_int2) -> Int
}

private class Node: GKGridGraphNode {
    weak var delegate: GraphDelegate?

    override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func cost(to node: GKGraphNode) -> Float {
        guard let gridNode = node as? GKGridGraphNode, let cost = delegate?.cost(to: gridNode.gridPosition) else { return 0 }
        return Float(cost)
    }
}
