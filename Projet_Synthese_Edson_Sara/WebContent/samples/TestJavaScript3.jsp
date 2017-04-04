<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>amStock Example</title>
		<link rel="stylesheet" href="../amcharts/style.css" type="text/css">

		<script src="../amcharts/amcharts.js" type="text/javascript"></script>
		<script src="../amcharts/serial.js" type="text/javascript"></script>
		<script src="../amcharts/amstock.js" type="text/javascript"></script>

		<script>
			AmCharts.ready(function () {
				generateChartData();
				createStockChart();
			});

			var chartData = [];

			function generateChartData() {
                var firstDate = new Date();
                firstDate.setHours(0, 0, 0, 0);
                firstDate.setDate(firstDate.getDate() - 2000);

                //var values = {};
                
            <c:forEach var="item" items="${maListe}"  varStatus="loop">
                var newDate = new Date(firstDate);
                newDate.setDate(newDate.getDate() + ${loop.index});

                var open = ${item.ouverture};
                var close = '${item.fermeture}';
                var low = '${item.min}';
                var high = '${item.max}';
                var volume = '${item.volFin}';

                chartData[${loop.index}] = ({
                    date: newDate,
                    open: open,
                    close: close,
                    high: high,
                    low: low,
                    volume: volume
                });
                                
               
            </c:forEach>
               
                }

			function createStockChart() {
				var chart = new AmCharts.AmStockChart();


				// DATASET //////////////////////////////////////////
				var dataSet = new AmCharts.DataSet();
				dataSet.fieldMappings = [{
					fromField: "open",
					toField: "open"
				}, {
					fromField: "close",
					toField: "close"
				}, {
					fromField: "high",
					toField: "high"
				}, {
					fromField: "low",
					toField: "low"
				}, {
					fromField: "volume",
					toField: "volume"
				}, {
					fromField: "value",
					toField: "value"
				}];
				dataSet.color = "#7f8da9";
				dataSet.dataProvider = chartData;
				dataSet.title = "West Stock";
				dataSet.categoryField = "date";

				var dataSet2 = new AmCharts.DataSet();
				dataSet2.fieldMappings = [{
					fromField: "value",
					toField: "value"
				}];
				dataSet2.color = "#fac314";
				dataSet2.dataProvider = chartData;
				dataSet2.compared = true;
				dataSet2.title = "East Stock";
				dataSet2.categoryField = "date";

				chart.dataSets = [dataSet, dataSet2];

				// PANELS ///////////////////////////////////////////
				var stockPanel = new AmCharts.StockPanel();
				stockPanel.title = "Value";
				stockPanel.showCategoryAxis = false;
				stockPanel.percentHeight = 70;

				var valueAxis = new AmCharts.ValueAxis();
				valueAxis.dashLength = 5;
				stockPanel.addValueAxis(valueAxis);

				stockPanel.categoryAxis.dashLength = 5;

				// graph of first stock panel
				var graph = new AmCharts.StockGraph();
				graph.type = "candlestick";
				graph.openField = "open";
				graph.closeField = "close";
				graph.highField = "high";
				graph.lowField = "low";
				graph.valueField = "close";
				graph.lineColor = "#7f8da9";
				graph.fillColors = "#7f8da9";
				graph.negativeLineColor = "#db4c3c";
				graph.negativeFillColors = "#db4c3c";
				graph.proCandlesticks = true;
				graph.fillAlphas = 1;
				graph.useDataSetColors = false;
				graph.comparable = true;
				graph.compareField = "value";
				graph.showBalloon = false;
				stockPanel.addStockGraph(graph);

				var stockLegend = new AmCharts.StockLegend();
				stockLegend.valueTextRegular = undefined;
				stockLegend.periodValueTextComparing = "[[percents.value.close]]%";
				stockPanel.stockLegend = stockLegend;

				var chartCursor = new AmCharts.ChartCursor();
				chartCursor.valueLineEnabled = true;
				chartCursor.valueLineAxis = valueAxis;
				stockPanel.chartCursor = chartCursor;

				var stockPanel2 = new AmCharts.StockPanel();
				stockPanel2.title = "Volume";
				stockPanel2.percentHeight = 30;
				stockPanel2.marginTop = 1;
				stockPanel2.showCategoryAxis = true;

				var valueAxis2 = new AmCharts.ValueAxis();
				valueAxis2.dashLength = 5;
				stockPanel2.addValueAxis(valueAxis2);

				stockPanel2.categoryAxis.dashLength = 5;

				var graph2 = new AmCharts.StockGraph();
				graph2.valueField = "volume";
				graph2.type = "column";
				graph2.showBalloon = false;
				graph2.fillAlphas = 1;
				stockPanel2.addStockGraph(graph2);

				var legend2 = new AmCharts.StockLegend();
				legend2.markerType = "none";
				legend2.markerSize = 0;
				legend2.labelText = "";
				legend2.periodValueTextRegular = "[[value.close]]";
				stockPanel2.stockLegend = legend2;

				var chartCursor2 = new AmCharts.ChartCursor();
				chartCursor2.valueLineEnabled = true;
				chartCursor2.valueLineAxis = valueAxis2;
				stockPanel2.chartCursor = chartCursor2;

				chart.panels = [stockPanel, stockPanel2];


				// OTHER SETTINGS ////////////////////////////////////
				var sbsettings = new AmCharts.ChartScrollbarSettings();
				sbsettings.graph = graph;
				sbsettings.graphType = "line";
				sbsettings.usePeriod = "WW";
				sbsettings.updateOnReleaseOnly = false;
				chart.chartScrollbarSettings = sbsettings;


				// PERIOD SELECTOR ///////////////////////////////////
				var periodSelector = new AmCharts.PeriodSelector();
				periodSelector.position = "bottom";
				periodSelector.periods = [{
					period: "DD",
					count: 10,
					label: "10 days"
				}, {
					period: "MM",
					selected: true,
					count: 1,
					label: "1 month"
				}, {
					period: "YYYY",
					count: 1,
					label: "1 year"
				}, {
					period: "YTD",
					label: "YTD"
				}, {
					period: "MAX",
					label: "MAX"
				}];
				chart.periodSelector = periodSelector;

				chart.write('chartdiv');
			}


		</script>
	</head>
	<body style="background-color:#FFFFFF">
		<div id="chartdiv" style="width:100%; height:600px;"></div>
	</body>

</html>