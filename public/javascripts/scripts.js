$(document).ready(function() {
  var $body, $formT, $head, $ini, $ini_top, $win, finder, responsive;
  $body = $('body');
  $win = $(window);
  $head = $('header');
  if ($body.hasClass('Home')) {
    $ini = $('form#search');
    finder = function() {
      return $.post('/find', {
        search: $ini.find('input').val()
      }, function(err, res) {
        if (err) {
          return console.error(err);
        }
        return console.log(res);
      });
    };
    $ini.find('input').blur(finder).end().find('button').click(finder);
  }
  if ($body.hasClass('Produto') || $body.hasClass('Lugar') || $body.hasClass('Produto')) {
    $ini = $('#item-header .item-info');
  }
  $ini_top = $ini.offset().top - 10;
  responsive = function() {
    if ($win.width() > 600) {
      $win.on('scroll', function(e) {
        if (($win.scrollTop() - $ini_top) > 0) {
          return $head.addClass('mobile');
        } else {
          return $head.removeClass('mobile');
        }
      });
      return $head.find('input').addClass('input-lg').end().find('button').addClass('btn-lg');
    } else {
      $win.off('scroll');
      return $head.addClass('mobile').find('input').removeClass('input-lg').end().find('button').removeClass('btn-lg');
    }
  };
  responsive();
  $win.resize(responsive);
  $formT = $('.form-tolerance');
  if ($formT.length) {
    return $formT.find('input, textarea').each(function() {
      if ($(this).val().length) {
        return $(this).addClass('filled');
      } else {
        return $(this).removeClass('filled');
      }
    }).blur(function() {
      if ($(this).val().length) {
        return $(this).addClass('filled');
      } else {
        return $(this).removeClass('filled');
      }
    });
  }
});
