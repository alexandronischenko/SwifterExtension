import Foundation
import XcodeKit
import RegexBuilder

class SnakeCaseCommand: NSObject, XCSourceEditorCommand {
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
            line.camelCaseToSnakeCase()
        }
        
        lines.insert(result.joined(), at: startLine)
        
        completionHandler(nil)
    }
}

extension String {
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.processCamalCaseRegex(pattern: acronymPattern)?
            .processCamalCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
    }
    
    fileprivate func processCamalCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
