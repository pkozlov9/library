<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Writer */

$this->title = $model->wt_full_name;
$this->params['breadcrumbs'][] = ['label' => 'Авторы', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->wt_id, 'url' => ['view', 'id' => $model->wt_id]];
$this->params['breadcrumbs'][] = 'Редактирование';
?>
<div class="writer-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
