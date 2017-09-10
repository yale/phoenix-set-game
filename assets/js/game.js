import $ from 'jquery';

$(() => {
  $(".card").click(function() {
    $(this).toggleClass("selected");
  });
});
