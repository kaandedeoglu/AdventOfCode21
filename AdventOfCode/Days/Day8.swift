//
//  Day8.swift
//  AdventOfCode
//

import Foundation

final class Day8: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        input.components(separatedBy: .newlines)
            .compactMap { $0.components(separatedBy: " | ").last }
            .flatMap { $0.components(separatedBy: .whitespaces) }
            .filter { [2, 3, 4, 7].contains($0.count) }
            .count
    }

    func part2(_ input: String) -> CustomStringConvertible {
        input.components(separatedBy: .newlines)
            .map(outputSum)
            .reduce(0, +)
    }

    private func outputSum(for line: String) -> Int {
        let parts = line.components(separatedBy: " | ")
        var signalPatterns = parts[0].components(separatedBy: .whitespaces).map { String($0.sorted()) }
        let outputValues = parts[1].components(separatedBy: .whitespaces).map { String($0.sorted()) }

        let originalValues = ["abcefg" ,"cf" ,"acdeg" ,"acdfg" ,"bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"].map { String($0.sorted()) }
        let originalMapping = Dictionary(uniqueKeysWithValues: zip2(originalValues, 0..<originalValues.count))

        var newMapping: [String: Int] = [:]

        for i in [2, 3, 4, 7] {
            guard let originalIndex = originalValues.firstIndex(where: { $0.count == i }),
                  let correspondingNumber = originalMapping[originalValues[originalIndex]],
                  let matchingIndex = signalPatterns.firstIndex(where: { $0.count == i }) else {
                continue
            }

            newMapping[signalPatterns[matchingIndex]] = correspondingNumber
//            originalValues.remove(at: originalIndex)
            signalPatterns.remove(at: matchingIndex)
        }

        // out of 3 6-length strings (0, 6, 9) - the one that doesn't have a complete intersection with 7 is 6
        // the one that completely intersects with 4 is 9
        // the remaining one is 0
        var (sixes, fives) = signalPatterns.partitioned(by: { $0.count == 6 })

        guard let seven = newMapping.first(where: { $0.value == 7 })?.key,
              let six = sixes.first(where: { Set(seven).isSubset(of: Set($0)) == false }),
              let four = newMapping.first(where: { $0.value == 4 })?.key,
              let nine = sixes.first(where: { Set(four).isSubset(of: Set($0) )}) else { return 0 }

        sixes.removeAll(where: { $0 == six || $0 == nine })

        newMapping[six] = 6
        newMapping[nine] = 9
        newMapping[sixes[0]] = 0

        // out of 3 5-length strings (2, 3, 5) - the one that has complete intersection with 7 is 3.
        // the one that completely intersects with 6 is 5.
        // the remaining one is 2
        guard let three = fives.first(where: { Set(seven).isSubset(of: Set($0)) }),
              let five = fives.first(where: { Set($0).isSubset(of: Set(six))}) else { return 0 }

        fives.removeAll(where: { $0 == three || $0 == five })

        newMapping[three] = 3
        newMapping[five] = 5
        newMapping[fives[0]] = 2

        let result = outputValues.reduce(into: "") { acc, output in
            guard let number = newMapping[output] else { return }
            acc.append(contentsOf: String(number))
        }

        return Int(result)!
    }
}
