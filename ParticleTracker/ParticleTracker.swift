//
//  ParticleTracker.swift
//  ParticleTracker
//
//  Created by Don Sleeter on 7/28/17.
//  Copyright © 2017 Don Sleeter. All rights reserved.
//

import Foundation

enum OptionType: String {
  case palindrome = "p"
  case anagram = "a"
  case help = "h"
  case unknown
  
  init(value: String) {
    switch value {
    case "a": self = .anagram
    case "p": self = .palindrome
    case "h": self = .help
    default: self = .unknown
    }
  }
}

class ParticleTracker {
  
  let consoleIO = ConsoleIO()
  
  func commandLineMode() {
    consoleIO.printUsage()
    
    //1
    let argCount = CommandLine.argc
    //2
    let argument = CommandLine.arguments.dropFirst()
    //let argument = CommandLine.arguments[1]
    //3
    let args = argument.split(separator: " ")
    
//    let (option, value) = getOption(argument[.from(argument.startIndex, offsetBy: 1)..<index])
    
    let (option, value) = getOption(String(describing: args))
    //4
    consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
  }
  
  func getOption(_ option: String) -> (option:OptionType, value: String) {
    return (OptionType(value: option), option)
  }
  
}


