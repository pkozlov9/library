<?php

use yii\helpers\Html;
use yii\widgets\LinkPager;
use yii\widgets\ListView;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Отчет';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="report-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <h3>Вывод списка книг, находящихся на руках у читателей, и имеющих не менее трех со-авторов.</h3>
    <?= GridView::widget([
            'dataProvider' => $books,
            'columns' => [
                'bk_id',
                'bk_reader' => [
                    'label' => 'ЧИТАТЕЛЬ',
                    'format' => 'raw',
                    'value' => function($model){
                        return is_null($model->bk_rd_id) ? null : Html::a($model->reader->rd_full_name, '/reader/'. $model->bk_rd_id);
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
            ],
            'tableOptions' => ['class' => 'table table-striped table-bordered gridtbl'],
            'summary' => "СТРАНИЦА: {page} из {pageCount}. КНИГИ: с {begin} по {end} из {totalCount}",
        ]);
    ?>

    <h3>Вывод списка авторов, чьи книги в данный момент читает более трех читателей.</h3>
    <?= GridView::widget([
            'dataProvider' => $writers,
            'columns' => [
                'wt_id',
                'wt_full_name' => [
                    'label' => 'ИМЯ',
                    'format' => 'raw',
                    'value' => function($model){
                        return empty($model->wt_full_name) ? null : Html::a($model->wt_full_name, '/writer/'. $model->wt_id);
                    },
                ],
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
            ],
            'tableOptions' => ['class' => 'table table-striped table-bordered gridtbl'],
            'summary' => "СТРАНИЦА: {page} из {pageCount}. АВТОРЫ: с {begin} по {end} из {totalCount}.",
        ]);
    ?>

    <h3>Вывод пяти случайных книг.</h3>
    <?= GridView::widget([
        'dataProvider' => $rnd_books,
        'columns' => [
            'bk_id' => [
                'attribute' => 'bk_id',
                'label' => 'ID'
            ],
            'bk_title' => [
                'label' => 'НАЗВАНИЕ КНИГИ',
                'format' => 'raw',
                'value' => function($data){
                    return empty($data['bk_title']) ? null : Html::a($data['bk_title'], '/book/'. $data['bk_id']);
                },
            ],
            'bk_date' => [
                'attribute' => 'bk_date',
                'label' => 'ДАТА ПУБЛИКАЦИИ'
            ],
            'bk_writer_counter' => [
                'attribute' => 'bk_writer_counter',
                'label' => 'АВТОРЫ'
            ],
            'bk_created_at' => [
                'label' => 'ДАТА ДОБАВЛЕНИЯ',
                'attribute' => 'bk_created_at',
                'headerOptions' => ['class' => 'w161'],
            ],
            'bk_updated_at' => [
                'label' => 'ДАТА РЕДАКТИРОВАНИЯ',
                'attribute' => 'bk_updated_at',
                'headerOptions' => ['class' => 'w161'],
            ],
        ],
        'tableOptions' => ['class' => 'table table-striped table-bordered gridtbl'],
        'summary' => "КНИГИ: всего {totalCount} записей.",
    ]);
    ?>

</div>
