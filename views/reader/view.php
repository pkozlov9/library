<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Reader */

$this->title = $model->rd_full_name;
$this->params['breadcrumbs'][] = ['label' => 'Читатели', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="reader-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('РЕДАКТИРОВАТЬ', ['update', 'id' => $model->rd_id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('УДАЛИТЬ', ['delete', 'id' => $model->rd_id], [
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
            'rd_id',
            'rd_full_name',
            'rd_date',
            'rd_books' => [
                'label' => 'КНИГИ НА РУКАХ',
                'format' => 'raw',
                'value' => empty($model->books) ? null : implode(array_map(function($value) {
                        return is_object($value) ? Html::a(Html::encode($value->bk_title), '/book/'. $value->bk_id) : null;
                }, $model->books), ', '),
            ],
            'rd_created_at',
            'rd_updated_at',
        ],
    ]) ?>

</div>
