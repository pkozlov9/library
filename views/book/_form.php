<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Book */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="book-form">

    <?php $form = ActiveForm::begin(); ?>

    <?= $form->field($model, 'bk_id')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
        'size' => 21
    ]) ?>

    <?= $form->field($model, 'bk_rd_id')->textInput([
        'class' => 'form-control wa',
        'size' => 21
    ]) ?>

    <?= $form->field($model, 'bk_title')->textInput([
        'class' => 'form-control wa',
        'size' => 100
    ]) ?>

    <?= $form->field($model, 'bk_date')->widget(yii\jui\DatePicker::classname(), [
        'language' => 'ru',
//        'clientOptions' => ['defaultDate' => '2014-01-01'],
        'dateFormat' => 'yyyy-MM-dd',
        'options' => ['class' => 'form-control wa'],
    ]) ?>

    <?= $form->field($model, 'bk_writer_counter')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
        'size' => 2
    ]) ?>

    <?= $form->field($model, 'bk_created_at')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
    ]) ?>

    <?= $form->field($model, 'bk_updated_at')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
    ]) ?>

    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Добавить' : 'Редактировать', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
