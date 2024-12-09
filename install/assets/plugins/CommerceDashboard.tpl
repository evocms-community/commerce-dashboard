//<?php
/**
 * Commerce Dashboard
 *
 * Simple Commerce dashboard
 *
 * @category    plugin
 * @version     0.2.1
 * @author      mnoskov
 * @internal    @events OnManagerWelcomeHome
 * @internal    @modx_category Commerce
 * @internal    @installset base
 * @internal    @properties &cchartsposition=Chart widget position:;text;0 &cchartssizex=Chart widget width:;list;12,6,4,3;6 &cordersposition=Orders widget position:;text;1 &corderssizex=Orders widget width:;list;12,6,4,3;6
*/

if (empty($modx->commerce) && !defined('COMMERCE_INITIALIZED')) {
    return;
}

switch ($modx->event->name) {
    case 'OnManagerWelcomeHome': {
        $start   = (new DateTime())->sub(new DateInterval('P1M'));
        $year    = $start->format('Y');
        $month   = $start->format('m');
        $date    = (new DateTime())->setDate($year, $month, 1);
        $day     = new DateInterval('P1D');
        $xcount  = max($start->format('t'), date('t'));
        $amounts = [[], []];
        $orders  = [[], []];
        $list    = [];
        $index   = 0;

        $currency = ci()->currency;
        $defaultCurrency = $currency->getDefaultCurrencyCode();

        do {
            $amounts[$index][$date->format('Y-m-d')] = 0;
            $date->add($day);
            $j = $date->format('j');

            if ($j == 1) {
                $index++;
            }
        } while ($index < 2);

        $orders = $amounts;

        $query = $modx->db->select("*, DATE(`created_at`) `created_at`", $modx->getFullTablename('commerce_orders'), "created_at >= '" . $start->format('Y-m-1') . "'", 'created_at');

        while ($row = $modx->db->getRow($query)) {
            $list[] = $row;

            foreach ([0, 1] as $line) {
                if (array_key_exists($row['created_at'], $amounts[$line])) {
                    $amounts[$line][$row['created_at']] += $currency->convertToDefault($row['amount'], !empty($row['currency']) ? $row['currency'] : $defaultCurrency);
                    $orders[$line][$row['created_at']]++;
                    break;
                }
            }
        }

        $list = array_slice(array_reverse($list), 0, 15);

        $moduleid = $modx->db->getValue($modx->db->select('id', $modx->getFullTablename('site_modules'), "name = 'Commerce'"));

        $statuses = [];
        foreach(ci()->statuses->getStatuses() as $row) {
            $statuses[$row['id']] = [
                'title' => $row['title'],
                'color' => !empty($row['color']) ? $row['color'] : 'FFFFFF',
                'alias' => $row['alias']
            ];
        }

        $lexicon = new Helpers\Lexicon($modx, [
            'langDir' => 'assets/plugins/commercedashboard/lang/',
            'lang'    => $modx->getLocale(),
        ]);

        $view = new Commerce\Module\Renderer($modx, null, ['path' => MODX_BASE_PATH . 'assets/plugins/commercedashboard/templates']);
        $lexicon->fromFile('order', $modx->getLocale(), 'assets/plugins/commerce/lang/');
        $lexicon->fromFile('dashboard');
        $lang = $lexicon->getLexicon();
        $view->setLang($lang);

        $widgets['commercecharts'] = array(
            'menuindex' => $cchartsposition,
            'id'        => 'commercecharts',
            'cols'      => 'col-lg-'.$cchartssizex.'',
            'icon'      => 'fa-bar-chart-o',
            'title'     => $lang['dashboard.charts_title'],
            'body'      => $view->render('charts.tpl', [
                'orders'  => $orders,
                'amounts' => $amounts,
                'xcount'  => $xcount,
            ]),
        );

        $widgets['commerceorders'] = array(
            'menuindex' => $cordersposition,
            'id'        => 'commerceorders',
            'cols'      => 'col-lg-'.$corderssizex.'',
            'icon'      => 'fa-list',
            'title'     => $lang['dashboard.list_title'],
            'body'      => $view->render('orders.tpl', [
                'orders'    => $list,
                'moduleUrl' => 'index.php?a=112&id=' . $moduleid,
                'currency'  => $currency,
                'statuses'  => $statuses,
                'defaultCurrency' => $defaultCurrency,
            ]),
        );

        $modx->event->output(serialize($widgets));
        break;
    }
}