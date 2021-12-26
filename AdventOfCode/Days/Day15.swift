//
//  Day15.swift
//  AdventOfCode
//

import Foundation
import Collections

private final class Grid {
    struct Cell: Comparable {
        let index: Int
        let cost: Int
        var totalCost: Int = 0

        init(index: Int, cost: Int) {
            self.cost = cost
            self.index = index
        }

        static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.index == rhs.index
        }

        static func <(lhs: Self, rhs: Self) -> Bool {
            lhs.totalCost < rhs.totalCost
        }
    }

    private let boardSize: Int
    private var cells: [Cell]

    init(gridString: String) {
        let lines = gridString.components(separatedBy: .newlines)

        boardSize = lines[0].count
        cells = lines.flatMap({ $0 })
            .map(String.init)
            .compactMap(Int.init)
            .enumerated()
            .map(Cell.init)
    }

    func dijkstras() -> Int {
        var heap = Heap<Cell>()
        let targetIndex = cells.last!.index
        heap.insert(cells.first!)

        while let cell = heap.popMin() {
            if cell.index == targetIndex {
                return cell.totalCost
            }

            for neighbor in adjacentCells(for: cell) {
                let newCost = neighbor.cost + cell.totalCost
                if neighbor.totalCost == 0 || neighbor.totalCost > newCost {
                    var copy = neighbor
                    copy.totalCost = newCost
                    heap.insert(copy)
                    cells[copy.index] = copy
                }
            }
        }

        return -1
    }

    private func adjacentCells(for cell: Cell) -> [Cell] {
        let index = cell.index
        var indices = [index + boardSize, index - boardSize]

        // Add the previous index only if we're not at the left edge
        if index % boardSize != 0 {
            indices.append(index - 1)
        }

        // Add the next index only if we're not at the right edge
        if index % boardSize != boardSize - 1 {
            indices.append(index + 1)
        }

        return indices
            .filter { cells.indices.contains($0) }
            .map { cells[$0] }
    }
}

final class Day15: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        Grid(gridString: input)
            .dijkstras()
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let lines = input.components(separatedBy: .newlines)

        let extended: [String] = lines.map { line in
                var new = ""

                for i in 0..<5 {
                    for c in line {
                        var newNumber = c.wholeNumberValue! + i
                        if newNumber > 9 {
                            newNumber -= 9
                        }
                        new.append(String(newNumber))
                    }
                }

                return new
        }

        var result: [String] = []
        for i in 0..<5 {
            for l in extended {
                var new = ""
                for c in l {
                    var newNumber = c.wholeNumberValue! + i
                    if newNumber > 9 {
                        newNumber -= 9
                    }
                    new.append(String(newNumber))
                }
                result.append(new)
            }
        }

        let extendedInput = result.joined(separator: "\n")

        return Grid(gridString: extendedInput)
            .dijkstras()
    }
}
