'use strict'
electron = require 'electron'
browserWindow = require 'browser-window'
app = electron.app

# only for mac schisl
app.on 'window-all-closed', -> if process.platform != 'darwin' then app.quit()

# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
app.on 'ready', ->
  mainWindow = new browserWindow
    width: 800
    height: 800

  mainWindow.loadURL 'file://' + __dirname + '/main.html'
  mainWindow.webContents.openDevTools()

  mainWindow.on 'closed', -> canvasWindow = null





exports.app = app
