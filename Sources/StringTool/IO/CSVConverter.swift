import Foundation
import CSV
import PathKit


public func toCSVFile(dic: [String: Dictionary<String, String>], langArray: [String]){
    let stream = OutputStream(toMemory: ())
    let csv = try! CSVWriter(stream: stream)
    
    let titleRowArray = ["KEYWORD"] + langArray
    // Write a row
    try! csv.write(row: titleRowArray)
    
    // Write fields separately
    for item in dic {
        csv.beginNewRow()
        try! csv.write(field: item.key)
        
        for index in 1...langArray.count {
            if let value = item.value[langArray[index - 1]] {
                try! csv.write(field: value, quoted: true)
            } else {
                try! csv.write(field: "")
            }
        }
    }
    
    csv.stream.close()
    
    // Get a String
    let csvData = stream.property(forKey: .dataWrittenToMemoryStreamKey) as! NSData
    let outPath = Path.current + Path("out.csv")
    try! outPath.write(csvData as Data)
}



public func parseCSV(path: String) -> [String: Dictionary<String, String>]? {
    let stream = InputStream(fileAtPath: path)!
//    let csv = try! CSVReader(stream: stream)
//    while let row = csv.next() {
//        print("\(row)")
//    }
    
    var resultDic = [String: Dictionary<String, String>]()
    
    let csv = try! CSVReader(stream: stream, hasHeaderRow: true) // It must be true.
    
    let headerRow = csv.headerRow!
//    print("\(headerRow)")
    
    var keyword = ""
    while csv.next() != nil {
        for lang in headerRow {
            if lang == "KEYWORD" {
                keyword = csv[lang]!
            } else {
                if (resultDic[keyword] == nil) {
                    resultDic[keyword] = [lang: csv[lang]!]
                } else {
                    var newDic = [String: String]()
                    for originKey in (resultDic[keyword]?.keys)! {
                        newDic.updateValue(resultDic[keyword]![originKey]!, forKey: originKey)
                    }
                    newDic.updateValue(csv[lang]!, forKey: lang)
                    resultDic.updateValue(newDic, forKey: keyword)
                }
            }
        }
    }
    
    
    return resultDic;
}


//{翻译值:翻译}
public func getSingleCSV(path: String) -> [String: String]? {
    let stream = InputStream(fileAtPath: path)!
    var resultDic = [String: String]()
    let csv = try! CSVReader(stream: stream) // It must be true.
    
    
    while let row = csv.next() {
        if row.count >= 2 {
            resultDic[row[0]] = row[1]
        }
    }
    
    return resultDic;
}




public func toSingleCSVFile(dic: [String: String]){
    let stream = OutputStream(toMemory: ())
    let csv = try! CSVWriter(stream: stream)
    
    // Write fields separately
    for item in dic {
        csv.beginNewRow()
        try! csv.write(field: item.key)
        try! csv.write(field: item.value)
        
    }
    
    csv.stream.close()
    
    // Get a String
    let csvData = stream.property(forKey: .dataWrittenToMemoryStreamKey) as! NSData
    let outPath = Path.current + Path("result.csv")
    try! outPath.write(csvData as Data)
}



