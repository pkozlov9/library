<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Reader */

$this->title = 'Добавление читателя';
$this->params['breadcrumbs'][] = ['label' => 'Читатели', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="reader-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
