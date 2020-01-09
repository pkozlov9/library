<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Writer */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="writer-form">

    <?php $form = ActiveForm::begin(); ?>

    <?= $form->field($model, 'wt_id')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
        'size' => 21
    ]) ?>

    <?= $form->field($model, 'wt_full_name')->textInput([
        'class' => 'form-control wa',
        'size' => 40
    ]) ?>

    <?= $form->field($model, 'wt_date')->widget(yii\jui\DatePicker::classname(), [
        'language' => 'ru',
        'dateFormat' => 'yyyy-MM-dd',
        'options' => ['class' => 'form-control wa'],
    ]) ?>

    <?= $form->field($model, 'wt_reader_counter')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
        'size' => 2
    ]) ?>

    <?= $form->field($model, 'wt_created_at')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
    ]) ?>

    <?= $form->field($model, 'wt_updated_at')->textInput([
        'disabled' => true,
        'class' => 'form-control wa',
    ]) ?>

    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Добавить' : 'Редактировать', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
