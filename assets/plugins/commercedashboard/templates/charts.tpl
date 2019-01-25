<div class="card-body">
    <canvas id="commerce_chart_amounts" style="width: 500px; height: 250px;"></canvas>
    <canvas id="commerce_chart_orders" style="width: 500px; height: 150px;"></canvas>

    <script src="../assets/plugins/commercedashboard/js/chart.bundle.min.js"></script>
    <script src="../assets/plugins/commercedashboard/js/dashboard.js"></script>

    <script>
        $('#commerce_chart_amounts').createChart({
            labels: <?= json_encode(range(1, $xcount)) ?>,
            currentData: <?= json_encode(array_values($amounts[1])) ?>,
            previousData: <?= json_encode(array_values($amounts[0])) ?>,
            currentColor: '#3183bd',
            previousColor: '#6aadd8',
            currentTitle: '<?= $lang['dashboard.amounts_current_month'] ?>',
            previousTitle: '<?= $lang['dashboard.amounts_prev_month'] ?>',
            yAxe: {
                ticks: {
                    callback: function(value, index, values) {
                        if (parseFloat(value) == value) {
                            value = value * 0.001 + '<?= $lang['dashboard.thousands'] ?>';
                        }

                        return value;
                    }
                },
            }
        });

        $('#commerce_chart_orders').createChart({
            labels: <?= json_encode(range(1, $xcount)) ?>,
            currentData: <?= json_encode(array_values($orders[1])) ?>,
            previousData: <?= json_encode(array_values($orders[0])) ?>,
            currentColor: '#3183bd',
            previousColor: '#6aadd8',
            currentTitle: '<?= $lang['dashboard.count_current_month'] ?>',
            previousTitle: '<?= $lang['dashboard.count_prev_month'] ?>',
        });
    </script>
</div>
