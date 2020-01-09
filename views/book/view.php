<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Book */

$this->title = $model->bk_title;
$this->params['breadcrumbs'][] = ['label' => 'Книги', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="book-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('РЕДАКТИРОВАТЬ', ['update', 'id' => $model->bk_id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('УДАЛИТЬ', ['delete', 'id' => $model->bk_id], [
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
            'bk_id',
            'bk_reader' => [
                'label' => 'ЧИТАТЕЛЬ',
                'format' => 'raw',
                'value' => is_null($model->bk_rd_id) ? null : Html::a(Html::encode($model->reader->rd_full_name), '/reader/'. $model->bk_rd_id),
            ],
            'bk_title',
            'bk_date',
            'bk_writers' => [
                'label' => 'АВТОРЫ',
                'format' => 'raw',
                'value' => empty($model->writers) ? null : implode(array_map(function($value) {
                    return is_object($value) ? Html::a(Html::encode($value->wt_full_name), '/writer/'. $value->wt_id) : null;
                }, $model->writers), ', '),
            ],
            'bk_created_at',
            'bk_updated_at',
        ],
    ]) ?>

</div>
