//
//  main.swift
//  ParticleTracker
//
//  Created by Don Sleeter on 7/28/17.
//  Copyright © 2017 Don Sleeter. All rights reserved.
//

import Foundation


let app = ParticleTracker()
app.commandLineMode()

if CommandLine.argc < 2 {
  //TODO: Handle interactive mode
} else {
  app.commandLineMode()
}
