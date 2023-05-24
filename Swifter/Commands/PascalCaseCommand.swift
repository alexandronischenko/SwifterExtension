import Foundation
import XcodeKit
import RegexBuilder

class PascalCaseCommand: NSObject, XCSourceEditorCommand {
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
            line.pascalCase
        }
        
        lines.insert(result.joined(), at: startLine)
        
        completionHandler(nil)
    }
}

extension String {
    var pascalCase: String {
        return self.components(separatedBy: " ")
            .map {
                if $0.count <= 3 {
                    return $0.uppercased()
                } else {
                    if $0.firstIndex(of: "-") != nil {
                        return $0.components(separatedBy: "-").map { $0.pascalCase }.joined(separator: "-")
                    } else {
                        return $0.capitalized
                    }
                }
            }
            .joined(separator: " ")
    }
}
