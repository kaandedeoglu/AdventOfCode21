func zip2<S1, S2>(
    _ xs: S1, _ ys: S2
) -> [(S1.Element, S2.Element)] where S1: Sequence, S2:Sequence {
    var result: [(S1.Element, S2.Element)] = []
    var iterator1 = xs.makeIterator()
    var iterator2 = ys.makeIterator()

    while let left = iterator1.next(), let right = iterator2.next() {
        result.append((left, right))
    }

    return result
}

func zip3<S1, S2, S3>(
    _ xs: S1, _ ys: S2, _ zs: S3
) -> [(S1.Element, S2.Element, S3.Element)] where S1: Sequence, S2: Sequence, S3: Sequence {
    zip2(xs, zip2(ys, zs)).map { a, bc in
        (a, bc.0, bc.1)
    }
}
