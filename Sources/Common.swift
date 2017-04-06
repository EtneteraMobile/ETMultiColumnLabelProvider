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

        let widthConstraints = (isMultiline == true ? width : CGFloat.max)
        let boundingRect = self.boundingRectWithSize(CGSize(width: widthConstraints, height: CGFloat.max), options: [ .UsesLineFragmentOrigin, .UsesFontLeading ], context: nil)

        return boundingRect.size
    }
}
