$(document).ready(function() {  
  $('#add-parameter-row').on('click', function() {
    $('#header-table tbody').append(
      '<tr>'+
        '<td><input type="text" class="form-control m-input header-key" name="header-key[]" placeholder="Key"></td>'+               
        '<td><input type="text" class="form-control m-input header-value" name="header-value[]" placeholder="Value"></td>'+   
        '<td><a href="#" role="button" class="m-nav__link remove-header"><i class="m-nav__link-icon flaticon-delete-1"></i></a></td>'+
      '</tr>'
    );        
    return false;
  });

  $('#header-table').on('click', 'tbody tr td a.remove-header', function() {
    $(this).closest('tr').fadeOut(function(){
      $(this).remove();
    });
    return false;
  });

  $('input.interval').change(function() { 
    val = $(this).val()
    if (val != "Once") {
      $('#date-start-div').show();
      $('#date-end-div').show();
    } else {
      $('#date-start-div').hide();
      $('#date-end-div').hide();
    }
    return false;
  });

  $('#try-launch').on('click', function() {
    $('#preview-col').show();    
    return false;
  });
});   
