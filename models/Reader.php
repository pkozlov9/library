<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "lb_reader".
 *
 * @property string $rd_id
 * @property string $rd_full_name
 * @property string $rd_date
 * @property string $rd_created_at
 * @property string $rd_updated_at
 */
class Reader extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'lb_reader';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['rd_full_name', 'rd_date'], 'required'],
            [['rd_date', 'rd_created_at', 'rd_updated_at'], 'safe'],
            [['rd_full_name'], 'string', 'max' => 255],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'rd_id' => 'ID',
            'rd_full_name' => 'ИМЯ',
            'rd_date' => 'ДАТА РОЖДЕНИЯ',
            'rd_created_at' => 'ДАТА ДОБАВЛЕНИЯ',
            'rd_updated_at' => 'ДАТА РЕДАКТИРОВАНИЯ',
        ];
    }

    public function getBooks()
    {
        return $this->hasMany(Book::className(), ['bk_rd_id' => 'rd_id']);
    }
}
