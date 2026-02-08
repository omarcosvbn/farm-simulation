import Raylib

@main
struct farm_simulation {
    static func main() {
        let screenWidth: Int32 = 800
        let screenHeight: Int32 = 800

        Raylib.initWindow(screenWidth, screenHeight, "Farm Simulation")
        Raylib.setTargetFPS(30)

        let seed: UInt32 = 1
        Raylib.setRandomSeed(seed)
        print("Seed: \(seed)")

        struct SeededGenerator: RandomNumberGenerator {
            private var state: UInt64
            init(seed: UInt64) { self.state = seed == 0 ? 0xdead_beef : seed }
            mutating func next() -> UInt64 {
                var x = state
                x ^= x >> 12
                x ^= x << 25
                x ^= x >> 27
                state = x
                return x &* 2685821657736338717
            }
        }

        var rng = SeededGenerator(seed: UInt64(seed))

        let W = 50 //tiles in width
        let H = 50 //tiles in height
        let TILE = 16 //value in pixels

        let MAX_FOREST = 20
        let MIN_FOREST = 4

        let RIVER_MIN_LENGTH = 5
        let RIVER_MAX_LENGTH = 20
        let RIVER_COUNT = 30

        var grid = Array(repeating: Array(repeating: 0, count: W), count: H)

        let directions: [(dx: Int, dy: Int)] = [(1, 0), (-1, 0), (0, 1), (0, -1)]

        func inBounds(_ x: Int, _ y: Int) -> Bool {
            x >= 0 && x < W && y >= 0 && y < H
        }

        func adjacentToRiver(_ x: Int, _ y: Int) -> Bool {
            for d in directions {
                let nx = x + d.dx
                let ny = y + d.dy
                if inBounds(nx, ny), grid[ny][nx] == 2 { return true }
            }
            return false
        }

        func nearRiver(_ x: Int, _ y: Int, radius: Int = 3) -> Bool {
            for dy in -radius...radius {
                for dx in -radius...radius {
                    let nx = x + dx
                    let ny = y + dy
                    if inBounds(nx, ny), grid[ny][nx] == 2 { return true }
                }
            }
            return false
        }

        func river() {
            let desiredLength = Int.random(in: RIVER_MIN_LENGTH...RIVER_MAX_LENGTH, using: &rng)
            let maxAttempts = 20
            for _ in 0..<maxAttempts {
                var x = Int.random(in: 0..<W, using: &rng)
                var y = Int.random(in: 0..<H, using: &rng)
                var dir = Int.random(in: 0...3, using: &rng)
                var positions: [(Int, Int)] = []

                for i in 0..<desiredLength {
                    if !inBounds(x, y) || grid[y][x] != 0 { break }
                    positions.append((x, y))

                    if i >= 3 && Bool.random(using: &rng) {
                        dir = (dir + [1, 2].randomElement(using: &rng)!) % 4
                    }

                    x += directions[dir].dx
                    y += directions[dir].dy
                }

                if positions.count >= RIVER_MIN_LENGTH {
                    for (px, py) in positions { grid[py][px] = 2 }
                    return
                }
            }

            let fx = Int.random(in: 0..<W, using: &rng)
            let fy = Int.random(in: 0..<H, using: &rng)
            if grid[fy][fx] == 0 { grid[fy][fx] = 2 }
        }

        func forest(sx: Int, sy: Int) {
            var stack: [(Int, Int)] = [(sx, sy)]
            var count = 1
            grid[sy][sx] = 1

            while !stack.isEmpty && count < MAX_FOREST {
                let (x, y) = stack.remove(at: Int.random(in: 0..<stack.count, using: &rng))
                    for d in directions.shuffled(using: &rng) {
                    let nx = x + d.dx
                    let ny = y + d.dy
                        if inBounds(nx, ny), grid[ny][nx] == 0, !adjacentToRiver(nx, ny) {
                        grid[ny][nx] = 1
                        stack.append((nx, ny))
                        count += 1
                        if count >= MAX_FOREST { break }
                    }
                }
            }

            if count < MIN_FOREST {
                for (x, y) in stack {
                    grid[y][x] = 0
                }
            }
        }

        func addForest() {
            for y in 0..<H {
                for x in 0..<W {
                    if grid[y][x] == 0 && nearRiver(x, y) && !adjacentToRiver(x, y) {
                        if Int.random(in: 0...30, using: &rng) == 0 {
                            forest(sx: x, sy: y)
                        }
                    }
                }
            }
        }

        for _ in 0..<RIVER_COUNT { river() }
        addForest()

        while Raylib.windowShouldClose == false {
            Raylib.beginDrawing()
            Raylib.clearBackground(.rayWhite)
            for y in 0..<H {
                for x in 0..<W {
                    var color: Color = .darkGray
                    if grid[y][x] == 2 { color = .red }
                    if grid[y][x] == 1 { color = .blue }
                    Raylib.drawRectangle(
                        Int32(x * TILE), Int32(y * TILE), Int32(TILE - 1), Int32(TILE - 1), color)
                }
            }
            Raylib.endDrawing()
        }
        Raylib.closeWindow()
    }
}
