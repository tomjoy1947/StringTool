import Commander

let updateCMD = command(
    Argument<String>("dirpath", description: ".String file parent dir"),
    Argument<String>("csv", description: "translated csv file path"),
    Flag("saveresult", default:false, description: "save new translated csv")
) { dirpath, csv, flag in
    
    //寻找String-》确认语言-〉导入字典
    //CSV-》导入CSV字典
    //对比更新
    //根据Flag导出CSV
}

