'use strict'
electron = require('electron')
app = electron.app
BrowserWindow = electron.BrowserWindow
mainWindow = undefined


# only for mac schisl
app.on 'window-all-closed', -> if process.platform != 'darwin' then app.quit()

# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
app.on 'ready', ->
  mainWindow = new BrowserWindow(
    width: 800
    height: 600)

  mainWindow.loadURL 'file://' + __dirname + '/index.html'
  mainWindow.webContents.openDevTools()
  mainWindow.on 'closed', -> mainWindow = null





exports.app = app
