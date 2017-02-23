var gulp = require('gulp');
var elm = require('gulp-elm');

function swallowError(err) {
    console.log(err.toString());
    this.emit('end');
}

gulp.task('trptest', function() {
    gulp.src("styles/**.*")
      .pipe(gulp.dest('public/stylesheets/'));
    return gulp.src('src/TrpTest.elm')
        .pipe(elm())
        .on('error', swallowError)
        .pipe(gulp.dest('public/javascripts/'));
});

gulp.task('default', function() {
    gulp.watch('src/*.elm', ['elm']);
});
