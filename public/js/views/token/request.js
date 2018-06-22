$(document).ready(function() {
  $('#response-table').on('click', 'tbody tr td a.show-response', function() {
    alert('asu')
    code = $(this).closest('tr').find('input.response-status').val();
    header = $(this).closest('tr').find('input.response-header').val();
    body = $(this).closest('tr').find('input.response-body').val();
    // // Assign the value to modal
    $('#status_code_input').attr('value', code);
    document.getElementById('header_input').value = header;
    document.getElementById('body_input').value = body;        
  }); 

  $('#response-table').on('click', 'tbody tr td a.delete-response', function() {
    // Obtaining row information from token-table
    id = $(this).closest('tr').find('input.response-id').val();
    new_action = '/response/' + id + '/delete'
    // // Assign the value to modal
    $('#form-delete-response').attr('action', new_action);
    $('#response-delete-id').attr('value', id);
  }); 
});   
