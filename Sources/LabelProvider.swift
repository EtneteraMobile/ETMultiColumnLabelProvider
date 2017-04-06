//
//  LabelProvider.swift
//  ETMultiColumnLabelProvider
//
//  Created by Petr Urban on 16/02/2017.
//
//

import Foundation
import ETMultiColumnView

// MARK: - LabelProvider

public struct LabelProvider: ViewProvider {

    // MARK: - Variables
    // MARK: public

    public var reuseId: String {
        switch content.style {
        case .oneLine(_): return "OneLineLabel"
        case .multiLine(_): return "MultilineLabel"
        case let .lines(lines): return "MultiLabel-\(lines.count)"
        }
    }

    public var hashValue: Int {
        return content.style.hashValue
    }

    // MARK: private

    private let content: Content

    // MARK: - Initialization

    public init(with content: Content) {
        self.content = content
    }

    // MARK: - ViewProvider

    public func make() -> UIView {
        switch content.style {
        case .oneLine(_): return UILabel()
        case .multiLine(_): return UILabel()
        case let .lines(lines): return MultiLabelsView(withLabelsCount: lines.count)
        }
    }

    public func customize(view view: UIView) {
        customize(view, content.style)
    }

    public func boundingSize(widthConstraint width: CGFloat) -> CGSize {
        return boundingSize(widthConstraint: width, content.style)
    }

    // MARK: - Customize and size for recursion

    public func customize(view: UIView, _ style: Content.Style) {

        switch style {
        case let .oneLine(attText):
            guard let v = view as? UILabel else { preconditionFailure("Expected: UILabel") }

            v.attributedText = attText

            v.numberOfLines = 1
            v.lineBreakMode = .ByTruncatingTail

        case let .multiLine(attText):
            guard let v = view as? UILabel else { preconditionFailure("Expected: UILabel")}

            v.attributedText = attText

            v.numberOfLines = 0
            v.lineBreakMode = .ByTruncatingTail

        case let .lines(lines):
            guard let v = view as? MultiLabelsView, let labels = v.subviews as? [UILabel] else { preconditionFailure("Expected: MultiLabelsView") }
            guard lines.count == labels.count else { preconditionFailure("Specs couns different from labels count") }

            labels.enumerate().forEach {
                let lineStyle = lines[$0.index]
                self.customize($0.element, lineStyle)
            }
        }
    }

    public func boundingSize(widthConstraint width: CGFloat, _ style: Content.Style) -> CGSize {
        let size: CGSize
        switch style {
        case let .oneLine(attText):
            size = attText.calculate(inWidth: width, isMultiline: false)

        case let .multiLine(attText):
            size = attText.calculate(inWidth: width, isMultiline: true)

        case let .lines(lines):
            var maxWidth = CGFloat.min
            let height = lines.reduce(CGFloat(0.0)) {
                let s = self.boundingSize(widthConstraint: width, $1)
                maxWidth = max(maxWidth, s.width)
                return $0 + s.height
            }
            size = CGSize(width: maxWidth, height: height)
        }
        return CGSize(width: min(width, size.width), height: size.height)
    }
}

// MARK: - LabelProvider.Content

public extension LabelProvider {
    
    public struct Content {
        let style: Style

        public init(style: Style) {
            self.style = style
        }

        public indirect enum Style: Hashable {
            case oneLine(NSAttributedString)
            case multiLine(NSAttributedString)
            case lines([Style])

            public var hashValue: Int {
                switch self {
                case let .oneLine(text): return 0 ^ text.hashValue
                case let .multiLine(text): return 1 ^ text.hashValue
                case let .lines(lines): return lines.reduce(2) { $0 ^ $1.hashValue }
                }
            }
        }
    }
}

// MARK: - Equatable

public func ==(lhs: LabelProvider, rhs: LabelProvider) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public func ==(lhs: LabelProvider.Content.Style, rhs: LabelProvider.Content.Style) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

