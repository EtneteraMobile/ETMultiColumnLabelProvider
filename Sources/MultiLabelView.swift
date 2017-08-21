//
//  MultiLabelsView.swift
//  ETMultiColumnLabelProvider
//
//  Created by Petr Urban on 15/02/2017.
//

import UIKit

/// View holds multiple labels that are layouted above each other (as multi lines).
class MultiLabelsView: UIView {

    // MARK: - Variables
    // MARK: public

    var labels: [UILabel] {
        return subviews as! [UILabel]
    }

    // MARK: - Initialization

    init(withLabelsCount count: Int) {
        super.init(frame: .zero)

        for _ in 0..<count {
            addSubview(UILabel())
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content

    override func layoutSubviews() {
        super.layoutSubviews()

        if labels.count > 1 {
            let _ = labels.reduce(CGFloat(0)) { top, label in
                let size = label.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
                label.frame = CGRect(x: 0.0, y: top, width: frame.width, height: size.height)
                return top + label.frame.size.height
            }
        }
        else {
            labels.first?.frame = bounds
        }
    }
}
