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
