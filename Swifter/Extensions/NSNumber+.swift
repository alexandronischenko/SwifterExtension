import Foundation

extension NSNumber {
    
    var valueType: String {
        if type(of: self) == type(of: NSNumber(value: true)) {
            return "Bool"
        } else if self is Int {
            return "Int"
        } else {
            return "Double"
        }
    }
}
