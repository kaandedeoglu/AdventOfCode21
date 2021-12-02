import Foundation

// Helper functions:
func zip2<A, B>(_ xs: [A], _ ys: [B]) -> [(A, B)] {
    var result: [(A, B)] = []
    (0..<min(xs.count, ys.count)).forEach { idx in
        result.append((xs[idx], ys[idx]))
    }
    return result
}

func zip3<A, B, C>(_ xs: [A], _ ys: [B], _ zs: [C]) -> [(A, B, C)] {
    zip2(xs, zip2(ys, zs)).map { a, bc in
        (a, bc.0, bc.1)
    }
}

extension Array {
    func dropping(_ n: Int) -> Self {
        Self(dropFirst(n))
    }
}

guard let url = Bundle.main.url(forResource: "Input", withExtension: "txt"),
      let inputData = try? Data(contentsOf: url),
      let inputString = String(data: inputData, encoding: .utf8) else {
    exit(0)
}

let numbers = inputString
    .components(separatedBy: .newlines)
    .compactMap(Int.init)

// Part 1
let part1 = zip2(numbers.dropping(1), numbers)
    .map { $0 - $1 }
    .filter { $0 > 0 }
    .count

print(part1)

// Part 2
let slidingWindowTotals = zip3(numbers.dropping(2), numbers.dropping(1), numbers)
    .map { $0 + $1 + $2 }

let part2 = zip2(slidingWindowTotals.dropping(1), slidingWindowTotals)
    .map { $0 - $1 }
    .filter { $0 > 0 }
    .count

print(part2)
