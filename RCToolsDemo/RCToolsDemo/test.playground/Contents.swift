//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

class RTPrint {
    var disable: Bool = false
    
    class func shareInstance() -> RTPrint {
        var predicate: dispatch_once_t = 0
        var instance: RTPrint?
        dispatch_once(&predicate, {
            instance = RTPrint()
        })
        return instance!
    }
    
    /// print any data
    func prt(items: Any) {
        guard !self.disable else {
            return
        }
        print(items)
    }
    
    /// Print multiple items concatenate with separator and terminate with terminator.
    ///
    /// - parameter items: The items you want to print.
    /// - parameter separator: The separator you used to separate items.
    /// - parameter terminator: The terminator you used to terminate print.
    func prtm(items: Any..., separator: String = ", ", terminator: String = "\n") {
        guard !self.disable else {
            return
        }
        let count = items.count
        print(items[0], terminator: "")
        for i in 1 ..< count {
            print(separator, terminator: "")
            print(items[i], terminator: "")
        }
        print(terminator, terminator: "")
        
    }
}

print(1, 2, "4", separator: ">", terminator: "\n")
RTPrint.shareInstance().prtm(1, 2, 3, "4", separator: "<", terminator: "\n")
