//
//  Day12.swift
//  AdventOfCode
//

import Foundation

private final class Graph {
    private class Node: Hashable, CustomStringConvertible {
        let value: String

        init(value: String) {
            self.value = value
            self.isStart = value == "start"
            self.isEnd = value == "end"
            self.isSmall = !isStart && !isEnd && value.allSatisfy(\.isLowercase)
            self.isBig = value.allSatisfy(\.isUppercase)
        }

        let isStart: Bool
        let isEnd: Bool
        let isSmall: Bool
        let isBig: Bool

        var description: String {
            value
        }

        static func ==(lhs: Node, rhs: Node) -> Bool {
            lhs.value == rhs.value
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }

    private let nodes: Set<Node>
    private let connections: [Node: [Node]]

    init(string: String) {
        var nodes: Set<Node> = []
        var connections: [Node: [Node]] = [:]
        string.components(separatedBy: .newlines).forEach { line in
            let parts = line.components(separatedBy: "-")
            let l = Node(value: parts[0])
            let r = Node(value: parts[1])

            nodes.formUnion([l, r])
            connections[l, default: []].append(r)
            connections[r, default: []].append(l)
        }
        self.nodes = nodes
        self.connections = connections
    }

    func pathCount(oneSmallDoubleAllowed: Bool) -> Int {
        guard let startNode = nodes.first(where: { $0.isStart }) else { return 0 }
        return paths(current: [startNode], oneSmallDoubleAllowed: oneSmallDoubleAllowed)
            .filter { $0.contains(where: \.isEnd) }
            .count
    }

    private func paths(current: [Node], oneSmallDoubleAllowed: Bool) -> [[Node]] {
        guard let currentNode = current.last else { return [] }

        if currentNode.isEnd { return [current] }

        var added: [Node] = []
        let visitableNodes = connections[currentNode] ?? []

        lazy var hasNoDoubles: Bool = {
            var storage: [Node: Int] = [:]
            for node in current {
                if storage[node] != nil {
                    return false
                }
                storage[node] = 1
            }
            return true
        }()

        let canAddSmall: (Node) -> Bool = { node in
            if !current.contains(node) {
                return true
            } else if oneSmallDoubleAllowed {
                return hasNoDoubles
            } else {
                return false
            }
        }

        for targetNode in visitableNodes {
            if targetNode.isEnd {
                added.append(targetNode)
            } else if targetNode.isBig {
                added.append(targetNode)
            } else if targetNode.isSmall, canAddSmall(targetNode) {
                added.append(targetNode)
            } else {
                continue
            }
        }

        if added.isEmpty { return [current] }

        return added.flatMap {
            self.paths(current: current + [$0], oneSmallDoubleAllowed: oneSmallDoubleAllowed)
        }
    }
}

final class Day12: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        Graph(string: input)
            .pathCount(oneSmallDoubleAllowed: false)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        Graph(string: input)
            .pathCount(oneSmallDoubleAllowed: true)
    }
}

