//
//  Day9.swift
//  AdventOfCode
//

import Foundation

private struct Grid {
    struct Cell {
        let value: Int
        let index: Int

        init(index: Int, value: Int) {
            self.value = value
            self.index = index
        }
    }

    private let boardSize: Int
    private let cells: [Cell]

    init(gridString: String) {
        let lines = gridString.components(separatedBy: .newlines)

        boardSize = lines[0].count
        cells = lines.flatMap({ $0 })
            .map(String.init)
            .compactMap(Int.init)
            .enumerated()
            .map(Cell.init)
    }

    func lowPointCells() -> [Cell] {
        cells.filter { cell in
            adjacentCells(for: cell).allSatisfy { cell.value < $0.value }
        }
    }

    func basins() -> [[Cell]] {
        lowPointCells()
            .map(basinFor(lowPoint:))
    }

    private func basinFor(lowPoint: Cell) -> [Cell] {
        var visitedIndices: [Int] = []

        func monotonicAdjacents(for cell: Cell) -> [Cell] {
            guard !visitedIndices.contains(cell.index) else { return [] }
            visitedIndices.append(cell.index)

            let result = adjacentCells(for: cell).filter { $0.value < 9 && $0.value > cell.value }

            if result.isEmpty {
                return [cell]
            }

            return [cell] + result.flatMap(monotonicAdjacents(for:))
        }

        return monotonicAdjacents(for: lowPoint)

    }

    private func adjacentCells(for cell: Cell) -> [Cell] {
        let index = cell.index
        var indices = [index - boardSize, index + boardSize]

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

final class Day9: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        Grid(gridString: input)
            .lowPointCells()
            .map { $0.value + 1 }
            .reduce(0, +)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        Grid(gridString: input)
            .basins()
            .map(\.count)
            .sorted(by: >)
            .prefix(3)
            .reduce(1, *)
    }
}
