//
//  ErrorProtocol.swift
//  Shortlist
//
//  Created by Mark Wong on 8/4/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

protocol ErrorProtocol: Error {
	var localizedDescription: String { get }
}
