
// google visualization guage
google.load('visualization', '1', {packages:['gauge']});
google.setOnLoadCallback(initGauge);
var colors = getColorScheme();
var gauge_chart;
var gauge_data;
var gauge_options;
var gauge_year_val;
var gauge_week_val;
//var button;
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



