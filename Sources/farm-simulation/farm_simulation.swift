import Raylib

@main
struct farm_simulation {
    static func main() {
        let screenWidth: Int32 = 800
        let screenHeight: Int32 = 800

        Raylib.initWindow(screenWidth, screenHeight, "Farm Simulation")
        Raylib.setTargetFPS(30)

        while Raylib.windowShouldClose == false {
            // update
            

            // draw
            Raylib.beginDrawing()
            Raylib.clearBackground(.rayWhite)
            Raylib.endDrawing()
        }
        Raylib.closeWindow()
    }
}
