//
//  Panagram.swift
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

class Panagram {
  
  let consoleIO = ConsoleIO()
  
  func staticMode() {
    //    consoleIO.printUsage()
    
    //1
    let argCount = CommandLine.argc
    //2
    let argument = CommandLine.arguments[1]
    //3
    let (option, value) = getOption(argument.substring(from: argument.index(argument.startIndex, offsetBy: 1)))
    //4
    consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
  }
  
  func getOption(_ option: String) -> (option:OptionType, value: String) {
    return (OptionType(value: option), option)
  }
  
}
