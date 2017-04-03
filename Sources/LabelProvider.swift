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

    public func size(for width: CGFloat) -> CGSize {
        return size(for: width, content.style)
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

    public func size(for width: CGFloat, _ style: Content.Style) -> CGSize {
        switch style {
        case let .oneLine(attText):
            let s = CGSize(width: width, height: attText.calculateHeight(inWidth: width, isMultiline: false))
            return s

        case let .multiLine(attText):
            let s = CGSize(width: width, height: attText.calculateHeight(inWidth: width, isMultiline: true))
            print("multiline: " + attText.string + " \(s.height)")
            return s

        case let .lines(lines):
            let height = lines.reduce(CGFloat(0.0)) { return $0 + self.size(for: width, $1).height }
            let s = CGSize(width: width, height: height)
            print("lines \(s.height)")
            return s
        }
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

