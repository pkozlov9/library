<?php

// локальные настройки для сервера.bowerrc
#	.gitignore
#	LICENSE.md
#	README.md
#	assets/
#	composer.json
#	composer.lock
#	config/
#	controllers/
#	data/
#	docs/
#	messages/
#	models/
#	requirements.php
#	runtime/
#	tests/
#	views/
#	web/
#	yii
#	yii.bat
require(__DIR__ . '/../config/local.php');

defined('YII_DEBUG') or define('YII_DEBUG', true);
defined('YII_ENV') or define('YII_ENV', 'prod');

require(__DIR__ . '/../vendor/autoload.php');
require(__DIR__ . '/../vendor/yiisoft/yii2/Yii.php');

$config = require(__DIR__ . '/../config/web.php');

(new yii\web\Application($config))->run();
