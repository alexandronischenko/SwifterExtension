import Foundation
import XcodeKit

extension Array where Element == String {
    
    func subString(from: XCSourceTextPosition, to: XCSourceTextPosition) -> String {
        let startLine = self[from.line]
        if from.line == to.line {
            return startLine.substring(from: from.column, to: to.column)
        }
        var substring = ""
        let targetLines = Array(self[from.line...to.line])
        for i in (0..<targetLines.count) {
            let line = targetLines[i]
            if i == 0 {
                substring += line.substring(from: from.column)
            } else if i == targetLines.count - 1 {
                substring += line.substring(to: to.column)
            } else {
                substring += line
            }
        }
        return substring
    }
}
