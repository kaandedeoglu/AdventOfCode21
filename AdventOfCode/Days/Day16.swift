//
//  Day16.swift
//  AdventOfCode
//

import Foundation

private final class ValueTracker {
    enum Kind: Int {
        case sum = 0
        case product
        case minimum
        case maximum
        case literal
        case greater
        case less
        case equal

        var initialValue: Int {
            switch self {
            case .sum:
                return 0
            case .product:
                return 1
            case .minimum:
                return .max
            case .maximum:
                return .min
            case .literal:
                return 0
            case .greater:
                return .max
            case .less:
                return .max
            case .equal:
                return .max
            }
        }
    }

    private let kind: Kind
    private(set) var value: Int

    init(typeId: Int) {
        kind = Kind(rawValue: typeId)!
        value = kind.initialValue
    }

    func apply(value newValue: Int) {
        switch kind {
        case .sum:
            value += newValue
        case .product:
            value *= newValue
        case .minimum:
            value = min(value, newValue)
        case .maximum:
            value = max(value, newValue)
        case .literal:
            value = newValue
        case .greater:
            if value == .max {
                value = newValue
            } else {
                value = value > newValue ? 1 : 0
            }
        case .less:
            if value == .max {
                value = newValue
            } else {
                value = value < newValue ? 1 : 0
            }
        case .equal:
            if value == .max {
                value = newValue
            } else {
                value = value == newValue ? 1 : 0
            }
        }
    }
}

private final class PacketDecoder {
    private let mapping: [Character: String] = [
        "0": "0000",
        "1": "0001",
        "2": "0010",
        "3": "0011",
        "4": "0100",
        "5": "0101",
        "6": "0110",
        "7": "0111",
        "8": "1000",
        "9": "1001",
        "A": "1010",
        "B": "1011",
        "C": "1100",
        "D": "1101",
        "E": "1110",
        "F": "1111",
    ]

    struct Input {
        var string: String
        var value: Int = 0
    }

    var versionSum = 0

    @discardableResult
    func process(hexadecimal: String) -> Input {
        let expandedString = hexadecimal.reduce(into: "") { acc, character in
            if let expansion = mapping[character] {
                acc.append(expansion)
            }
        }

        return process(input: .init(string: expandedString))
    }

    private func process(input: Input) -> Input {
        var string = input.string

        let version = Int(string.prefix(3), radix: 2)!
        string.removeFirst(3)

        versionSum += version

        let typeId = Int(string.prefix(3), radix: 2)!
        string.removeFirst(3)

        let valueTracker = ValueTracker(typeId: typeId)

        switch typeId {
        case 4:
            // Literal value
            var valueBinary = ""
            while true {
                let prefix = string.removeFirst()

                valueBinary += string.prefix(4)
                string.removeFirst(4)
                if prefix == "0" {
                    let newValue = Int(valueBinary, radix: 2)!
                    valueTracker.apply(value: newValue)
                    break
                }

            }
        default:
            // Operator
            let lengthTypeID = Int(string.prefix(1), radix: 2)!
            string.removeFirst()

            switch lengthTypeID {
            case 0:
                let totalLength = Int(string.prefix(15), radix: 2)!
                string.removeFirst(15)

                var copy = string
                while true {
                    if string.count - copy.count < totalLength {
                        let input = process(input: .init(string: copy))
                        valueTracker.apply(value: input.value)
                        copy = input.string
                    } else {
                        string.removeFirst(totalLength)
                        break
                    }
                }
            case 1:
                let numberOfSubpackets = Int(string.prefix(11), radix: 2)!
                string.removeFirst(11)

                for _ in 0..<numberOfSubpackets {
                    let input = process(input: .init(string: string))
                    string = input.string
                    valueTracker.apply(value: input.value)
                }
            default:
                break
            }
        }

        return .init(string: string, value: valueTracker.value)
    }
}

final class Day16: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let decoder = PacketDecoder()
        decoder.process(hexadecimal: input)

        return decoder.versionSum
    }

    func part2(_ input: String) -> CustomStringConvertible {
        PacketDecoder()
            .process(hexadecimal: input)
            .value
    }
}
