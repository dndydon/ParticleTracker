//
//  main.swift
//  ParticleTracker
//
//  Created by Don Sleeter on 7/28/17.
//  Copyright © 2017 Don Sleeter. All rights reserved.
//

import Foundation


let panagram = Panagram()
// panagram.staticMode()

if CommandLine.argc < 2 {
  //TODO: Handle interactive mode
} else {
  panagram.staticMode()
}
