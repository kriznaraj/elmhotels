var gulp = require('gulp');
var elm = require('gulp-elm');
var fs = require('fs');
var modifyFile = require('gulp-modify-file');

function getViewContent(moduleName) {
return `doctype html
html
  head
    meta(charset='UTF-8')
    title Travel Republic Hotel Search
    script(type='text/javascript', src='javascripts/${moduleName}.js')
    link(rel='stylesheet', href='stylesheets/style.css')
  body
  script(type='text/javascript').
    var app = Elm.${moduleName}.fullscreen();`
}

function swallowError(err) {
    console.log(err.toString());
    this.emit('end');
}

gulp.task('trptest', function() {
    fs.writeFile('views/layout.jade', getViewContent('TrpTest'));
    gulp.src("styles/**.*")
      .pipe(gulp.dest('public/stylesheets/'));
    return gulp.src('src/TrpTest.elm')
        .pipe(elm())
        .on('error', swallowError)
        .pipe(gulp.dest('public/javascripts/'));
});

gulp.task('tryelm', function() {
    fs.writeFile('views/layout.jade', getViewContent('TryElm'));
    return gulp.src('src/TryElm.elm')
        .pipe(elm())
        .on('error', swallowError)
        .pipe(gulp.dest('public/javascripts/'));
});

gulp.task('default', function() {
    gulp.watch('src/*.elm', ['elm']);
});

gulp.task('trptest-no', function() {
    gulp.src("styles/**.*")
      .pipe(gulp.dest('public/stylesheets/'));
    return gulp.src('src/TrpTest.elm')
        .pipe(elm())
        .on('error', swallowError)
        .pipe(gulp.dest('public/javascripts/'));
});