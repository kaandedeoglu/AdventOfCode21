//
//  Day1.swift
//  AdventOfCode
//

import Foundation

final class Day1: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let numbers = input
            .components(separatedBy: .newlines)
            .compactMap(Int.init)

        /*
         return numbers
             .adjacentPairs()
             .map { $0.1 - $0.0 }
             .filter { $0 > 0 }
             .count
         */

        return zip2(numbers.dropping(1), numbers)
            .map { $0 - $1 }
            .filter { $0 > 0 }
            .count
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let numbers = input
            .components(separatedBy: .newlines)
            .compactMap(Int.init)

        let slidingWindowTotals = zip3(numbers.dropping(2), numbers.dropping(1), numbers)
            .map { $0 + $1 + $2 }

        return zip2(slidingWindowTotals.dropping(1), slidingWindowTotals)
            .map { $0 - $1 }
            .filter { $0 > 0 }
            .count
    }
}
