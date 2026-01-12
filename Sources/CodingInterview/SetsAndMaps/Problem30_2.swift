/**
You've compiled a list of IP addresses of all the clients connected to your service and the username associated with each one. Assume all IPs are unique and username lengths are between 1 and 30. We say a username is being shared if it appears in two (or more) connections. Return the most shared username. In case of a tie, return any of them.
*/

public func mostSharedAccount(connections: [(ip: String, username: String)]) -> String {
    var frequencyMap = [String: Int]()
    var maxCount: (String, Int) = ("", 0)
    for connection in connections { 
        frequencyMap[connection.username, default: 0] += 1
        if let count = frequencyMap[connection.username], count > maxCount.1 {
            maxCount = (connection.username, count)
        }
    }
    return maxCount.0
}
