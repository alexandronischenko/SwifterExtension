import Foundation

extension Collection {
    
    func index(of index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
}
