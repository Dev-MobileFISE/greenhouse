<?php

use App\Kernel;

ini_set('max_execution_time', '0');
set_time_limit(0);

require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

return static function (array $context) {
    return new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
};
