electron = require 'electron'
path = require 'path'
url = require 'url'

reload = require('electron-reload')(
  __dirname, ignored: [
      path.join(__dirname, 'images/*.*')
      path.join(__dirname, 'temp/*.*')
    ]
  )


# Module to control application life.
app = electron.app
# Module to create native browser window.
BrowserWindow = electron.BrowserWindow
# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the JavaScript object is garbage collected.
mainWindow = undefined
# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
# Some APIs can only be used after this event occurs.

createWindow = ->
  # Create the browser window.
  mainWindow = new BrowserWindow(
    width: 800
    height: 600
    webSecurity: false
    )
  # and load the index.html of the app.
  mainWindow.loadURL url.format(
    pathname: path.join(__dirname, 'index.html')
    protocol: 'file:'
    slashes: true)
  # Open the DevTools.
  # mainWindow.webContents.openDevTools()
  # Emitted when the window is closed.
  mainWindow.on 'closed', ->
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null


app.on 'ready', createWindow
# Quit when all windows are closed.
app.on 'window-all-closed', ->
  if process.platform != 'darwin'
    app.quit()

app.on 'activate', ->
  if mainWindow == null
    createWindow()
