$(document).ready(function() {
  $('#response-table').on('click', 'tbody tr td a.delete-response', function() {
    // Obtaining row information from token-table
    id = $(this).closest('tr').find('input.response-id').val();
    new_action = '/response/' + id + '/delete'
    // // Assign the value to modal
    $('#form-delete-response').attr('action', new_action);
    $('#response-delete-id').attr('value', id);
  });

  $('#response-table').on('click', 'tbody tr td a.show-response', function() {
    status = $(this).closest('tr').find('input.inner_response_status_code').val();
    header = $(this).closest('tr').find('input.inner_response_header').val();
    body = $(this).closest('tr').find('input.inner_response_body').val();
    $('#status_code_input').val(status);    
    document.getElementById('header_input').value = header;
    document.getElementById('body_input').value = body;        
  });  
});   
