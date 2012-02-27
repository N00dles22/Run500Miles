
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery(document).ready(function(){
	var currentDate = new Date();
	jQuery('#activity_activity_date').datepicker({ defaultDate: +0, showAnim: 'slideDown', maxDate: new Date() });
	
	jQuery("#leaderboards").tabs();
	
	jQuery(".radio_ui").buttonset();
	
	jQuery(".accordian_ui").accordion( { fillSpace: false });
	
	//jQuery('#activity_activity_date') = '12/16/2012'
	jQuery("#activity-form").dialog({
	autoOpen: false,
	height: 'auto',
	width: 500,
	modal: true,
	buttons: {
		"Log Activity": function () {
			jQuery( this ).dialog( "close" );
		},
		"Cancel": function () {
			jQuery( this ).dialog( "close" );
		}
	},
	close: function() {
		//jQuery( this ).dialog( "close" );
	}

	});
	
});

// This is used to toggle div visibilities
function setDivVisibility(showItem, hideItems) {
  document.getElementById(showItem).style.display = 'block';
  for (var i = 0; i < hideItems.length; i++) {
    document.getElementById(hideItems[i]).style.display = 'none';
  }
}


//<!-- Dynamic Version by: Nannette Thacker -->
//<!-- http://www.shiningstar.net -->
//<!-- Original by :  Ronnie T. Moore -->
//<!-- Web Site:  The JavaScript Source -->
//<!-- Use one function for multiple text areas on a page -->
//<!-- Limit the number of characters per textarea -->
//<!-- Begin
function textCounter(field,cntfield,maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
    field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else
    cntfield.value = maxlimit - field.value.length;
}

// Google Analytics Stuff
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-28163203-1']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
