import Foundation
import XcodeKit
import RegexBuilder

class CamelCaseCommand: NSObject, XCSourceEditorCommand {
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
        
        for (i, line) in (startLine...endLine).enumerated() {
            lines.remove(lines[line - i])
        }
        
        let result = selectedLines.map { line in
            line.camelCase
        }
        
        lines.insert(result.joined(), at: startLine)
        
        completionHandler(nil)
    }
}

extension String {
    var lowercasingFirst: String { prefix(1).lowercased() + dropFirst() }
    var uppercasingFirst: String { prefix(1).uppercased() + dropFirst() }
    
    var camelCased: String {
        guard !isEmpty else { return "" }
        let parts = components(separatedBy: .alphanumerics.inverted)
        let first = parts.first!.lowercasingFirst
        let rest = parts.dropFirst().map { $0.uppercasingFirst }
        
        return ([first] + rest).joined()
    }
}
