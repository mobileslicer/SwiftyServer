//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


struct Check<In: Point>: Point {

	typealias Enviroment = In.Enviroment

	func perform(on request: inout Enviroment) throws -> In.Output {
		let outPrev = try upstream.perform(on: &request)

		if self.check(outPrev, request) {
			return outPrev
		} else {
			throw ValidationError.notValid(message: self.message)
		}
	}

	enum ValidationError: Error {
		case notValid(message: String)
	}

	typealias Output = In.Output

	var upstream: In
	var check: (In.Output, Enviroment) -> Bool
	var message: String

	public init(upstream: In, check: @escaping (In.Output, Enviroment) -> Bool, message: String) {
		self.upstream = upstream
		self.check = check
		self.message = message
	}
}

extension Point {
	func check(message: String, _ f: @escaping (Self.Output, Enviroment) -> Bool) -> Check<Self> {
		return Check<Self>(upstream: self, check: f, message: message)
	}
}


