<div class="cart-body">
    <div class="table-responsive">
        <table class="table data">
            <thead>
                <tr>
                    <th width="1%">ID</th>
                    <th><?= $lang['dashboard.date'] ?></th>
                    <th><?= $lang['dashboard.status'] ?></th>
                    <th class="text-xs-right"><?= $lang['dashboard.amount'] ?></th>
                    <th class="text-xs-right" width="1%"></th>
                </tr>
            </thead>

            <tbody>
                <?php foreach ($orders as $order): ?>
                    <tr>
                        <td><?= $order['id'] ?></td>
                        <td><?= (new \DateTime($order['created_at']))->format('d.m.Y') ?></td>
                        <td><?= isset($statuses[$order['status_id']]) ? $statuses[$order['status_id']] : '' ?></td>
                        <td class="text-xs-right"><?= $currency->format($order['amount'], !empty($order['currency']) ? $order['currency'] : $defaultCurrency) ?></td>
                        <td class="actions text-xs-right">
                            <a href="<?= $moduleUrl ?>&type=orders/view&order_id=<?= $order['id'] ?>" title="<?= $lang['dashboard.view'] ?>"><i class="fa fa-eye fa-fw"></i></a>
                            <a href="<?= $moduleUrl ?>&type=orders/edit&order_id=<?= $order['id'] ?>" title="<?= $lang['dashboard.edit'] ?>"><i class="fa fa-edit fa-fw"></i></a>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>
