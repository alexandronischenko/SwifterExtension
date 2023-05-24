import Foundation
import XcodeKit
import RegexBuilder

class RemarkPrintCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            print("No selection")
            return
        }
        var start = 0, end = 0
        
        if selection.start.line == selection.end.line && selection.start.column == selection.end.column {
            start = 0
            end = invocation.buffer.lines.count - 1
        } else {
            start = selection.start.line
            end = selection.end.line
        }
        for index in start ... end {
            var line = invocation.buffer.lines[index] as! String
            if line.matches(String("^[\t| ]*print")) {
                var currentIndex = line.startIndex
                let startChar: Character = "p"
                
                while startChar != line[currentIndex] {
                    currentIndex = line.index(after: currentIndex)
                }
                
                line.insert(contentsOf: "//", at: currentIndex)
                invocation.buffer.lines[index] = line
            }
        }
        completionHandler(nil)
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
