import Foundation
import XcodeKit

class UpperCaseCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        let textBuffer = invocation.buffer
        let lines = textBuffer.lines
        let selections = textBuffer.selections
        
        
        guard let selection = selections.firstObject as? XCSourceTextRange,
              let _lines = Array(lines) as? [String] else {
            completionHandler(NSError(domain: "Const.domain", code: 401, userInfo: ["reason": "text is not selected"]))
            return
        }
        
        let startLine = selection.start.line
        
        let endLine = (selection.end.column == 0 && (selection.start.line != selection.end.line))
        ? selection.end.line - 1
        : selection.end.line
        let selectedLines = Array(_lines[startLine...endLine])

        let upperLines = selectedLines.map { line in
            line.uppercased()
        }
        
        for (i, line) in (startLine...endLine).enumerated() {
            lines.remove(lines[line - i])
        }

        lines.insert(upperLines.joined(), at: startLine)
        
        completionHandler(nil)
    }
}
