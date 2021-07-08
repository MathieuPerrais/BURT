//
//  Logger.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/3/21.
//

import Foundation
import os

let loggerPersistence = Logger(subsystem: "com.mathieuperrais.burt", category: "Persistence")
let loggerRepository = Logger(subsystem: "com.mathieuperrais.burt", category: "Repository")
let loggerNetwork = Logger(subsystem: "com.mathieuperrais.burt", category: "Network")
let loggerUI = Logger(subsystem: "com.mathieuperrais.burt", category: "UI")
