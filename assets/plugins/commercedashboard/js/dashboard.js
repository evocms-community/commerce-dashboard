$.fn.createChart = function(options) {
    return this.each(function() {
        var ctx = this.getContext('2d');

        var myChart = new Chart.Line(ctx, {
            data: {
                labels: options.labels,
                datasets: [{
                    label: options.previousTitle,
                    fill: false,
                    borderColor: options.previousColor,
                    backgroundColor: options.previousColor,
                    borderWidth: 1.5,
                    pointBorderWidth: 0,
                    pointRadius: 2,
                    borderDash: [2, 2],
                    data: options.previousData
                }, {
                    label: options.currentTitle,
                    fill: false,
                    borderColor: options.currentColor,
                    backgroundColor: options.currentColor,
                    borderWidth: 1.5,
                    pointBorderWidth: 0,
                    pointRadius: 2,
                    data: options.currentData
                }]
            },
            options: {
                responsive: true,
                hoverMode: 'index',
                stacked: false,
                title: {
                    display: false
                },
                legend: {
                    position: 'bottom',
                    labels: {
                        boxWidth: 12
                    }
                },
                scales: {
                    xAxes: [{
                        gridLines: {
                            color: 'rgba(0,0,0,0.05)',
                        },
                    }],
                    yAxes: [$.extend({
                        type: 'linear',
                        display: true,
                        position: 'right',
                        id: 'amounts',
                        beginAtZero: true,
                        gridLines: {
                            color: 'rgba(0,0,0,0.05)',
                        }
                    }, options.yAxe)],
                }
            }
        });
    });
};
