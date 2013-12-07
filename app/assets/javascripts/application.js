// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.ui.dialog
//= require jquery.ui.draggable
//= require jquery.ui.resizable
//= require fullcalendar
//= require_tree .

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/resize"
    });
}

function showEventDetails(event){
    $('#event_time').html(event.desc_time);
	$('#event_project').html(event.desc_project);
	$('#event_remark').html(event.desc_remark);
	
	$('#event_desc').hide();
	$('#event_time').show();
    $('#event_project').show();
    $('#event_remark').show();
	
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Edit</a>");
    if (event.recurring) {
        title = event.title + " (Recurring)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")'>Delete All In Series</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")'>Delete All Future Events</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete</a>");
    }
	$('#edit_event').show();
    $('#delete_event').show();
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 650,
        close: function(event, ui) { $('#desc_dialog').dialog('destroy')}
        
    });
    
}


function editEvent(event_id){
    jQuery.ajax({
        data: 'id=' + event_id,
        dataType: 'script',
        type: 'get',
        url: "/events/edit"
    });
}

function deleteEvent(event_id, delete_all){
    if (confirm("Are you sure?")) {
      jQuery.ajax({
        data: 'id=' + event_id + '&delete_all='+delete_all,
        dataType: 'script',
        type: 'delete',
        url: "/events/destroy"
      });
	}
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Weekly':
            $('#period').html('Repeat Every ? Week');
            $('#frequency').show();
			$('#monthnum').show();
            break;
        case 'Monthly':
            $('#period').html('Repeat Every ? Month');
            $('#frequency').show();
			$('#monthnum').show();
            break;
        default:
            $('#frequency').hide();
			$('#monthnum').hide();
    }  
    
}


