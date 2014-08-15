module.exports = function(grunt) {
  // Grunt config
  grunt.initConfig({
    concat: {
        options: {
            separator: ';'
        },
        dist: {
            src: ['build/public/static/js/lib.js', 'build/public/static/js/user.js', 'build/public/static/js/main.js'],
            dest: 'build/public/static/js/clientside.js'
        }
    },
    copy: {
        main: {
            files: [
                {
                    expand: true,
                    cwd: 'bower_components/bootstrap/dist',
                    src: ['**/*.min.*', 'fonts/**'],
                    dest: 'build/public/static/'
                },
                {
                    expand: true,
                    cwd: 'bower_components/fontawesome/',
                    src: ['css/*.min.css', 'fonts/*'],
                    dest: 'build/public/static/'
                },
                {
                    expand: true,
                    cwd: 'bower_components/cryptico',
                    src: ['*.js'],
                    dest: 'build/public/static/js/'
                },
                {
                    expand: true,
                    cwd: 'bower_components/jquery/dist',
                    src: ['jquery.min.js'],
                    dest: 'build/public/static/js/'
                },
                {
                    expand: true,
                    cwd: 'bower_components/hint.css/',
                    src: ['hint.min.css'],
                    dest: 'build/public/static/css/'
                },
                {
                    expand: true,
                    cwd: 'bower_components/markdown/lib',
                    src: ['markdown.js'],
                    dest: 'build/public/static/js/'
                },
                {
                    expand: true,
                    cwd: "src/",
                    src: ["*.js", "routes/*.js", "views/*.html"],
                    dest: "build/"
                },
                {
                    expand: true,
                    cwd: ".",
                    src: ["conf/*.json"],
                    dest: "build/"
                },
                {
                    expand: true,
                    cwd: "src/static",
                    src: ["css/*.css"],
                    dest: "build/public/static"
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
            options: {
                bare: true,
            },
            expand: true,
            flatten: false,
            cwd: 'src/static/coffee',
            src: ['**/*.coffee'],
            dest: 'build/public/static/js',
            ext: '.js'
        }
    },
    // Allows to deploy the app
    run: {
        deploy: {
            options: {
                    cwd: "build"
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
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-run');
    
    // Task definition
    grunt.registerTask('default', ['coffee', 'copy', 'concat'])
    grunt.registerTask('deploy', ['default', 'run:deploy'])
}
