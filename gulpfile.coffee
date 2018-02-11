gulp = require('gulp')
shell = require('gulp-shell')
packageJson = require('./package.json')
electron = require('gulp-electron')

gulp.task 'package', ->
  gulp.src('').pipe gulp.dest('')


gulp.task 'default', [  ], ->
  gulp.watch('client/**/*.*', ['all']);
  # gulp.watch('index.html', ['copy']);
  # gulp.watch('styles/**/*.less', ['styles']);
  # gulp.watch('images/**', ['images']);
  #
  # livereload.listen();
  env = process.env
  env.NODE_ENV = 'development'
  if process.platform == 'win32'
    gulp.src('').pipe shell([ 'cache\\electron.exe .' ], env: env)
  else
    gulp.src('').pipe shell([ './cache/Electron.app/Contents/MacOS/Electron .' ], env: env)
  return
