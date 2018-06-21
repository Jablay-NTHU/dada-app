$(document).ready(function() {
  $('#response-table').on('click', 'tbody tr td a.delete-response', function() {
    // Obtaining row information from token-table
    id = $(this).closest('tr').find('input.response-id').val();
    new_action = '/response/' + id + '/delete'
    // // Assign the value to modal
    $('#form-delete-response').attr('action', new_action);
    $('#response-delete-id').attr('value', id);
  }); 
});   
