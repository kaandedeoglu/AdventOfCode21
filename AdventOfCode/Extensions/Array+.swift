extension Array {
    func dropping(_ n: Int) -> Self {
        Self(dropFirst(n))
    }
}
