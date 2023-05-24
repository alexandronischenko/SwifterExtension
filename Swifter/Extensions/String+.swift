import Foundation

extension String {
    func remove(characters: [Character], in range: NSRange) -> String {
        var cleanString = self
        for char in characters {
            cleanString = cleanString.replacingOccurrences(of: String(char), with: "", options: .caseInsensitive, range: Range(range, in: self))
        }
        return cleanString
    }
    
    func substring(from idx: Int) -> String {
        guard idx < count else {
            return ""
        }
        let start = index(startIndex, offsetBy: idx)
        return String(self[start...])
    }
    
    func substring(to idx: Int) -> String {
        guard idx < count else {
            return self
        }
        let end = index(startIndex, offsetBy: idx)
        return String(self[...end])
    }
    
    func substring(from: Int, to: Int) -> String {
        guard from <= to else {
            return ""
        }
        let safeFrom = max(from, 0)
        let safeTo = min(to, count - 1)
        let start = index(startIndex, offsetBy: safeFrom)
        let end = index(startIndex, offsetBy: safeTo)
        return String(self[start...end])
    }
    
    var toJSONObject: [String : Any]? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String : Any]
    }
    
    var fullRange: NSRange {
        NSRange(startIndex..., in: self)
    }
    
    var endWithID: Bool {
        guard let regex = try? NSRegularExpression(pattern: "^\\w*(Id|ID|id)$") else {
            return false
        }
        return regex.firstMatch(in: self, range: fullRange) != nil
    }
    
    var trimmed: String {
        let startIndex = firstIndex(where: { !$0.isWhitespace }) ?? self.startIndex
        let endIndex = lastIndex(where: { !$0.isWhitespace }) ?? self.endIndex
        return String(self[startIndex...endIndex])
    }
    
    var unindented: String {
        let lines = split(separator: "\n", omittingEmptySubsequences: false)
        guard lines.count > 1 else { return trimmingCharacters(in: .whitespaces) }
        
        let indentation = lines.compactMap { $0.firstIndex(where: { !$0.isWhitespace })?.utf16Offset(in: $0) }
            .min() ?? 0
        
        return lines.map {
            guard $0.count > indentation else { return String($0) }
            return String($0.suffix($0.count - indentation))
        }.joined(separator: "\n")
    }
    
    var asPlaceholder: String {
        "<#\(self)#" + ">"
    }
    
    /// Returns a camelCase version of this string with spaces, dashes and underscores removed.
    /// Each space in the name denotes a new capitalized word.
    var camelCase: String {
        
        guard !isEmpty else {
            return self
        }
        var newString = ""
        var capitalizeNext = false
        for character in self {
            if capitalizeNext {
                newString += character.uppercased()
                capitalizeNext = false
            } else if character.isRemovable {
                capitalizeNext = true
            } else {
                newString += String(character)
            }
        }
        
        return newString
    }
}
