function setEqualHeight(columns) {
    var tallestcolumn = 0;
    columns.each(
        function () {
            currentHeight = $(this).outerHeight();
            if (currentHeight > tallestcolumn) {
                tallestcolumn = currentHeight;
            }
        }
    );
    columns.css("min-height",tallestcolumn);
}

if ($('.flexslider').length) {
  $(window).load(function() {
    $('.flexslider').flexslider();
  });
}
  
$(function() {
  $.each($('.tweets').find('li'), function(){
    $(this).html($(this).text().replace(/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig, '<a href="$1" target="_blank">$1</a>').replace(/(^|\s)@(\w+)/g, '$1<a href="http://www.twitter.com/$2" target="_blank">@$2</a>'));   
    $(this).on('click', function() {
        console.log(test);
    });
  });
  
  if($('.mod').length) {
    setEqualHeight($('.mod'));
  }
});