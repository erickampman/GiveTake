//
//  GTManager.swift
//  GiveTake
//
//  Created by Eric Kampman on 4/2/24.
//

import Foundation

class GTManager<K: Hashable, V: Available> {
	var gtActors = [[K:GTActor<K,V>]]()
	
	init() {
		gtActors.append([K:GTActor<K,V>]())		// givers
		gtActors.append([K:GTActor<K,V>]())		// takers
	}
	
	//GTActor<String,BorrowableItem>(id: "Bill Bruford")
	public func addGTActor(_ id: K, type: GTRecordType) {
		gtActors[type.rawValue][id] = GTActor<K,V>(id: id)
	}
	
	public func getGTActor(_ id: K, type: GTRecordType) -> GTActor<K, V>? {
		for (k,v) in gtActors[type.rawValue] {
			if k == id {
				return v
			}
		}
		return nil
	}
	
	public func getGTActorCount(type: GTRecordType) -> Int {
		return gtActors[GTRecordType.give.rawValue].count
	}
	
	public func appendGTActorItem(_ id: K, type: GTRecordType, item: V) {
		gtActors[type.rawValue][id]?.appendItem(item)
	}
	
	// the Vs are copies!
	public func getGTActorItems(_ id: K, type: GTRecordType) -> [V]? {
		if nil == getGTActor(id, type: type) {
			return nil
		}
		
		var ret = [V]()
		for item in gtActors[type.rawValue][id]!.items {
			ret.append(item)
		}
		
		return ret
	}
	
	public func deleteMatchingItems(_ id: K, type: GTRecordType, closure: (V) -> Bool) {
		gtActors[type.rawValue][id]?.removeItems(closure: closure)
	}
}
