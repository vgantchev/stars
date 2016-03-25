var init_notices = function() {

  // SHOW_NOTICE
  function show_notice(wait, duration) {

    window.setTimeout((function(){
      var $notice = $("#notice-success");
      $notice.fadeIn();

      window.setTimeout((function(){
        $notice.fadeOut();
        $notice.find(".alert-success").html("");
      }), duration);
    }), wait);
  };

  // SHOW_NOTICE_ERROR
  function show_notice_error(wait, duration) {

    window.setTimeout((function(){
      var $notice = $("#notice-error")
      $notice.fadeIn();

      window.setTimeout((function(){
        $notice.fadeOut();
        $("#notice-error .alert-error").html("");
      }), duration);
    }), wait);
  };

  if ($("#notice-success .alert-success").html().length) {
    if ($("#notice-success .alert-success").html().trim()) {
      show_notice(100, 5000);
    }
  }

  if ($("#notice-error .alert-error").html().length) {
    if ($("#notice-error .alert-error").html().trim()) {
      show_notice_error(100, 5000);
    }
  }

};

$(document).ready(function(){
  init_notices();
});