import Foundation

enum Movement {
    case horizontal(Int)
    case vertical(Int)

    /// Here we have a very non-general adhoc way of parsing things.
    /// In reality it would be much nicer to use a parser-combinator, however it's also probably an overkill for a simple exercise.
    init?(input: String) {
        guard let number = Int(input.drop(while: { !$0.isNumber })) else {
            return nil
        }

        if input.hasPrefix("down") {
            self = .vertical(number)
        } else if input.hasPrefix("up") {
            self = .vertical(-number)
        } else if input.hasPrefix("forward") {
            self = .horizontal(number)
        } else {
            return nil
        }
    }
}

guard let url = Bundle.main.url(forResource: "Input", withExtension: "txt"),
      let inputData = try? Data(contentsOf: url),
      let inputString = String(data: inputData, encoding: .utf8) else {
    exit(0)
}

let totalMovement = inputString
    .components(separatedBy: .newlines)
    .compactMap(Movement.init)
    .reduce(into: (horizontal: 0, vertical: 0)) { acc, movement in
        switch movement {
        case let .horizontal(value):
            acc.horizontal += value
        case let .vertical(value):
            acc.vertical += value
        }
    }

let result = totalMovement.horizontal * totalMovement.vertical
print(result)
