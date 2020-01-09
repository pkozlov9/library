<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Читатели';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="reader-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('ДОБАВИТЬ', ['create'], ['class' => 'btn btn-success']) ?>
    </p>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            'rd_id',
            'rd_full_name',
            'rd_date',
            'rd_book_counter' => [
                'label' => 'КНИГИ НА РУКАХ',
                'value' => function($model){
                    return count($model->books);
                },
            ],
            'rd_created_at' => [
                'attribute' => 'rd_created_at',
                'headerOptions' => ['class' => 'w161']
            ],
            'rd_updated_at' => [
                'attribute' => 'rd_updated_at',
                'headerOptions' => ['class' => 'w161']
            ],

            [
                'class' => 'yii\grid\ActionColumn',
                'template' => '<div class="gridbtns">{view} {update} {delete}</div>',
            ],
        ],
        'tableOptions' => ['class' => 'table table-striped table-bordered gridtbl'],
        'summary' => "СТРАНИЦА: {page} из {pageCount}. ЧИТАТЕЛИ: с {begin} по {end} из {totalCount}.",
    ]); ?>

</div>
