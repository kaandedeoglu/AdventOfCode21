import Foundation


guard let url = Bundle.main.url(forResource: "Input", withExtension: "txt"),
      let inputData = try? Data(contentsOf: url),
      var inputString = String(data: inputData, encoding: .utf8) else {
    exit(0)
}

let lines = inputString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
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

let result = gamma! * epsilon!

// Part 2
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

let oxygenBinaryString = reducing(lines, comparingTo: "1", comparison: >=)
let c02BinaryString = reducing(lines, comparingTo: "0", comparison: <=)

let oxygen = Int(oxygenBinaryString, radix: 2)
let c02 = Int(c02BinaryString, radix: 2)

let result2 = oxygen! * c02!

// Helper
extension Sequence {
    func partitioned(by predicate: (Element) -> Bool) -> ([Element], [Element]) {
        var left: [Element] = []
        var right: [Element] = []

        forEach { element in
            if predicate(element) {
                left.append(element)
            } else {
                right.append(element)
            }
        }

        return (left, right)
    }
}
