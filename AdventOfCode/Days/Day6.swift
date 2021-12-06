//
//  Day6.swift
//  AdventOfCode
//

import Foundation

final class Day6: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        lanternfishCount(forInput: input, days: 80)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        lanternfishCount(forInput: input, days: 256)
    }

    private func lanternfishCount(forInput input: String, days: Int) -> Int {
        let numbers = input.components(separatedBy: ",").compactMap(Int.init)

        var dictionary: [Int: Int] = [:]
        for number in numbers {
            dictionary[number, default: 0] += 1
        }

        for _ in 0..<days {
            var newDictionary: [Int: Int] = [:]

            for (number, count) in dictionary {
                switch number {
                case 0:
                    newDictionary[6, default: 0] += count
                    newDictionary[8, default: 0] += count
                default:
                    newDictionary[number - 1, default: 0] += count
                }
            }

            dictionary = newDictionary
        }

        return dictionary.values.reduce(0, +)
    }
}
