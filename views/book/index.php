<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Книги';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="book-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('ДОБАВИТЬ', ['create'], ['class' => 'btn btn-success']) ?>
    </p>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            'bk_id',
            'bk_reader' => [
                'label' => 'ЧИТАТЕЛЬ',
                'format' => 'raw',
                'value' => function($model){
                    return is_null($model->bk_rd_id) ? null : Html::a(Html::encode($model->reader->rd_full_name), '/reader/'. $model->bk_rd_id);
                },
            ],
            'bk_title' => [
                'label' => 'НАЗВАНИЕ КНИГИ',
                'format' => 'raw',
                'value' => function($model){
                    return empty($model->bk_title) ? null : Html::a($model->bk_title, '/book/'. $model->bk_id);
                },
            ],
            'bk_date',
            'bk_writer_counter',
            'bk_created_at' => [
                'attribute' => 'bk_created_at',
                'headerOptions' => ['class' => 'w161'],
            ],
            'bk_updated_at' => [
                'attribute' => 'bk_updated_at',
                'headerOptions' => ['class' => 'w161'],
            ],

            [
                'class' => 'yii\grid\ActionColumn',
                'template' => '<div class="gridbtns">{view} {update} {delete}</div>',
            ],
        ],
        'tableOptions' => ['class' => 'table table-striped table-bordered gridtbl'],
        'summary' => "СТРАНИЦА: {page} из {pageCount}. КНИГИ: с {begin} по {end} из {totalCount}.",
    ]); ?>

</div>
