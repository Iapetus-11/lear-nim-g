import std/random
import nigui

randomize()
app.init()

var
    window = newWindow()
    control = newControl()

window.width = 500
window.height = 500

window.add(control)

control.widthMode = WidthMode_Fill
control.heightMode = HeightMode_Fill

control.onDraw = proc (event: DrawEvent) =
    var c = "r"

    while true:
        let canvas = control.canvas

        canvas.areaColor = rgb(0, 0, 0)
        canvas.fill()

        case c:
        of "r":
            canvas.textColor = rgb(255, 0, 0)
            c = "g"
        of "g":
            canvas.textColor = rgb(0, 255, 0)
            c = "b"
        else:
            canvas.textColor = rgb(0, 0, 255)
            c = "r"

        canvas.fontSize = 96
        canvas.fontFamily = "Impact"
        canvas.drawText("SUS", 150, 150)

        app.sleep(1)


window.show()
app.run()
