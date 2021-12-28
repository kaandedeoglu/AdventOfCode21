//
//  Day17.swift
//  AdventOfCode
//

import Foundation
import Parsing

private struct Vector {
    var x: Int
    var y: Int
}

private func calculate(for input: String) -> (maxY: Int, count: Int) {
    var input = input[...]

    let parser = PrefixThrough("=")
        .take(Int.parser())
        .skip("..")
        .take(Int.parser())
        .map { _, minX, maxX in
            ClosedRange(uncheckedBounds: minX < maxX ? (minX, maxX) : (maxX, minX))
        }

    guard let xRange = parser.parse(&input),
          let yRange = parser.parse(&input) else {
        return (0, 0)
    }

    var maxY = Int.min
    var count = 0

    for x in 0...xRange.upperBound {
        for y in yRange.lowerBound...500 {
            var position = Vector(x: 0, y: 0)
            var velocity = Vector(x: x, y: y)

            var highestY = Int.min

            while position.x <= xRange.upperBound, position.y >= yRange.lowerBound {
                position.x += velocity.x
                position.y += velocity.y
                highestY = max(highestY, position.y)

                if velocity.x > 0 {
                    velocity.x -= 1
                } else if velocity.x < 0 {
                    velocity.x += 1
                }
                velocity.y -= 1

                if xRange.contains(position.x),
                   yRange.contains(position.y) {
                    maxY = max(maxY, highestY)
                    count += 1
                    break
                }
            }
        }
    }

    return (maxY, count)
}

final class Day17: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        calculate(for: input).maxY
    }

    func part2(_ input: String) -> CustomStringConvertible {
        calculate(for: input).count
    }
}
