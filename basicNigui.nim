import nigui

app.init()

var
    window = newWindow("New Window Test")
    container = newLayoutContainer(Layout_Vertical)
    horizonOne = newLayoutContainer(Layout_Horizontal)
    buttonOne = newButton("Button Uno")
    buttonTwo = newButton("Button DOS")
    quitButton = newButton("quit")
    textArea = newTextArea()

window.width = 600.scaleToDpi
window.height = 400.scaleToDpi

window.iconPath = "petus.png"

window.add(container)
container.add(horizonOne)

horizonOne.add(buttonOne)
horizonOne.add(buttonTwo)
horizonOne.add(quitButton)

container.add(textArea)

buttonOne.onClick = proc(event: ClickEvent) =
    textArea.addLine("[button one]: sussy baka")

buttonTwo.onClick = proc(event: ClickEvent) =
    textArea.addLine("[button two]: sus frog")

quitButton.onClick = proc(event: ClickEvent) =
    app.quit()

window.show()
app.run()
