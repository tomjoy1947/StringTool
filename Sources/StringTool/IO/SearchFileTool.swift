import Foundation
import PathKit


public func searchStringFiles(currentPath:Path) -> [Path]?{
    do {
        var result = [Path]();
        let children = try currentPath.children()
        for childPath in children {
            if childPath.isFile && childPath.extension == "strings" {
                result.append(childPath)
            } else if childPath.isDirectory {
                if let subresult = searchStringFiles(currentPath: childPath) {
                    result = result + subresult;
                }
            }
        }
        
        return result;
    } catch {
        return nil;
    }
}
