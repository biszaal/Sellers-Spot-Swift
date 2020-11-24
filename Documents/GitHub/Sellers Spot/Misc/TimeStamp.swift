import Foundation
import SwiftUI

extension Date
{
    func timeAgoDisplayed() -> String
    {
        //print(self)
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        if (secondsAgo < 60)
        {
            return("\(secondsAgo) seconds ago")
        }
        
        if (secondsAgo < 60 * 60)
        {
            return("\(secondsAgo / 60) minutes ago")
        }
        
        if (secondsAgo < 60 * 60 * 24)
        {
            return("\(secondsAgo / 60 / 60) hours ago")
        }
        
        if (secondsAgo < 60 * 60 * 24 * 7)
        {
            return("\(secondsAgo / 60 / 60 / 24) days ago")
        }
        
        if (secondsAgo < 60 * 60 * 24 * 30)
        {
            return("\(secondsAgo / 60 / 60 / 24 / 7) weeks ago")
        }
        
        if (secondsAgo < 60 * 60 * 24 * 365)
        {
            return("\(secondsAgo / 60 / 60 / 24 / 30) months ago")
        }
        
        return("\(secondsAgo / 60 / 60 / 24 / 365) years ago")
    }
    
    func rnDate() -> String
    {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        isoFormatter.timeZone = TimeZone.autoupdatingCurrent
        isoFormatter.locale = Locale.current
        let date = isoFormatter.string(from: Date())
        return date
    }
}

extension Int
{
    func shorten() -> String
    {
        var returnValue: String = ""
        
        if self > 1000000
        {
            let temp = (Float(self) / 100000).rounded() * 100000
            returnValue = "\(temp / 1000000)m"
        }
        
        else if self >= 1000
        {
            let temp = (Float(self) / 100).rounded() * 100
            returnValue = "\(temp / 1000)k"
        }
        
        else
        {
            returnValue = String(self)
        }
        
        return returnValue
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
