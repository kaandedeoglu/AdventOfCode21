//
//  Day10.swift
//  AdventOfCode
//

import Foundation

final class Day10: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let lines = input.components(separatedBy: .newlines)

        let dict: [Character: Character] = [
            "<": ">",
            "[": "]",
            "(": ")",
            "{": "}"
        ]

        let scoresDict: [Character: Int] = [
            ">": 25137,
            "]": 57,
            ")": 3,
            "}": 1197
        ]

        var score = 0
        for line in lines {
            var remaining: [Character] = []

            for c in line {
                switch c {
                case "<", "{", "(", "[":
                    remaining.append(c)
                default:
                    guard dict[remaining.removeLast()] == c else {
                        score += scoresDict[c] ?? 0
                        break
                    }
                }
            }
        }

        return score
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let lines = input.components(separatedBy: .newlines)

        let dict: [Character: Character] = [
            "<": ">",
            "[": "]",
            "(": ")",
            "{": "}"
        ]

        let scoresDict: [Character: Int] = [
            ">": 4,
            "]": 2,
            ")": 1,
            "}": 3
        ]

        var scores: [Int] = []

    outer: for line in lines {
            var score = 0
            var remaining: [Character] = []

            for c in line {
                switch c {
                case "<", "{", "(", "[":
                    remaining.append(c)
                default:
                    guard dict[remaining.removeLast()] == c else {
                        continue outer
                    }
                }
            }

            if !remaining.isEmpty {
                let complete = remaining.reversed().compactMap { dict[$0] }

                score = complete.reduce(score, { acc, character in
                    guard let addedScore = scoresDict[character] else { return acc }

                    return (acc * 5) + addedScore
                })
                scores.append(score)
            }
        }

        return scores.sorted()[(scores.count - 1) / 2]
    }
}
