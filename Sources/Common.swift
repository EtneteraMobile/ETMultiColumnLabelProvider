//
//  Common.swift
//  Pods
//
//  Created by Jan Čislinský on 17/02/2017.
//
//

import Foundation
import CoreText

extension NSAttributedString {

    func calculate(inWidth width: CGFloat, isMultiline: Bool) -> CGSize {

        let widthConstraints = (isMultiline == true ? width : CGFloat.greatestFiniteMagnitude)
        let boundingRect = self.boundingRect(with: CGSize(width: widthConstraints, height: CGFloat.greatestFiniteMagnitude), options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)

        return boundingRect.size
    }
}
