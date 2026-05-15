/**
Problem prompt:
We are given an array, best_seller, with the title of the most sold book for each day over a given period. We are also given a number k with 1 ≤ k ≤ len(sales).

We need to return whether there is any k-day period where every day has the same best-selling title.

Example 1:
best_seller = ["book3", "book1", "book3", "book3", "book2"]
k = 3

Output: False
No three consecutive days have the same best seller.

Example 2:
best_seller = ["book3", "book1", "book3", "book3", "book2"]
k = 2

Output: True
Days 3-4 have the same best seller "book3".

Example 3:
best_seller = ["book1", "book2", "book1"]
k = 2

Output: False
No two consecutive days have the same best seller.

Example 4:
best_seller = ["book1", "book1", "book1"]
k = 3

Output: True
The entire array has the same best seller.
Constraints:

The length of best_seller is at most 10^6
Each book title has length at most 100
1 <= k <= len(best_seller)
*/

func hasSameBestSellerPeriod(in bestSellers: [String], days k: Int) -> Bool {
    guard bestSellers.count >= k else { return false }
    var r = 0, l = 0
    var bestSellerCount = [String: Int]()
    while r < bestSellers.count {
        bestSellerCount[bestSellers[r], default: 0] += 1
        r += 1 
        if r - l == k {
            if bestSellerCount.count == 1 { 
                return true 
            } else { 
                let bookToRemove = bestSellers[l]
                bestSellerCount[bookToRemove]! -= 1
                if bestSellerCount[bookToRemove] == 0 { 
                    bestSellerCount[bookToRemove] = nil
                }
                l += 1
            }
        }
    }
    return false
}

func hasSameBestSellerPeriodWithResettingWindow(in bestSellers: [String], days k: Int) -> Bool {
    var r = 0, l = 0
    while r < bestSellers.count {
        let canGrow = r == 0 || bestSellers[l] == bestSellers[r] 
        if canGrow {
            r += 1
            if r - l == k {
                return true
            }
        } else {
            l = r 
        }
    }
    return false
}
