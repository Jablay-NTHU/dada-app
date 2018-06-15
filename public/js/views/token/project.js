$(document).ready(function() {
  $('#project-list').on('click', 'div a.delete-project', function() {
    // Obtaining row information from token-table
    id = $(this).closest('ul').find('input.project-id').val();
    new_action = '/project/' + id + '/delete'
    // // Assign the value to modal
    $('#form-delete-project').attr('action', new_action);
  });

  $('#project-list').on('click', 'div a.leave-project', function() {
    // Obtaining row information from token-table
    id = $(this).closest('ul').find('input.project-id').val();
    new_action = '/project/' + id + '/leave'
    // // Assign the value to modal
    $('#form-leave-project').attr('action', new_action);
  });

  $('#project-list').on('click', 'div a.edit-project', function() {
    name = $(this).closest('div.proj').find('div h3.project-title').text();
    desc = $(this).closest('div.proj').find('div.proj-body span.project-description').text();
    $('#project_title_input_edit').val(name);
    $('#project_description_input_edit').val(desc);

    // Obtaining row information from token-table
    id = $(this).closest('ul').find('input.project-id').val();
    new_action = '/project/' + id + '/edit/list'
    // // Assign the value to modal
    $('#form-edit-project').attr('action', new_action);
  });
  
  $('#edit-project-button').on('click', function() {
    name = $('#project-title').text();
    desc = $('#project-desc').text();
    $('#project_title_input_edit').val(name);
    $('#project_description_input_edit').val(desc);
  });

  // $('#form-edit-project-detail').on('submit', function() {
  //   name = $('#project_title_input_edit').val();
  //   desc = $('#project_description_input_edit').val();

  //   $('#project-title').text(name);
  //   $('#project-desc').text(desc);

  //   $('#modal-edit-project').modal('hide');
  //   return false;   		
  // });

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
