var gulp = require('gulp');
var elm = require('gulp-elm');

function swallowError(err) {
    console.log(err.toString());
    this.emit('end');
}

gulp.task('elm', function() {
    return gulp.src('src/TrpTest.elm')
        .pipe(elm())
        .on('error', swallowError)
        .pipe(gulp.dest('public/javascripts/'));
});

gulp.task('default', function() {
    gulp.watch('src/*.elm', ['elm']);
});
