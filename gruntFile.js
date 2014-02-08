module.exports = function (grunt) {

  var fs = require("fs");
  var path = require("path");
  var _ = require("underscore");

  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-recess');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jade');

  // Default task.
  grunt.registerTask('default', ['jshint','build']);
  grunt.registerTask('debug', [
    'clean',
    'jade:debug',
    'copy:html',
    'coffee', 
    'recess:build',
    'copy:assets'
  ]);

  grunt.registerTask('build', [
    'clean', 
    'jade:debug',
    'copy:html',
    'coffee',
    'recess:build',
    'copy:assets'
  ]);

  grunt.registerTask('release', [
    'clean', 
    'jade:release',
    'copy:html',
    'coffee',
    'jshint',
    'copy:assets'
  ]);

  // Print a timestamp (useful for when watching)
  grunt.registerTask('timestamp', function() {
    grunt.log.subhead(Date());
  });

  // Project configuration.
  grunt.initConfig({

    distdir: 'dist',

    pkg: grunt.file.readJSON('package.json'),

    banner:
    '/*\n' +
    ' * Last-Modified: <%= grunt.template.today("yyyy-mm-dd hh:MM") %>\n' +
    ' */\n\n',
    src: {
      coffee: [
        'src/**/*.coffee'
      ],
      js: [
        'src/**/*.js'
      ]
    },

    clean: {
      all : ['<%= distdir %>/*']
    },

    copy: {
      assets: {
        files: [{ dest: '<%= distdir %>', src : '**', expand: true, cwd: 'src/assets/' }]
      },
      html: {
        files: [
          { dest: '<%= distdir %>/', src : '**/*.html', expand: true, cwd: 'src' }
        ]
      }
    },

    jade: {
      debug: {
        options: {
          pretty: true,
          data: {
            debug: true
          }
        },
        files: [
          { 
            dest: '<%= distdir %>/', 
            src : '**/*.jade', 
            expand: true, 
            cwd: 'src', 
            rename: function(destBase, destPath) {
              console.log(destBase);
              console.log(destPath);
              return destBase + destPath.replace(/\.jade$/, '.html');
            } 
          }
        ]
      },

      release: {
        options: {
          data: {
            debug: false
          }
        },
        files: [
          { 
            dest: '<%= distdir %>/', 
            src : '**/*.jade', 
            expand: true, 
            cwd: 'src', 
            rename: function(destBase, destPath) {
              console.log(destBase);
              console.log(destPath);
              return destBase + destPath.replace(/\.jade$/, '.html');
            } 
          }
        ]
      }
    },


    coffee: {
      compile: {
        options: {
          bare: true
        },
        files: {
          '<%= distdir %>/app.js': ['<%= src.coffee %>'] // compile and concat into single file
        }
      }
    },

    recess: {
      build: {
        files: [
          { '<%= distdir %>/app.css' : 'src/app.less' }
        ],
        options: {
          compile: true
        }
      },
      min: {
        files: [
          { '<%= distdir %>/app.css' : 'src/app.less' }
        ],
        options: {
          compile: true,
          compress: true
        }
      }
    },
    watch:{
      all: {
        files:[
          'src/**/*',
          'gruntFile.js'
        ],
        tasks:['default','timestamp']
      },
      build: {
        files:[
          'src/**/*',
          'gruntFile.js'
        ],
        tasks:['build','timestamp']
      }
    },
    jshint:{
      files:['gruntFile.js', '<%= src.js %>'],
      options:{
        curly:true,
        eqeqeq:true,
        immed:true,
        latedef:true,
        newcap:true,
        noarg:true,
        sub:true,
        boss:true,
        eqnull:true,
        globals:{}
      }
    }
  });

};