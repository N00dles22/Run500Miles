// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// set a different alias for jQuery so we don't clash with prototype
var $jq = jQuery.noConflict();

$jq.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$jq(document).ready(function(){
	var currentDate = new Date();
	$jq('#activity_activity_date').datepicker({ defaultDate: +0, showAnim: 'slideDown', maxDate: new Date() });
	
	//$jq('#progress').progressbar( { value: 1 } );
	
	$jq("#leaderboards").tabs();
	
	$jq(".radio_ui").buttonset();
	
	$jq(".accordian_ui").accordion( { fillSpace: false });
	
	$jq("#activity-form").dialog({
	autoOpen: false,
	height: 'auto',
	width: 500,
	modal: true,
	buttons: {
		"Log Activity": function () {
			$jq( this ).dialog( "close" );
		},
		"Cancel": function () {
			$jq( this ).dialog( "close" );
		}
	},
	close: function() {
		//$jq( this ).dialog( "close" );
	}

	});
	
});

// This is used to toggle div visibilities
function setDivVisibility(showItem, hideItems) {
  $jq("#" + showItem).toggle(true);
  for (var i = 0; i < hideItems.length; i++) {
    $jq("#" + hideItems[i]).toggle(false);
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

// Google Analytics Stuff--------------------------
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-28163203-1']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
//------------------------------------------------