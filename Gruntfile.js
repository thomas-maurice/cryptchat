module.exports = function(grunt) {

  // Grunt config
  grunt.initConfig({
    copy: {
      main: {
        files: [
          {
            expand: true,
            cwd: 'bower_components/bootstrap/dist',
            src: ['**/*.min.*', 'fonts/**'],
            dest: 'build/app/public/static/'
          },
          {
            expand: true,
            cwd: 'bower_components/fontawesome/',
            src: ['css/*.min.css', 'fonts/*'],
            dest: 'build/app/public/static/'
          },
          {
            expand: true,
            cwd: 'bower_components/cryptico',
            src: ['*.js'],
            dest: 'build/app/public/static/js/'
          },
          {
            expand: true,
            cwd: 'bower_components/jquery/dist',
            src: ['jquery.min.js'],
            dest: 'build/app/public/static/js/'
          },
          {
            expand: true,
            cwd: "src/",
            src: ["*.js", "routes/*.js", "views/*.html"],
            dest: "build/app/"
          },
          {
            expand: true,
            cwd: ".",
            src: ["conf/*.json"],
            dest: "build/app/"
          },
          {
            expand: true,
            cwd: "src/static",
            src: ["css/*.css"],
            dest: "build/app/public/static"
          },
        ]  
      }
    },
    clean: {
      build: [
          'build'
      ],
      static: [
          'bower_components'
      ],
      modules: [
          'node_modules',
      ]
    },
    coffee: {
        compile: {
            files: {
                "build/app/public/static/js/main.js": "src/static/coffee/main.coffee"
            }
        }
    },
    // Allows to deploy the app
    run: {
      deploy: {
        options: {
          cwd: "build/app"
        },
        cmd: "node",
        args: [
          'cryptchat.js'
        ]
      }
    }
  })

  // Loads the grunt tasks
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-run');
  
  // Task definition
  grunt.registerTask('default', ['coffee', 'copy'])
  grunt.registerTask('deploy', ['default', 'run:deploy'])
}
