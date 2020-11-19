import SwiftUI

class TextLimiter: ObservableObject
{
    private let limit: Int
    
    init(limit: Int)
    {
        self.limit = limit
    }
    
    @Published var hasReachedLimit = false
    @Published var text = "" {
        didSet {
            if text.count > self.limit {
                text = String(text.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
}
