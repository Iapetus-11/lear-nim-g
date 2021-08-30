import random; randomize()
import nigui; app.init()

var
    window = newWindow()
    control = newControl()

window.width = 500
window.height = 500

window.add(control)

control.widthMode = WidthMode_Fill
control.heightMode = HeightMode_Fill

control.onDraw = proc (event: DrawEvent) =
    let canvas = control.canvas

    canvas.areaColor = rgb(232, 232, 232)
    canvas.fill()


    var points: seq[tuple[x: int, y: int]]

    canvas.areaColor = rgb(0, 255, 50)
    let endIdx = ((window.width + window.height) / 100).toInt

    for i in 0..endIdx:
        if i == 1:
            canvas.areaColor = rgb(255, 0, 255)
        elif i == endIdx:
            canvas.areaColor = rgb(255, 10, 10)

        let point: tuple[x: int, y: int] = (rand(window.width - 50), rand(window.height - 50))
        canvas.drawEllipseArea(point.x - 5, point.y - 5, 10, 10)
        points.add(point)
        
    for p1 in points:
        for p2 in points:
            canvas.drawLine(p1.x, p1.y, p2.x, p2.y)


window.show()
app.run()
