//
//  Day11.swift
//  AdventOfCode
//

import Foundation

private class Grid: CustomStringConvertible {
    class Cell {
        var value: Int
        let index: Int

        init(index: Int, value: Int) {
            self.value = value
            self.index = index
        }
    }

    private let boardSize: Int
    private let cells: [Cell]
    private var flashedIndices: Set<Int> = []

    var flashCount = 0
    var isAllFlashed: Bool {
        flashedIndices.count == cells.count
    }

    init(gridString: String) {
        let lines = gridString.components(separatedBy: .newlines)

        boardSize = lines[0].count
        cells = lines.flatMap({ $0 })
            .map(String.init)
            .compactMap(Int.init)
            .enumerated()
            .map(Cell.init)
    }

    func increase() {
        flashedIndices.removeAll(keepingCapacity: true)
        increaseAll(cells)
    }

    private func increaseAll(_ cells: [Cell]) {
        var flashedCells: [Cell] = []

        for cell in cells {
            guard !flashedIndices.contains(cell.index) else {
                continue
            }

            switch cell.value {
            case 9:
                cell.value = 0

                flashedCells.append(cell)
                flashedIndices.insert(cell.index)
                flashCount += 1
            default:
                cell.value += 1
            }
        }

        for flashedCell in flashedCells {
            increaseAll(adjacentCells(for: flashedCell))
        }
    }

    private func adjacentCells(for cell: Cell) -> [Cell] {
        let index = cell.index

        // Add the top - down indices
        var indices = [index - boardSize, index + boardSize]

        // Add the previous index only if we're not at the left edge
        if index % boardSize != 0 {
            indices.append(contentsOf: [index - 1, index - boardSize - 1, index + boardSize - 1])
        }

        // Add the next index only if we're not at the right edge
        if index % boardSize != boardSize - 1 {
            indices.append(contentsOf: [index + 1, index - boardSize + 1, index + boardSize + 1])
        }

        return indices
            .filter { cells.indices.contains($0) }
            .map { cells[$0] }
    }

    var description: String {
        cells
            .map(\.value)
            .map(String.init)
            .chunks(ofCount: 10)
            .map { $0.joined() }
            .joined(separator: "\n")
    }
}

final class Day11: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let grid = Grid(gridString: input)
        (0..<100).forEach { _ in grid.increase() }
        return grid.flashCount
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let grid = Grid(gridString: input)

        return (1...).first(where: { _ in
            grid.increase()
            return grid.isAllFlashed
        })!
    }
}
