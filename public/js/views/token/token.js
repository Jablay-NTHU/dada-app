$(document).ready(function() {
  $('#token-table').on('click', 'tbody tr td a.edit-token', function() {
    // Obtaining row information from token-table
    id = $(this).closest('tr').find('input.token-id').val();
    name = $(this).closest('tr').find('td.token-name').text();
    value = $(this).closest('tr').find('td.token-value').text();
    description = $(this).closest('tr').find('td.token-description').text();
    new_action = '/token/edit/' + id
    // Assign the value to modal 
    $('#token-edit-id').attr('value', id);
    $('#form-edit-token').attr('action', new_action);
    $('#name_input_edit').val(name);
    $('#value_input_edit').val(value);
    $('#description_input_edit').val(description);
  });

  $('#token-table').on('click', 'tbody tr td a.delete-token', function() {
    // Obtaining row information from token-table
    id = $(this).closest('tr').find('input.token-id').val();
    new_action = '/token/delete/' + id
    // Assign the value to modal 
    $('#form-delete-token').attr('action', new_action);
    $('#token-delete-id').attr('value', id);
  }); 
  
  $('#form-new-token').on('submit', function() {
    id = '101'
    name = $('#name_input_new').val();
    value = $('#value_input_new').val();
    description = $('#description_input_new').val();

    $('#token-table tbody').append(
      '<tr>'+
        '<input class="token-id" type="hidden" value="row-'+id+'">'+
        '<td class="token-name">'+name+'</td>'+		
        '<td class="token-value">'+value+'</td>'+		
        '<td class="token-description">'+description+'</td>'+		
        '<td>'+
        '<a href="#" class="edit-token" role="button" data-toggle="modal" data-target="#modal-edit-token"><i class="flaticon-edit-1"></i></a>'+
        '<span>&nbsp;&nbsp;</span>'+
        '<a href="#" class="delete-token" role="button" data-toggle="modal" data-target="#modal-delete-token"><i class="flaticon-delete-1"></i></a>'+
        '</td>'+		
      '</tr>'		
      );

    $('#name_input_new').val("");
    $('#value_input_new').val("");
    $('#description_input_new').val("");

    $('#modal-new-token').modal('hide');
        
    return false;
  });

  $('#form-edit-token').on('submit', function() {
    name = $('#name_input_edit').val();
    value = $('#value_input_edit').val();
    description = $('#description_input_edit').val();

    id = $('#token-edit-id').val();
    row_name = '#row-'+id
    $(row_name).find('td.token-name').text(name)
    $(row_name).find('td.token-value').text(value)
    $(row_name).find('td.token-description').text(description)
    $('#modal-edit-token').modal('hide');

    return false;   		
  });

  $('#form-delete-token').on('submit', function() {
    id = $('#token-delete-id').val();
    row_name = '#row-'+id
    $(row_name).fadeOut(function(){
      jQuery(this).remove();
    });
    $('#modal-delete-token').modal('hide');
    return false;   		
  });
});   
