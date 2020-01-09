<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Авторы';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="writer-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('ДОБАВИТЬ', ['create'], ['class' => 'btn btn-success']) ?>
    </p>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            'wt_id',
            'wt_full_name',
            'wt_date',
            'wt_reader_counter',
            'wt_book_counter' => [
                'label' => 'КНИГИ',
                'format' => 'raw',
                'value' => function($model){
                    return count($model->books);
                },
            ],
            'wt_created_at' => [
                'attribute' => 'wt_created_at',
                'headerOptions' => ['class' => 'w161']
            ],
            'wt_updated_at' => [
                'attribute' => 'wt_updated_at',
                'headerOptions' => ['class' => 'w161']
            ],

            [
                'class' => 'yii\grid\ActionColumn',
                'template' => '<div class="gridbtns">{view} {update} {delete}</div>',
            ],
        ],
        'tableOptions' => ['class' => 'table table-striped table-bordered gridtbl'],
        'summary' => "СТРАНИЦА: {page} из {pageCount}. АВТОРЫ: с {begin} по {end} из {totalCount}.",
    ]); ?>

</div>
