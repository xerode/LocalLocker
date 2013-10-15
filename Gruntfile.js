/*global module:false*/
module.exports = function(grunt) { 
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    clean: [ "bin/" ],

    copy: {
      dev: {
        files: [

          {
            expand: true,
            cwd: 'src',
            src: 'index.html',
            dest: 'bin'
          },

          {
            expand: true,
            cwd: 'lib/jquery/1.10.2',
            src: 'jquery-1.10.2.min.js',
            dest: 'bin/lib/jquery/1.10.2'
          },

        ]
      },
      release: {
        files: [
          {
            expand: true,
            cwd: 'src/js/libs',
            src: 'jquery.js',
            dest: 'bin/js/libs'
          }
        ]
      }
    },

    coffee: {

      plugin: {
        expand: true,
        cwd: 'src/coffee',
        src: '*.coffee',
        dest: 'bin/js',
        ext: '.js'
      },
      specs: {
        files: [ {
          expand: true,
          cwd: 'spec/coffee',
          src: '*.coffee',
          dest: 'spec/js',
          ext: '.js'
        }]
      },
      helpers : {
        files: [ {
          expand: true,
          cwd: 'spec/coffee/helpers/',
          src: '*.coffee',
          dest: 'spec/js/helpers/',
          ext: '.js'
        }]
      }

    },

    jasmine: {
      main: {
        src: [ 'bin/js/*.js' ],
        options: {
          specs: 'spec/js/**/*Spec.js',
          helpers: 'spec/js/helpers/**/*Helper.js',
          vendor: [ 'lib/jquery/1.10.2/jquery-1.10.2.min.js', 'spec/js/libs/jasmine-jquery.js' ]
        }
      }
    },

    uglify: {

      release: {
        files: [
          {
            expand: true,
            cwd: 'bin/js',
            src: ['**/*.js'],
            dest: 'bin/js',
            ext: '.js'
          },
        ],
      }

    },

    htmlmin: {

      release: {
        options: {
          removeComments: true,
          removeCommentsFromCDATA: true,
          collapseWhitespace: true,
          removeRedundantAttributes: true
        },
        files: {
          'bin/index.html': 'src/index.html'
        }
      }

    }

  });

  // Lib tasks.
  grunt.loadNpmTasks('grunt-growl');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');

  // Default and Build tasks
  grunt.registerTask( 'default', [ 'clean', 'copy:dev', 'coffee', 'jasmine' ] );
  grunt.registerTask( 'dev', [ 'clean', 'copy:dev', 'coffee', 'jasmine' ] );
  grunt.registerTask( 'release', [ 'clean', 'copy:release', 'coffee', 'uglify:release', 'htmlmin:release', 'jasmine' ] );

  // Travis CI task.
  // grunt.registerTask('travis', ['coffee', 'jasmine']);
};