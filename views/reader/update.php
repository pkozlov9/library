<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Reader */

$this->title = $model->rd_full_name;
$this->params['breadcrumbs'][] = ['label' => 'Книги', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->rd_id, 'url' => ['view', 'id' => $model->rd_id]];
$this->params['breadcrumbs'][] = 'Редактирование';
?>
<div class="reader-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
