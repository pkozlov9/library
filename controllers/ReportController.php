<?php

namespace app\controllers;

use Yii;
use app\models\Book;
use app\models\Writer;
use yii\data\ActiveDataProvider;
use yii\data\SqlDataProvider;
use yii\web\Controller;

/**
 * BookController implements the CRUD actions for Book model.
 */
class ReportController extends Controller
{
    /**
     * Lists all Book models.
     * @return mixed
     */
    public function actionIndex()
    {
        $books = new ActiveDataProvider([
            'query' => Book::find()->where(['is not', 'bk_rd_id', null])->andWhere('bk_writer_counter>=3'),
            'sort' => false,
            'pagination' => [
                'pageParam' => 'page-books',
                'pageSize' => 5,
            ],
        ]);

        $writers = new ActiveDataProvider([
            'query' => Writer::find()->where('wt_reader_counter>3'),
            'sort' => false,
            'pagination' => [
                'pageParam' => 'page-writers',
                'pageSize' => 5,
            ],
        ]);

        $rnd_books = new SqlDataProvider([
            'sql' => 'CALL lb_random_book(:limit)',
            'sort' => false,
            'params' => [':limit' => 5],
            'pagination' => false,
        ]);

        return $this->render('index', [
            'books' => $books,
            'writers' => $writers,
            'rnd_books' => $rnd_books,
        ]);
    }
}
