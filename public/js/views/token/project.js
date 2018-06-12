$(document).ready(function() {
  $('#edit-project-button').on('click', function() {
    name = $('#project-title').text();
    desc = $('#project-desc').text();

    $('#project_title_input_edit').val(name);
    $('#project_description_input_edit').val(desc);
  });

  $('#form-edit-project-detail').on('submit', function() {
    name = $('#project_title_input_edit').val();
    desc = $('#project_description_input_edit').val();
    console.log('nama project' + name);
    console.log('desc project' + desc);

    $('#project-title').text(name);
    $('#project-desc').text(desc);

    $('#modal-edit-project').modal('hide');
    return false;   		
  });

  $('#form-edit-project-detail').on('submit', function() {
    name = $('#project_title_input_edit').val();
    desc = $('#project_description_input_edit').val();
    console.log('nama project' + name);
    console.log('desc project' + desc);

    $('#project-title').text(name);
    $('#project-desc').text(desc);

    $('#modal-edit-project').modal('hide');
    return false;   		
  });

  $('#request-table').on('click', 'tbody tr td a.edit-request', function() {
    // alert('shit')
  });

  $('#form-edit-request').on('submit', function() {
    $('#modal-edit-request').modal('hide');
    return false;
  });

  $('#request-table').on('click', 'tbody tr td a.delete-request', function() {
    // Obtaining row information from token-table
    id = $(this).closest('tr').find('input.request-id').val();
    new_action = '/request/delete/' + id
    // // Assign the value to modal
    $('#form-delete-request').attr('action', new_action);
    $('#request-delete-id').attr('value', id);
  }); 

  $('#form-delete-request').on('submit', function() {
    id = $('#request-delete-id').val();
    row_name = '#request-'+id
    jQuery(row_name).fadeOut(function(){
      jQuery(this).remove();
    });
    $('#modal-delete-request').modal('hide');
    return false;
  });  
});   
