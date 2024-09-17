import Testing
import Utils

struct SearchStrategy {
    let edges = """
        Root -> A, B, C
        B -> X, Y, Z
        Y -> N, M
    """.parseEdges()

    @Test func bfs() {
        let search = Search {
            BFS()
        } traversal: {
            Traversal(start: "Root") { edges[$0] ?? [] }
        }

        #expect(Array(search) == ["Root", "A", "B", "C", "X", "Y", "Z", "N", "M"])
    }

    @Test func dfs_preorder() {
        let search = Search {
            DFS(order: .preorder)
        } traversal: {
            Traversal(start: "Root") { edges[$0] ?? [] }
        }

        #expect(Array(search) == ["Root", "A", "B", "X", "Y", "N", "M", "Z", "C"])
    }

    @Test func dfs_postorder() {
        let search = Search {
            DFS(order: .postorder)
        } traversal: {
            Traversal(start: "Root") { edges[$0] ?? [] }
        }

        #expect(Array(search) == ["A", "X", "N", "M", "Y", "Z", "B", "C", "Root"])
    }
}

private extension String {
    func parseEdges() -> [String: [String]] {
        components(separatedBy: "\n")
            .map {
                $0.components(separatedBy: "->")
            }
            .flatMap { components in
                components[1].components(separatedBy: ",")
                    .map {
                        $0.trimmingCharacters(in: .whitespaces)
                    }
                    .map {
                        (source: components[0].trimmingCharacters(in: .whitespaces), destination: $0)
                    }
            }
            .grouped(by: \.source)
            .mapValues {
                $0.map(\.destination)
            }
    }
}
