import Commander
import PathKit


let combineCMD = command(
    Argument<String>("keystrings", description: "key-value string file path"),
    Argument<String>("langcsv", description: "first column lang csv file path"),
    Flag("strings", default:false, description: "out strings file.default csv")
) { keystrings, langcsv, outStrings in
    
    //导入字典
    var langEditDic: [String: [String]]   //{翻译值:[key]}
    print("improt String file......")
    
    let stringPath = Path(keystrings)
    langEditDic = getStringValueKeys(path: stringPath)!
    
    print("improt String file complet")
    
    
    
    //CSV->导入CSV字典
    print("improt CSV file......")
    
    var csvDic = getSingleCSV(path: langcsv)    //{翻译值:翻译}
    
    print("improt CSV file complet")
    
    
    //合并
    var outputDic = [String: String]()    //{翻译值:[key]}
    for tranKey in langEditDic.keys {
        if let tran = csvDic![tranKey] {
            for oringinKey in langEditDic[tranKey]! {
                outputDic[oringinKey] = tran
            }
        }
    }
    
    
//    print("\(outputDic)")
    //输出 {key:翻译}
    if outStrings {
        var outString = ""
        for item in outputDic {
            outString = outString + "\"" + "\(item.key)" +  "\" = \"" + "\(item.value)" + "\";\n"
        }
        
        let outPath = Path.current + Path("out.strings")
        try! outPath.write(outString)
    } else {
        toSingleCSVFile(dic: outputDic)
    }
    
    
    
}


