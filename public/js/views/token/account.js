$(document).ready(function() {
  $('#form-edit-password').on('submit', function() {
    old = $('#old-password-edit-input').val();
    if (old == '') {
      $('#old-password-edit-input').closest('div').removeClass("has-success");            
      $('#old-password-edit-input').closest('div').addClass("has-danger");            
      $('#old-password-edit-input').next('div').show().text('Old password must be filled');            
    } else {
      $('#old-password-edit-input').closest('div').removeClass("has-danger");            
      $('#old-password-edit-input').closest('div').addClass("has-success");            
      $('#old-password-edit-input').next('div').hide();            
    }
    new_pass = $('#new-password-edit-input').val();
    if (new_pass == '') {
      $('#new-password-edit-input').closest('div').removeClass("has-success");            
      $('#new-password-edit-input').closest('div').addClass("has-danger");            
      $('#new-password-edit-input').next('div').show().text('New password must be filled');            
    } else {
      $('#new-password-edit-input').closest('div').removeClass("has-danger");            
      $('#new-password-edit-input').closest('div').addClass("has-success");            
      $('#new-password-edit-input').next('div').hide();           
    }
    conf_pass = $('#new-password-confirm-edit-input').val();
    if (conf_pass == '') {
      $('#new-password-confirm-edit-input').closest('div').removeClass("has-success");            
      $('#new-password-confirm-edit-input').closest('div').addClass("has-danger");            
      $('#new-password-confirm-edit-input').next('div').show().text('Confirm password must be filled');            
    } else {
      $('#new-password-confirm-edit-input').closest('div').removeClass("has-danger");            
      $('#new-password-confirm-edit-input').closest('div').addClass("has-success");            
      $('#new-password-confirm-edit-input').next('div').hide();            
    }
    if (conf_pass == '' || new_pass == '' || conf_pass == '') {
      return false
    }
    if (conf_pass != conf_pass) {
      return false
    }
    // if ( (newpass != '') && (new_pass != conf_pass) ) {
    //   $('#new-password-edit-input').closest('div').removeClass("has-success");            
    //   $('#new-password-edit-input').closest('div').addClass("has-danger");            
    //   $('#new-password-edit-input').next('div').show().text('New password must be same as Old Password');            
    //   $('#new-password-confirm-edit-input').closest('div').removeClass("has-success");            
    //   $('#new-password-confirm-edit-input').closest('div').addClass("has-danger");            
    //   $('#new-password-confirm-edit-input').next('div').show().text('New password must be same as Old Password');            
    // } else {
    //   $('#new-password-edit-input').closest('div').removeClass("has-danger");            
    //   $('#new-password-edit-input').closest('div').addClass("has-success");            
    //   $('#new-password-edit-input').next('div').hide();            
    //   $('#new-password-confirm-edit-input').closest('div').removeClass("has-danger");            
    //   $('#new-password-confirm-edit-input').closest('div').addClass("has-success");            
    //   $('#new-password-confirm-edit-input').next('div').hide();
    // }
  });
});   
