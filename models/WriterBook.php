<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "lb_writer_book".
 *
 * @property string $wb_wt_id
 * @property string $wb_bk_id
 */
class WriterBook extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'lb_writer_book';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['wb_wt_id', 'wb_bk_id'], 'required'],
            [['wb_wt_id', 'wb_bk_id'], 'integer'],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'wb_wt_id' => 'id из таблицы lb_writer',
            'wb_bk_id' => 'id из таблицы lb_book',
        ];
    }
}
