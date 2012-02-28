
$jq(function() {
	$jq('#rbYearMPH,#rbWeekMPH').click(function() {
		var thisIDSelector = "#" + this.id;
		var params = $jq(thisIDSelector).data("yearweekparams");
		var showDiv = params[0];
		var hideDivs = params[1];
		var timespan = params[2];
		
		setDivVisibility(showDiv, hideDivs);
		changeGauge(-1, timespan);
	})
	
	$jq("#rbYearRun,#rbYearWalk,#rbYearOverall,#rbWeekRun,#rbWeekWalk,#rbWeekOverall").click(function() {
		var thisIDSelector = "#" + this.id;
		var params = $jq(thisIDSelector).data("walkrunparams");
		var newvalue = params[0];
		var timespan = params[1];
		
		changeGauge(newvalue, timespan);
	})
})

// google visualization api
google.load('visualization', '1', {packages:['gauge', 'corechart']});
google.setOnLoadCallback(initCharts);
var colors = getColorScheme();

var line_chart;
var line_data;
var line_options;

var gauge_chart;
var gauge_data;
var gauge_options;
var gauge_year_val;
var gauge_week_val;

function initCharts() {
	initGauge();
	//initLine();
}

function initGauge() {
  gauge_data = new google.visualization.DataTable();
  gauge_data.addColumn('string', 'Label');
  gauge_data.addColumn('number', 'Value');
  gauge_data.addRows([
    ['MPH', 0]
  ]);

  gauge_options = {
    width: 200, height: 200,
    redFrom: 12, redTo: 14,
    yellowFrom:9, yellowTo: 12, max:14,
	majorTicks: ['0', '2', '4', '6', '8', '10', '12', '14'],
    minorTicks: 2, animation: { duration: 1000, easing: 'out' } , 
	yellowColor: '#FFFFFF', // colors[1]
	redColor: '#FFFFFF' //colors[0]
  };
  gauge_chart = new google.visualization.Gauge(document.getElementById('avgmph'));
  gauge_chart.draw(gauge_data, gauge_options);
  
  var rbYear = document.getElementById('rbYearRun');
  var rbWeek = document.getElementById('rbWeekRun');
  rbWeek.click();
  rbYear.click();
}

function initLine() {
  line_data = new google.visualization.DataTable();
  line_data.addColumn('string', '');
  line_data.addColumn('number', 'Run Speed');
  line_data.addColumn('number', 'Walk Speed');
  line_data.addColumn('number', 'Run/Walk Speed');
  
  line_data.addRows([
	['hello', 20, 30, 40],
	['goodbye', 50, 40, 30],
	['stop it', 10, 70, 60]
  ]);
  
  line_options = {
    title: 'Speeds',
	width: 600, height: 240,
	hAxis: { title: 'Activity Date' },
	vAxis: { title: 'Speed (mph)' }
  }
  
  line_chart = new google.visualization.LineChart(document.getElementById('speedlinechart'));
  line_chart.draw(line_data, line_options);
}
	  
function drawGaugeChart() {
	gauge_chart.draw(gauge_data, gauge_options);
}
	  
function changeGauge(newValue, timeSpan) {
  if (newValue == -1) {
    if (timeSpan == "year") {
	  newValue = gauge_year_val;
	} else {
	  newValue = gauge_week_val;
	}
  } else {
    if (timeSpan == "year") {
	  gauge_year_val = newValue;
	} else {
	  gauge_week_val = newValue;
	}
  }
  gauge_data.setValue(0, 1, newValue);
  drawGaugeChart();
}

function getColorScheme() {
  var currentDate = new Date();
  var month = currentDate.getMonth() + 1;
  var colors = ['#0000FF', '009999', '669999'];
  switch (month){
    case 1:
	  colors = ['#0000FF', '009999', '669999'];
	  break;
	case 2:
	  colors = ['#800000', '#A31947', '#9933FF'];
	  break;
	case 3:
	  colors = ['#006600', '#B8B800', '#33CC33'];
	  break;
	case 4:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 5:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 6:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 7:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 8:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 9:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 10:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 11:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
	case 12:
	  //colors = ['#0000FF', '009999', '669999'];
	  break;
  }
  
  return colors;
}



