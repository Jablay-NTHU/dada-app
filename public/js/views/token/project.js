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

  $('#request-table').on('click', 'tbody tr td a.edit-request', function() {
    id = $(this).closest('tr').find('input.request-id').val();
    title = $(this).closest('tr').find('td a.request-title').text();
    description = $(this).closest('tr').find('td i.request-description').text();
    interval = $(this).closest('tr').find('td.request-interval').text();
    $('#edit_request_title_input').val(title);    
    $('#edit_request_desc_input').val(description);    

    if (interval == 'once') {$('#edit-int-once').attr('checked','checked');} else {$('#edit-int-once').removeAttr('checked');}
    if (interval == 'daily') {$('#edit-int-daily').attr('checked','checked');} else {$('#edit-int-daily').removeAttr('checked');}
    if (interval == 'weekly') {$('#edit-int-weekly').attr('checked','checked');} else {$('#edit-int-weekly').removeAttr('checked');}
    if (interval == 'monthly') {$('#edit-int-monthly').attr('checked','checked');} else {$('#edit-int-monthly').removeAttr('checked');}  

    if (interval != "once") {
      $('#date-start-div').show()
      $('#date-end-div').show()
      $('#date-start-input').show()
      $('#date-end-input').show()
    } else {
      $('#date-start-div').hide()
      $('#date-end-div').hide()
      $('#date-start-input').hide()
      $('#date-end-input').hide()
    }

    new_action = '/request/' + id + '/edit'
    // // Assign the value to modal
    $('#form-edit-request').attr('action', new_action);

  });

  $('#request-table').on('click', 'tbody tr td a.delete-request', function() {
    // Obtaining row information from token-table
    // alert('mantab')
    id = $(this).closest('tr').find('input.request-id').val();
    new_action = '/request/' + id + '/delete'
    // // Assign the value to modal
    $('#form-delete-request').attr('action', new_action);
    $('#request-delete-id').attr('value', id);
  }); 

  $('#request-table').on('click', 'tbody tr td a.show-response', function() {
    code = $(this).closest('tr').find('td input.last-body-status').val();
    header = $(this).closest('tr').find('td input.last-body-header').val();
    body = $(this).closest('tr').find('td input.last-body-content').val();
    // Assign the value to modal
    $('#status_code_input').attr('value', code);
    document.getElementById('header_input').value = header;
    document.getElementById('body_input').value = body;        
  }); 

  // $('#form-delete-request').on('submit', function() {
  //   id = $('#request-delete-id').val();
  //   row_name = '#request-'+id
  //   jQuery(row_name).fadeOut(function(){
  //     jQuery(this).remove();
  //   });
  //   $('#modal-delete-request').modal('hide');
  //   return false;
  // });

  $('#collaborator-list').on('click', 'tbody tr td a.delete-collaborator', function() {
    // Obtaining row information from token-table
    username = $(this).closest('tr').find('input.collaborator-username').val();
    // alert(username)
    // // Assign the value to modal
    $('#collaborator-delete-username').attr('value', username);
  }); 
});   
