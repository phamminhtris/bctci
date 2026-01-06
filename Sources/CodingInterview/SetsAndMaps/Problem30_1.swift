//
//  Problem30_1.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/5/26.
//

/**
 You've compiled a list of IP addresses of all the clients connected to your service and the username associated with each one. Assume all IPs are unique and username lengths are between 1 and 30. We say a username is being shared if it appears in two connections.
 If usernames are being shared, return an IP of any of them. Otherwise, return an empty string.
 
 Example 1: connections = [("203.0.113.10", "mike"), ("298.51.100.25", "bob"),
 ("292.0.2.5", "mike"), ("203.0.113.15", "bob2")]
 Output: "203.0.113.10". User "mike" is connected from that IP and "292.0.2.5",
 so "292.0.2.5" would also be a valid output.

 Example 2: connections = [("111.0.0.0", "mike"), ("111.0.0.1", "mike"),
 ("111.0.0.2", "bob"), ("111.0.0.3", "bob")]
 Output: "111.0.0.0". Any of the IPs would be a valid output.

 Example 3: connections = [("111.0.0.0", "mike"), ("111.0.0.1", "mike2"),
 ("111.0.0.2", "mike3"), ("111.0.0.3", "mike4")]
 Output: ""
 */

public func sharedUsername(connections: [(ip: String, username: String)]) -> String {
    var seenUsernames = Set<String>()
    for connection in connections {
        if seenUsernames.contains(connection.username) {
            return connection.ip
        }
        seenUsernames.insert(connection.username)
    }
    return ""
}
