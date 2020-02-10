//
//  ConsoleDebugLogger.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 10/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation


class ConsoleDebugLogger {

    static let shared = ConsoleDebugLogger()
    
    let formatter: DateFormatter
    
    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "y/MM/dd H:m:ss.SSSS"
    }
    
    func log(file: String = #file, line: Int = #line, function: String = #function, message: String) {
        
        var fileName = file.split(separator: "/").last!.split(separator: ".").first!
        
        var functionName = function.split(separator: "(").first!
        
        print("[\(formatter.string(from: Date())) \(fileName).\(functionName) (\(line))]: \(message)")
    }
    
}
