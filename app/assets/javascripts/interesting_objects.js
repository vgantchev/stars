$(document).ready(function() {
  var object_url = $('#js-data').data('object-url');
  var rate_url = $('#js-data').data('rate-url');

  var update_averages = function(){
    $.get(object_url, function(data){
      var average_rating = parseFloat(data['average_rating']).toFixed(1) + " / 5";
      var average_value_estimate = parseFloat(data['average_value_estimate']).toFixed(0);
      $('#average_rating').html(average_rating);
      $('#average_value_estimate').html(accounting.formatMoney(average_value_estimate, "€ ", 0, " "));
    });
  };

  $('#user_star').raty({
    score: $('#js-data').data('user-rating'),
    path: '/assets',
    click: function(score, evt) {
      $.post(rate_url, { score: score } )
        .done(function(e) {
          update_averages();
          $('#notice-success').children('.alert-success').html(e.msg);
          init_notices();
        })
        .fail(function(xhr) {
          $('#notice-error').children('.alert-error').html($.parseJSON(xhr.responseText).errors[0]);
          init_notices();
        }
      );
    }
  });

  $("#estimate_value").on("ajax:success", function(e, data, status, xhr) {
    $('#notice-success').children('.alert-success').html($.parseJSON(xhr.responseText).msg);
    update_averages();
    init_notices();
  }).on("ajax:error", function(e, xhr, status, error) {
    $('#notice-error').children('.alert-error').html($.parseJSON(xhr.responseText).errors[0]);
    init_notices();
  });
});