//
//  Day4.swift
//  AdventOfCode
//

import Foundation

private final class Grid {
    private final class Cell {
        let number: Int
        var isSelected = false

        init(number: Int) {
            self.number = number
        }
    }

    static let gridSize = 5

    private let cells: [Cell]
    private var finished = false

    init(numbers: [Int]) {
        guard numbers.count == Self.gridSize * Self.gridSize else {
            fatalError("Trying to initialize a grid with incorrect number of values")
        }

        cells = numbers.map(Cell.init)
    }

    private func row(at index: Int) -> [Cell] {
        cells
            .indices
            .filter { $0 / Self.gridSize == index }
            .map { cells[$0] }
    }

    private func column(at index: Int) -> [Cell] {
        cells
            .indices
            .filter { $0 % Self.gridSize == index }
            .map { cells[$0] }
    }

    func apply(drawnNumber number: Int) -> Int? {
        guard !finished, let cellIndex = cells.firstIndex(where: { $0.number == number }) else { return nil }

        cells[cellIndex].isSelected = true

        let rowNumber = cellIndex / Self.gridSize
        let columnNumber = cellIndex % Self.gridSize

        guard row(at: rowNumber).allSatisfy(\.isSelected) || column(at: columnNumber).allSatisfy(\.isSelected) else { return nil }

        finished = true

        let unselectedNumbersSum = cells
            .filter { !$0.isSelected }
            .map(\.number)
            .reduce(0, +)

        let score = unselectedNumbersSum * number
        return score
    }
}

final class Day4: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        var lines = input.components(separatedBy: .whitespacesAndNewlines)
        let selectedNumbers = lines.removeFirst().components(separatedBy: ",").compactMap(Int.init)

        let grids = lines
            .filter { !$0.isEmpty }
            .compactMap(Int.init)
            .chunks(ofCount: Grid.gridSize * Grid.gridSize)
            .map(Array.init)
            .map(Grid.init)

        for number in selectedNumbers {
            if let score = grids.compactMap({ $0.apply(drawnNumber:number) }).first {
                return score
            }
        }

        return 0
    }

    func part2(_ input: String) -> CustomStringConvertible {
        var lines = input.components(separatedBy: .whitespacesAndNewlines)
        let selectedNumbers = lines.removeFirst().components(separatedBy: ",").compactMap(Int.init)

        let grids = lines
            .filter { !$0.isEmpty }
            .compactMap(Int.init)
            .chunks(ofCount: Grid.gridSize * Grid.gridSize)
            .map(Array.init)
            .map(Grid.init)

        var scores: [Int] = []
        for number in selectedNumbers {
            let finishedScores = grids.compactMap({ $0.apply(drawnNumber:number) })
            scores.append(contentsOf: finishedScores)
        }

        return scores.last!
    }
}
