import Commander
import PathKit


let updateCMD = command(
    Argument<String>("dirpath", description: ".String file parent dir"),
    Argument<String>("csv", description: "translated csv file path")
) { dirpath, csv in
    
    //寻找String
    let currentPath = Path(dirpath)
    print("searching......")
    let stringPaths = searchStringFiles(currentPath: currentPath)
    if stringPaths == nil || stringPaths!.isEmpty {
        print("no search found")
        return;
    }
    print("search complet")
    
    //确认语言对应路径
    var langStringDic = [String: Array<Path>]()
    for stringPath in stringPaths! {
        if stringPath.parent().extension == "lproj" {
            let lang = stringPath.parent().lastComponentWithoutExtension
            
            let tempArray = langStringDic[lang]
            if (tempArray != nil) {
                var addArray = [Path]()
                addArray = addArray + tempArray!
                addArray.append(stringPath)
                langStringDic.updateValue(addArray, forKey: lang)
            } else {
                var addArray = [stringPath]
                langStringDic.updateValue(addArray, forKey: lang)
            }
        }
    }
    
    //优先中文简体>英文
    var langStringArray = langStringDic.keys.sorted(by: { (langOne, langTwo) -> Bool in
        if langOne  == "zh-Hans" {
            return true
        } else if langTwo  == "zh-Hans" {
            return false
        } else if langOne  == "en" {
            return true
        } else if langTwo  == "en" {
            return false
        } else {
            return true
        }
    })
    
    //导入字典
    var langEditDic = [String: Dictionary<String, String>]()    //{key值:{语言:翻译}}
    print("improt String file......")
    for langKey in langStringArray {
        let paths = langStringDic[langKey]
        for path in paths! {
            let readDic = parseString(path: path, lang: langKey)    //{key值:{语言:翻译}}
            
            for key in readDic!.keys {
                let originDic = langEditDic[key]
                if (originDic == nil) {
                    langEditDic.updateValue(readDic![key]!, forKey: key)
                } else {
                    var newDic = [String: String]()
                    for originKey in (originDic?.keys)! {
                        newDic.updateValue(originDic![originKey]!, forKey: originKey)
                    }
                    newDic.updateValue(readDic![key]![langKey]!, forKey: langKey)
                    langEditDic.updateValue(newDic, forKey: key)
                }
            }
        }
    }
    
    print("improt String file complet")
    
    
    
    //CSV->导入CSV字典
    print("improt CSV file......")
    
    let readCSVDic = parseCSV(path: csv)    //{key值:{语言:翻译}}
    
    print("improt CSV file complet")
    
    
    
    //对比差异
    var newItemsDic = [String: Dictionary<String, String>]()    //{key值:{语言:翻译}}
    var modifyItemsDic = [String: Dictionary<String, String>]()    //{key值:{语言:翻译}}
    
    for item in readCSVDic! {
        if let originItem = langEditDic[item.key] {
            if originItem != readCSVDic![item.key]! {
                for lang in langStringArray {
                    if (originItem[lang] == nil && item.value[lang] != nil && !item.value[lang]!.isEmpty) {   //新增
                        newItemsDic[item.key] = [lang:item.value[lang]!]
                    } else if (originItem[lang] != nil && item.value[lang] != nil && !item.value[lang]!.isEmpty && originItem[lang] != item.value[lang]) {    //修改
                        modifyItemsDic[item.key] = [lang:item.value[lang]!]
                    }
                }
            }
        }
    }
    
    print("new: \(newItemsDic)")
    print("modify: \(modifyItemsDic)")
    
    
    
    //更新到String文件
    //{语言:{key值:翻译}} 路径
    
    
}

