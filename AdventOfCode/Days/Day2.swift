//
//  Day2.swift
//  AdventOfCode
//

import Foundation

final class Day2: Day {
    enum Movement {
        case horizontal(Int)
        case up(Int)
        case down(Int)

        /// Here we have a very non-general adhoc way of parsing things.
        /// In reality it would be much nicer to use a parser-combinator, however it's also probably an overkill for a simple exercise.
        init?(input: String) {
            guard let number = Int(input.drop(while: { !$0.isNumber })) else {
                return nil
            }

            if input.hasPrefix("down") {
                self = .down(number)
            } else if input.hasPrefix("up") {
                self = .up(-number)
            } else if input.hasPrefix("forward") {
                self = .horizontal(number)
            } else {
                return nil
            }
        }
    }
    
    func part1(_ input: String) -> CustomStringConvertible {
        let movements = input
            .components(separatedBy: .newlines)
            .compactMap(Movement.init)

        let totalMovement = movements
            .reduce(into: (horizontal: 0, vertical: 0)) { acc, movement in
                switch movement {
                case let .horizontal(value):
                    acc.horizontal += value
                case let .up(value), let .down(value):
                    acc.vertical += value
                }
            }

        return totalMovement.horizontal * totalMovement.vertical
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let movements = input
            .components(separatedBy: .newlines)
            .compactMap(Movement.init)

        let totalMovementWithAim = movements
            .reduce(into: (horizontal: 0, vertical: 0, aim: 0)) { acc, movement in
                switch movement {
                case let .horizontal(value):
                    acc.horizontal += value
                    acc.vertical += acc.aim * value
                case let .up(value), let .down(value):
                    acc.aim += value
                }
            }

        return totalMovementWithAim.horizontal * totalMovementWithAim.vertical
    }
}
