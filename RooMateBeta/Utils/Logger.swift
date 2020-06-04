//
//  Logger.swift
//  RooMate
//
//  Created by Ron Hirsch on 29/05/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//
// test
import Foundation
let log_pad =  20
let logger = Logger()

enum MessageType
{
    case log_error
    case log_warning
    case log_debug
    case log_fatal
}

class Logger
{
    private func getType(type: MessageType) -> String
    {
        switch type {
        case .log_error:
            return "ERROR"
        case .log_warning:
            return "WARNING"
        case .log_debug:
            return "DEBUG"
        case .log_fatal:
            return "FATAL"
        }
    }
    
    private func printLoggerString(toPrint: String , type: MessageType , file: String, line: Int, function: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss "
        let timestamp = dateFormatter.string(from: Date())
        let typeString = getType(type: type)
        var ans: String = timestamp + "[\(typeString)]".padding(toLength: log_pad, withPad: " ", startingAt: 0)
        var className = (file as NSString).lastPathComponent
        className = (className as NSString).deletingPathExtension
        ans = ans + className.padding(toLength: 30, withPad: " ", startingAt: 0) + " : "
        var newFunction = function
        if function.contains("(")
        {
            newFunction = function.split{$0 == "("}.map(String.init)[0]
            ans = ans + newFunction.padding(toLength: 30, withPad: " ", startingAt: 0) + " : "
            ans = ans + "\(line)".padding(toLength: 5, withPad: " ", startingAt: 0) + " : "
            ans = ans + "\(toPrint)"
        }
        return ans
    }
    
    func error(message: String ,file: String = #file, line: Int = #line, function: String = #function)
    {
        print(printLoggerString(toPrint: message, type: .log_error, file: file, line: line, function: function))
    }
    
    func fatal(message: String ,file: String = #file, line: Int = #line, function: String = #function)
    {
        print(printLoggerString(toPrint: message, type: .log_fatal, file: file, line: line, function: function))
    }
    
    func warning(message: String ,file: String = #file, line: Int = #line, function: String = #function)
    {
        print(printLoggerString(toPrint: message, type: .log_warning, file: file, line: line, function: function))
    }
    
    func debug(message: String ,file: String = #file, line: Int = #line, function: String = #function)
    {
        print(printLoggerString(toPrint: message, type: .log_debug, file: file, line: line, function: function))
    }
}


