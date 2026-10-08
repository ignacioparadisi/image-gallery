import CoreGraphics

extension CGRect {
    /// Returns the largest rectangle with the given aspect ratio that fits inside this one, centered.
    func aspectFitting(width: CGFloat, height: CGFloat) -> CGRect {
        guard width > 0, height > 0, self.width > 0, self.height > 0 else { return self }
        let scale = min(self.width / width, self.height / height)
        let size = CGSize(width: width * scale, height: height * scale)
        return CGRect(x: midX - size.width / 2, y: midY - size.height / 2, width: size.width, height: size.height)
    }
}
