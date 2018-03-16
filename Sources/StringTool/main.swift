import Commander
import PathKit
import Foundation
import CSV


let group = Group()


//  生成Commander


//  更新Commander


group.addCommand("generate", "generate csv file from .string", generateCMD)
group.addCommand("translate", "translate csv file to .string", updateCMD)
group.addCommand("combine", "combineCMD two files by first column", combineCMD)
group.run("0.1.0 beta")

