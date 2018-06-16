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
    // just for example
    // once we success, we need to pass the header key and value from the input
    // var api_url = 'https://api.github.com/repos/bhimasta/pinaple-sas'
    var api_url = $('#new_request_url_input').val();
    var PUT_HEADERS = {};
    jQuery("#header-table tbody tr").each(function() {
      key = jQuery(this).find("input.header-key").val();
      val = jQuery(this).find("input.header-value").val();
      PUT_HEADERS[key] = val;
      console.log(key+": "+val);                        
    });
    $('#header-parameter-input').val(JSON.stringify(PUT_HEADERS))
    console.log(JSON.stringify(PUT_HEADERS));                        
    // return false;

    // 'Access-Control-Allow-Origin': '*'
    // crossDomain: true,
    $.ajax({
      type: "GET",
      dataType: 'json',
      url: api_url,
      crossDomain:true,      
      headers: PUT_HEADERS,
       success: function(data, textStatus, xhr)
       {
        // status code 200 ==> save on field 'status_code'
        alert('jancuk');
        console.log('status');
        console.log(xhr.status);
        // alert(xhr.status) 

        // show response header ==> save on field 'header_secure'
        console.log('response header');
        console.log(xhr.getAllResponseHeaders());
        // ...

        // return the content => save on field 'body_secure'
        x = JSON.stringify(data, undefined, 4);
        console.log('success data')
        console.log(x)
        document.getElementById('status-result').value = xhr.status; // put the result on textarea with id = 'api-results'
        document.getElementById('header-result').value = xhr.getAllResponseHeaders(); // put the result on textarea with id = 'api-results'
        document.getElementById('api-result').value = x; // put the result on textarea with id = 'api-results'

        // show save button
        $('#m_create_request_submit').show()        
       },
       error: function (data, textStatus, xhr)
       {  
        alert('asu')
        // status code 404 ==> save on field 'status_code'
        console.log('status')
        console.log(data.status)
        // alert(xhr.status) 

        // show response header ==> save on field 'header_secure'
        console.log('response header')
        console.log(data.getAllResponseHeaders())
        // ...

        // return the content => save on field 'body_secure'
        x = JSON.stringify(data, undefined, 4);
        console.log('success data')
        console.log(x)
        document.getElementById('status-result').value = xhr.status; // put the result on textarea with id = 'api-results'
        document.getElementById('header-result').value = xhr.getAllResponseHeaders(); // put the result on textarea with id = 'api-results'
        document.getElementById('api-result').value = x; // put the result on textarea with id = 'api-results'

        // show save button
        $('#m_create_request_submit').hide()            
       },
    });        
    $('#preview-col').show();    
    return false;
  });
});   
