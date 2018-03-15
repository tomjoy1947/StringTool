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



