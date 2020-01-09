<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "lb_writer".
 *
 * @property string $wt_id
 * @property string $wt_full_name
 * @property string $wt_date
 * @property integer $wt_reader_counter
 * @property string $wt_created_at
 * @property string $wt_updated_at
 */
class Writer extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'lb_writer';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['wt_full_name', 'wt_date'], 'required'],
            [['wt_date', 'wt_created_at', 'wt_updated_at'], 'safe'],
            [['wt_reader_counter'], 'integer'],
            [['wt_full_name'], 'string', 'max' => 255],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'wt_id' => 'ID',
            'wt_full_name' => 'ИМЯ',
            'wt_date' => 'ДАТА РОЖДЕНИЯ',
            'wt_reader_counter' => 'ЧИТАТЕЛИ',
            'wt_created_at' => 'ДАТА ДОБАВЛЕНИЯ',
            'wt_updated_at' => 'ДАТА РЕДАКТИРОВАНИЯ',
        ];
    }

    public function getBooks()
    {
        return $this->hasMany(Book::className(), ['bk_id' => 'wb_bk_id'])
            ->viaTable('lb_writer_book', ['wb_wt_id' => 'wt_id']);
    }
}
