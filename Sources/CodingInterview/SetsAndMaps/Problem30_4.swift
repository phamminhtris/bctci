//
//  Problem30_4.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/12/26.
//

/**
 Our company runs an online game where the terms of service state that each person can only have one account. We have a list of usernames and the (unordered) list of IP addresses that they have ever connected from. We say two users are suspected of belonging to the same person if the list of IPs is the same. Return whether any two lists contain the exact same set of IPs.
 
 Example 1: users = [
   ("mike", ["203.0.3.10", "208.51.0.5", "52.0.2.5"]),
   ("bob", ["111.0.0.10", "222.0.0.5", "222.0.0.8"]),
   ("bob2", ["222.0.0.5", "222.0.0.8", "111.0.0.10"])
 ]
 Output: True. Users "bob" and "bob2" have the same IPs.

 Example 2: users = [
   ("alice", ["1.1.1.1"]),
   ("bob", ["2.2.2.2"])
 ]
 Output: False. No two users have the same IPs.

 Example 3: users = []
 Output: False. There are no users.
*/
import Foundation

public func multiAccountCheating(_ users: [(String, [String])]) -> Bool {
    var ipSets = Set<[String]>()
    for user in users {
        let sortedIps = user.1.sorted()
        if ipSets.contains(sortedIps) {
            return true
        } else {
            ipSets.insert(sortedIps)
        }
    }
    return false
}
