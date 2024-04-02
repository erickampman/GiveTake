//
//  GTActor.swift
//  GiveTake
//
//  Created by Eric Kampman on 4/2/24.
//

import Foundation

enum GTRecordType: Int {
	case give = 0
	case take = 1
}

enum GTRecordAvailability {
	case unavailable
	case available
}

protocol Available {
	typealias Availability = GTRecordAvailability
	var available: Availability { get set }
}


class GTActor<K: Hashable, V: Available> {
	let id: K
	var items = [V]()
	
	init(id: K) {
		self.id = id
	}
	
	var count: Int {
		items.count
	}
	
	public func appendItem(_ item: V) {
		items.append(item)
	}
	
	public func removeItems(closure: (V) -> Bool) {
		var indices = Set<Int>()
		for i in 0..<items.count {
			if closure(items[i]) {
				indices.insert(i)
			}
		}
		for i in stride(from: items.count-1, through: 0, by: -1) {
			if indices.contains(i) {
				items.remove(at: i)
			}
		}

	}
}
