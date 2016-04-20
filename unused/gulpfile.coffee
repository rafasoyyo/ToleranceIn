
work_route = './'
dist_route = './public/'

gulp = require 'gulp'
less = require 'gulp-less'
livereload = require 'gulp-livereload'
autoprefixer = require 'gulp-autoprefixer'
 
gulp.task('less', ->
    gulp.src( work_route + 'less/*.less')
    .pipe(less({ }))
    .pipe(autoprefixer({
        browsers: ['last 2 versions']
        cascade: false
    }))
    .pipe(gulp.dest( dist_route + 'stylesheets/'))
    # .pipe(livereload())
)

# // Watcher
gulp.task('watcher', ->

  livereload.listen()
  gulp.watch( work_route + 'less/**/*.less', ['less'] )
)

gulp.task('default', ['less', 'watcher']);