livereload = require 'electron-livereload'

electron = livereload.server()

module.exports = (grunt) ->

  grunt.initConfig
    livereload :
      options:
        base: 'client'
      files: ['client/**/*']
    watch:
      options:
        nospawn: true # !IMPORTANT!
      client:
        files: ['client/**/*.coffee'], tasks: ['reload-electron'], reload:true
      server:
        files: ['clientt/**/*.coffee'], tasks: ['restart-electron']

    grunt.registerTask 'start', (env) ->
      electron.start()
      grunt.task.run ['watch', 'livereload']

    grunt.registerTask 'restart-electron', ->
      electron.restart()

    grunt.registerTask 'reload-electron', ->
      electron.reload()

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-livereload')

