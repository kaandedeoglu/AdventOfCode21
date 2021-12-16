//
//  Day13.swift
//  AdventOfCode
//

import Foundation

private struct Coordinate: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
        "(\(x), \(y))"
    }
}

private enum FoldInstruction {
    case horizontal(Int)
    case vertical(Int)

    init?(string: String) {
        guard let number = Int(string.drop(while: { !$0.isNumber })) else {
            return nil
        }

        if string.hasPrefix("fold along x=") {
            self = .horizontal(number)
        } else if string.hasPrefix("fold along y=") {
            self = .vertical(number)
        } else {
            return nil
        }
    }
}

private extension Sequence where Element == Coordinate {
    func fold(with instruction: FoldInstruction) -> Set<Coordinate> {
        switch instruction {
        case let .horizontal(axis):
            return foldHorizontal(along: axis)
        case let .vertical(axis):
            return foldVertical(along: axis)
        }
    }

    private func foldVertical(along axis: Int) -> Set<Coordinate> {
        let upper = filter { $0.y < axis }
        let lower = filter { $0.y > axis }

        let folded = lower.map { Coordinate(x: $0.x, y: (2 * axis) - $0.y) }
        return Set(upper + folded)
    }

    private func foldHorizontal(along axis: Int) -> Set<Coordinate> {
        let left = filter { $0.x < axis }
        let right = filter { $0.x > axis }

        let folded = right.map { Coordinate(x: (2 * axis) - $0.x, y: $0.y) }
        return Set(left + folded)
    }

    var visualRepresentation: String {
        let width = self.max(by: { $0.x < $1.x })!.x + 1
        let height = self.max(by: { $0.y < $1.y })!.y + 1

        var array = Array<String>(repeating: ".", count: width * height)

        for coordinate in self {
            let index = (coordinate.y * width) + coordinate.x
            array[index] = "#"
        }

        return array
            .chunks(ofCount: width)
            .map { $0.joined() }
            .joined(separator: "\n")
    }
}

final class Day13: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let parts = input.components(separatedBy: "\n\n")
        let coordinatesString = parts[0]
        let instructionsString = parts[1]

        let coordinates: [Coordinate] = coordinatesString
            .components(separatedBy: .newlines)
            .map { line in
                let parts = line.components(separatedBy: ",").compactMap(Int.init)
                return .init(x: parts[0], y: parts[1])
            }

        let instructions = instructionsString
            .components(separatedBy: .newlines)
            .compactMap(FoldInstruction.init)

        return coordinates.fold(with: instructions[0]).count
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let parts = input.components(separatedBy: "\n\n")
        let coordinatesString = parts[0]
        let instructionsString = parts[1]

        let coordinates: [Coordinate] = coordinatesString
            .components(separatedBy: .newlines)
            .map { line in
                let parts = line.components(separatedBy: ",").compactMap(Int.init)
                return .init(x: parts[0], y: parts[1])
            }

        let instructions = instructionsString
            .components(separatedBy: .newlines)
            .compactMap(FoldInstruction.init)

        let result = instructions.reduce(Set(coordinates)) { acc, instruction in
            return acc.fold(with: instruction)
        }

        print("\n\n\(result.visualRepresentation)\n\n")

        return "See Consolse"
    }
}
