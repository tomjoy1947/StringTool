import Foundation
import PathKit

let kRegularExpressionPattern = "^\"(.*)\"\\s*=\\s*\"(.*)\";$";

public func parseString(path: Path, lang: String) -> [String: Dictionary<String, String>]? {
    do {
        let fileString = try path.read(.utf8)
        if !fileString.isEmpty {
            var resultDic = [String: Dictionary<String, String>]()
            let regularExpression = try NSRegularExpression.init(pattern: kRegularExpressionPattern, options: .init(rawValue: 0))
            
            fileString.enumerateLines(invoking: { (line, out) in
                var keyRange: NSRange;
                var valueRange: NSRange;
                var key: String;
                var value: String;
                
                let checkResult = regularExpression.firstMatch(in: line, options: .init(rawValue: 0), range: NSRange.init(location: 0, length: line.count))
                
                if checkResult?.numberOfRanges == 3 {
                    keyRange = (checkResult?.range(at: 1))!
                    valueRange = (checkResult?.range(at: 2))!
                    
                    if (keyRange.location != NSNotFound && valueRange.location != NSNotFound) {
                        let krange = keyRange.location..<keyRange.location + keyRange.length
                        key = String(line[krange])
                        
                        let vrange = valueRange.location..<valueRange.location + valueRange.length
                        value = String(line[vrange])
                        
                        resultDic.updateValue([lang: value], forKey: key)
                    }
                }
            })
            
            return resultDic;
        } else {
            return nil;
        }
    } catch {
        return nil;
    }
}


public func getStringValueKeys(path: Path) -> [String: [String]]? {
    do {
        let fileString = try path.read(.utf8)
        if !fileString.isEmpty {
            var resultDic = [String: [String]]()
            let regularExpression = try NSRegularExpression.init(pattern: kRegularExpressionPattern, options: .init(rawValue: 0))
            
            fileString.enumerateLines(invoking: { (line, out) in
                var keyRange: NSRange;
                var valueRange: NSRange;
                var key: String;
                var value: String;
                
                let checkResult = regularExpression.firstMatch(in: line, options: .init(rawValue: 0), range: NSRange.init(location: 0, length: line.count))
                
                if checkResult?.numberOfRanges == 3 {
                    keyRange = (checkResult?.range(at: 1))!
                    valueRange = (checkResult?.range(at: 2))!
                    
                    if (keyRange.location != NSNotFound && valueRange.location != NSNotFound) {
                        let krange = keyRange.location..<keyRange.location + keyRange.length
                        key = String(line[krange])
                        
                        let vrange = valueRange.location..<valueRange.location + valueRange.length
                        value = String(line[vrange])
                        
                        value = value.trimmingCharacters(in: .whitespaces)
                        
                        if resultDic[value] == nil {
                            resultDic[value] = [key]
                        } else {
                            resultDic[value] = resultDic[value]! + [key]
                        }
                    }
                }
            })
            
            return resultDic;
        } else {
            return nil;
        }
    } catch {
        return nil;
    }
}










extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

