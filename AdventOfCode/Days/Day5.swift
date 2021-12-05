//
//  Day5.swift
//  AdventOfCode
//

import Foundation

private struct Line {
    struct Point: Equatable, Hashable {
        let x: Int
        let y: Int
    }

    private let p1: Point
    private let p2: Point

    init?(string: String) {
        let parts = string
            .components(separatedBy: " -> ")
            .map { $0.components(separatedBy: ",").compactMap(Int.init) }

        guard parts.count == 2, parts.allSatisfy({ $0.count == 2 }) else { return nil }

        p1 = Point(x: parts[0][0], y: parts[0][1])
        p2 = Point(x: parts[1][0], y: parts[1][1])
    }

    var isHorizontalOrVertical: Bool {
        p1.x == p2.x || p1.y == p2.y
    }

    private var slope: Double {
        Double(p2.y - p1.y) / Double(p2.x - p1.x)
    }

    var points: [Point] {
        // Assuming horizontal or verical now:
        if p1.x == p2.x {
            // Vertical
            let lower = min(p1.y, p2.y)
            let upper = max(p1.y, p2.y)
            return Array(lower...upper).map { Point(x: p1.x, y: $0) }
        } else if p1.y == p2.y {
            // Horizontal
            let lower = min(p1.x, p2.x)
            let upper = max(p1.x, p2.x)
            return Array(lower...upper).map { Point(x: $0, y: p1.y) }
        } else if abs(slope) == 1.0 {
            // 45 Degree diagonal
            let steps = Int(abs(p2.y - p1.y))
            return (0...steps).map {
                let x = p1.x > p2.x ? p1.x - $0 : p1.x + $0
                let y = p1.y > p2.y ? p1.y - $0 : p1.y + $0
                return Point(x: x, y: y)
            }
        }

        return []
    }
}

final class Day5: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let lines = input.components(separatedBy: .newlines)
            .compactMap(Line.init(string:))
            .filter(\.isHorizontalOrVertical)

        var grid: [Line.Point: Int] = [:]

        for point in lines.flatMap(\.points) {
            grid[point, default: 0] += 1
        }

        return grid.filter { $0.value > 1 }.count
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let lines = input.components(separatedBy: .newlines)
            .compactMap(Line.init(string:))

        var grid: [Line.Point: Int] = [:]

        for point in lines.flatMap(\.points) {
            grid[point, default: 0] += 1
        }

        return grid.filter { $0.value > 1 }.count
    }
}
