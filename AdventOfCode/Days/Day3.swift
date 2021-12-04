//
//  Day3.swift
//  AdventOfCode
//

import Foundation

final class Day3: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        let inputSize = lines.count
        let singleInputLength = lines[0].count

        let counts = lines.reduce(into: Array.init(repeating: 0, count: singleInputLength)) { acc, input in
            for (idx, number) in input.enumerated() where number == "1" {
                acc[idx] = acc[idx] + 1
            }
        }

        var gammaBinaryString = ""
        var epsilonBinaryString = ""

        for count in counts {
            if count > inputSize / 2 {
                gammaBinaryString.append("1")
                epsilonBinaryString.append("0")
            } else {
                gammaBinaryString.append("0")
                epsilonBinaryString.append("1")
            }
        }

        let gamma = Int(gammaBinaryString, radix: 2)
        let epsilon = Int(epsilonBinaryString, radix: 2)

        return gamma! * epsilon!
    }

    func part2(_ input: String) -> CustomStringConvertible {
        func reducing(_ binaryStrings: [String], idx: Int = 0, comparingTo character: Character, comparison: (Int, Int) -> Bool) -> String {
            if binaryStrings.count == 1 {
                return binaryStrings[0]
            }

            let predicate: (String) -> Bool = { str in
                let index = str.index(str.startIndex, offsetBy: idx)
                return str[index] == character
            }

            let (left, right) = binaryStrings.partitioned(by: predicate)
            if comparison(left.count, right.count) {
                return reducing(left, idx: idx + 1, comparingTo: character, comparison: comparison)
            } else {
                return reducing(right, idx: idx + 1, comparingTo: character, comparison: comparison)
            }
        }

        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        let oxygenBinaryString = reducing(lines, comparingTo: "1", comparison: >=)
        let c02BinaryString = reducing(lines, comparingTo: "0", comparison: <=)

        let oxygen = Int(oxygenBinaryString, radix: 2)
        let c02 = Int(c02BinaryString, radix: 2)

        return oxygen! * c02!
    }
}
