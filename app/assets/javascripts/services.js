$(document).on("turbolinks:load ready", function(){
  $('.loader').hide();

    $('.button').click(function(){
       $('form').hide();
       $('.loader').show();
    });

});
