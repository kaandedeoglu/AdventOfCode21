//
//  Day7.swift
//  AdventOfCode
//

import Foundation

final class Day7: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let numbers = input.components(separatedBy: ",").compactMap(Int.init)
        return minimumFuelConsumption(forNumbers: numbers, consumption: { l, r in
            l > r ? l - r : r - l
        })
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let numbers = input.components(separatedBy: ",").compactMap(Int.init)
        return minimumFuelConsumption(forNumbers: numbers, consumption: { l, r in
            let difference = l > r ? l - r : r - l
            return (difference + 1) * difference / 2
        })
    }

    private func minimumFuelConsumption(forNumbers numbers: [Int], consumption: (Int, Int) -> Int) -> Int {
        guard numbers.isEmpty == false else { return 0 }

        let range = Array(numbers.min()!...numbers.max()!)

        var minimumConsumption: Int = .max

        for targetHorizontalDestination in range {
            var totalConsumption = 0

            for number in numbers {
                totalConsumption += consumption(targetHorizontalDestination, number)
            }

            minimumConsumption = min(minimumConsumption, totalConsumption)
        }

        return minimumConsumption
    }
}
