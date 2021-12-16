//
//  Day14.swift
//  AdventOfCode
//

import Foundation

final class Day14: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        polymerTemplate(forInput: input, iterations: 10)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        polymerTemplate(forInput: input, iterations: 40)
    }

    private func polymerTemplate(forInput input: String, iterations: Int) -> Int {
        let parts = input.components(separatedBy: "\n\n")
        let template = parts[0]
        let rulePairs: [(String, Character)] = parts[1]
            .components(separatedBy: .newlines)
            .map { line in
                let parts = line.components(separatedBy: " -> ")
                return (parts[0], parts[1].first!)
            }

        let ruleDictionary = Dictionary(uniqueKeysWithValues: rulePairs)

        var letterFrequencies: [Character: Int] = [:]
        for char in template {
            letterFrequencies[char, default: 0] += 1
        }

        var segmentFrequencies: [String: Int] = [:]
        zip2(template, String(template.dropFirst())).forEach { left, right in
            let merged = "\(left)\(right)"
            segmentFrequencies[merged, default: 0] += 1
        }

        for _ in 0..<iterations {
            for (segment, occurenceCount) in segmentFrequencies {
                if let match = ruleDictionary[segment] {

                    let joined1 = "\(segment.first!)\(match)"
                    let joined2 = "\(match)\(segment.last!)"
                    segmentFrequencies[segment, default: 0] -= occurenceCount
                    segmentFrequencies[joined1, default: 0] += occurenceCount
                    segmentFrequencies[joined2, default: 0] += occurenceCount

                    letterFrequencies[match, default: 0] += occurenceCount
                }
            }
        }

        let maxFrequency = letterFrequencies.max(by: { $0.value < $1.value })!.value
        let minFrequency = letterFrequencies.min(by: { $0.value < $1.value })!.value
        return maxFrequency - minFrequency
    }
}
