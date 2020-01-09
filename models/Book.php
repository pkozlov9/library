<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "lb_book".
 *
 * @property string $bk_id
 * @property string $bk_rd_id
 * @property string $bk_title
 * @property string $bk_date
 * @property integer $bk_writer_counter
 * @property string $bk_created_at
 * @property string $bk_updated_at
 */
class Book extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'lb_book';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['bk_rd_id', 'bk_writer_counter'], 'integer'],
            [['bk_title', 'bk_date'], 'required'],
            [['bk_date', 'bk_created_at', 'bk_updated_at'], 'safe'],
            [['bk_title'], 'string', 'max' => 255],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'bk_id' => 'ID',
            'bk_rd_id' => 'ID ЧИТАТЕЛЯ',
            'bk_title' => 'НАЗВАНИЕ КНИГИ',
            'bk_date' => 'ДАТА ПУБЛИКАЦИИ',
            'bk_writer_counter' => 'АВТОРЫ',
            'bk_created_at' => 'ДАТА ДОБАВЛЕНИЯ',
            'bk_updated_at' => 'ДАТА РЕДАКТИРОВАНИЯ',
        ];
    }

    public function getReader()
    {
        return $this->hasOne(Reader::className(), ['rd_id' => 'bk_rd_id']);
    }

    public function getWriters()
    {
        return $this->hasMany(Writer::className(), ['wt_id' => 'wb_wt_id'])
            ->viaTable('lb_writer_book', ['wb_bk_id' => 'bk_id']);
    }
}
