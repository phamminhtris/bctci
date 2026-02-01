import Foundation
/**
You are given a non-empty array of circles, circles, where each circle is specified by its center coordinates (x, y) and its radius r. Your task is to determine whether the circles are nested. For the circles to be considered nested, one of the following conditions must be met:

There is a single circle.
One circle completely surrounds all the others (without touching boundaries), and the other circles are themselves nested (this is a recursive definition).
Write a function that returns a boolean indicating whether the circles are nested.

Example 1: circles = [
    ((4, 4), 5),  # Circle with center (4, 4) and radius 5
    ((8, 4), 2)   # Circle with center (8, 4) and radius 2
]
Output: false. Neither circle is surrounded by the other.

Example 2: circles = [
    ((5, 3), 3),
    ((5, 3), 2),
    ((4, 4), 5)
]
Output: true. The third circle contains all the first and second circles, and
the first circle contains the second circle.

Example 3: circles = [((5, 3), 3)]
Output: true. A single circle is considered nested.
*/

struct Circle {
    let center: (x: Int, y: Int)
    let radius: Int
}

func areCirclesNested(_ circles: [Circle]) -> Bool {
    guard !circles.isEmpty else { return false }
    if circles.count == 1 { return true }
    let sortedCircles = circles.sorted(by: { $0.radius > $1.radius })
    
    var index = 0 
    while index <= circles.count - 2 { 
        let firstCircle = sortedCircles[index]
        let secondCircle = sortedCircles[index + 1]
        if !contains(c1: firstCircle, c2: secondCircle) {
            return false
        }
        index += 1
    }
    return true
}

func contains(c1: Circle, c2: Circle) -> Bool {
    let (x1, y1) = c1.center
    let (x2, y2) = c2.center
    let distanceBetweenCenter = sqrt(pow(Double(x1 - x2), 2) + pow(Double(y1 - y2), 2))
    return distanceBetweenCenter + Double(c2.radius) < Double(c1.radius)
}