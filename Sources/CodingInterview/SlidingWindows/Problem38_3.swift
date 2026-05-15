/**
Problem prompt:
We are given an array, best_seller, with the title of the most sold book for each day over a given period. We are also given a number k with 1 ≤ k ≤ len(sales).

We need to return whether there is any k-day period where each day has a different best-selling title.


Example 1:
best_seller = ["book3", "book1", "book3", "book3", "book2", "book3", "book4",
"book3"]
k = 3

Output: True
There is a 3-day period without a repeated value: ["book2", "book3", "book4"]

Example 2:
best_seller = ["book3", "book1", "book3", "book3", "book2", "book3", "book4",
"book3"]
k = 4

Output: False
There are no 4-day periods without a repeated value

Example 3:
best_seller = ["book1", "book2", "book3"]
k = 3

Output: True
The entire array has no repeated values
Constraints:

The length of best_seller is at most 10^6
Each book title has length at most 100
1 <= k <= len(best_seller)
*/

func hasUniqueBestSellerPeriod(in bestSellers: [String], days k: Int) -> Bool {
    guard bestSellers.count >= k else { return false }
    var r = 0, l = 0
    var uniqueBooks = [String: Int]()
    while r < bestSellers.count {
        uniqueBooks[bestSellers[r], default: 0] += 1
        r += 1 
        if r - l == k {
            if uniqueBooks.count == k { 
                return true 
            } else {
                uniqueBooks[bestSellers[l]] = uniqueBooks[bestSellers[l]]! - 1
                if uniqueBooks[bestSellers[l]] == 0 {
                    uniqueBooks[bestSellers[l]] = nil
                }
                l += 1
            }
        }
    }
    return false
}
