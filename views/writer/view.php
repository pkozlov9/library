<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Writer */

$this->title = $model->wt_full_name;
$this->params['breadcrumbs'][] = ['label' => 'Авторы', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="writer-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('РЕДАКТИРОВАТЬ', ['update', 'id' => $model->wt_id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('УДАЛИТЬ', ['delete', 'id' => $model->wt_id], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => 'Вы уверены что хотите удалить этот элемент?',
                'method' => 'post',
            ],
        ]) ?>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'wt_id',
            'wt_full_name',
            'wt_date',
            'wt_readers' => [
                'label' => 'ЧИТАТЕЛИ',
                'format' => 'raw',
                'value' => empty($model->books) ? null : implode(array_map(function($value) {
                    return is_object($value->reader) ? Html::a(Html::encode($value->reader->rd_full_name), '/reader/'. $value->reader->rd_id) : null;
                }, $model->books), ', '),
            ],
            'wt_books' => [
                'label' => 'КНИГИ',
                'format' => 'raw',
                'value' => empty($model->books) ? null : implode(array_map(function($value) {
                    return is_object($value) ? Html::a(Html::encode($value->bk_title), '/book/'. $value->bk_id) : null;
                }, $model->books), ', '),
            ],
            'wt_created_at',
            'wt_updated_at',
        ],
    ]) ?>

</div>
