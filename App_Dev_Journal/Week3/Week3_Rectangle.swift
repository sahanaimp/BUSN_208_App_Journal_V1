/*Week 3: Anything
Create a struct named Rectangle with properties for width and height, and a functions that returns perimeter, area, as well as other computations.
*/

struct Rectangle {
    var width: Double
    var height: Double

    //calculate the area
    var area: Double {
        return width * height
    }

    //calculate the perimeter
    var perimeter: Double {
        return 2 * (width + height)
    }

    //is the rectangle a square
    func isSquare() -> Bool {
        return width == height
    }

    // Function to create a new rectangle with doubled dimensions
    func doubled() -> Rectangle {
        return Rectangle(width: width * 2, height: height * 2)
    }

    // Function to compare two rectangles by area
    func isLargerThan(_ other: Rectangle) -> Bool {
        return self.area > other.area
    }

    // Function to describe the rectangle
    func description() -> String {
        return "Rectangle with width \(width) and height \(height). Area: \(area). Perimeter: \(perimeter)."
    }
}
