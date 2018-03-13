import Foundation


let configCMD = command(
    Option("projectDir", default: "", description: "The number of times to print."),
    Option("workSpace", default: "", description: "The number of times to print."),
    Option("output", default: "./output", description: "The number of times to print.")
) { src, xmlsDir, output in
    
}
