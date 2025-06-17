<?php
$extra_hours_usage  = 0;

$dropoff_date = strtotime($tpl['arr']['to']);
$dropoff_date = date($tpl['option_arr']['o_date_format'], $dropoff_date)." ".date('H:i',$dropoff_date);

$actual_dropoff_date ='';
if(!empty($tpl['arr']['actual_dropoff_datetime']))
{
	$actual_dropoff_date = strtotime($tpl['arr']['actual_dropoff_datetime']);
	$actual_dropoff_date = date($tpl['option_arr']['o_date_format'], $actual_dropoff_date)." ".date('H:i',$actual_dropoff_date);
	
	$seconds = strtotime($tpl['arr']['actual_dropoff_datetime']) - strtotime($tpl['arr']['to']);
	if($seconds > 0)
	{
		$extra_hours_usage = ceil($seconds / 3600);
	}
}
?>
<div class="alert alert-success">
	<i class="fa fa-check m-r-xs"></i>
	<strong><?php echo __('infoUpdateReturnTitle', true); ?></strong>
	<?php echo __('infoUpdateReturnDesc', true);?>
</div>
<div class="row">
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_return_deadline'); ?></label>

			<p class="fz16"><?php echo $dropoff_date;?></p>
		</div>
	</div>
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_return_datetime'); ?></label>

			<div class="input-group">
				<input type="text" name="actual_dropoff_datetime" id="actual_dropoff_datetime" value="<?php echo $actual_dropoff_date;?>" class="form-control datetimepick" data-wt="open" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-remote="<?php __('lblPickupWorkingTime');?>">

				<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
			</div>
		</div>
	</div>
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_extra_hours_usage'); ?></label>

			<p class="fz16"><span id="cr_extra_hours_usage"><?php echo $extra_hours_usage > 0 ? $extra_hours_usage . ' ' . ($extra_hours_usage > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false)) : __('booking_no', false, true) ;?></span></p>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_dropoff_mileage');?> (<?php echo $tpl['option_arr']['o_unit'] ?>)</label>
			<input type="text" name="dropoff_mileage" id="dropoff_mileage" value="<?php echo $tpl['arr']['dropoff_mileage']; ?>" class="form-control touchspin3 text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
		</div>
	</div>
	<?php
	$actual_mileage = 0;
	$extra_mileage_charge = 0;
	$_em_charge = 0;
	if(!empty($tpl['arr']['dropoff_mileage']) && !empty($tpl['arr']['pickup_mileage']))
	{
		$actual_mileage = $tpl['arr']['dropoff_mileage'] - $tpl['arr']['pickup_mileage'];
	}
	if($actual_mileage > 0)
	{
		$_em_charge = $actual_mileage - ($rental_days * $daily_mileage_limit);
		if($_em_charge > 0)
		{
			$extra_mileage_charge = $_em_charge * $price_for_extra_mileage;
		}
	}
	if($extra_mileage_charge > 0)
	{
		$extra_mileage_charge = $_em_charge . $tpl['option_arr']['o_unit'] . ' x ' . pjCurrency::formatPrice($price_for_extra_mileage) . ' = ' . pjCurrency::formatPrice($extra_mileage_charge);
	}else{
		$extra_mileage_charge = __('booking_no', true, false);
		?><input type="hidden" name="extra_mileage_charge" id="extra_mileage_charge"/><?php
	}
	?>
	<input type="hidden" name="extra_mileage_charge" id="extra_mileage_charge" value="<?php echo (float)$extra_mileage_charge; ?>"/>
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_extra_mileage_charge'); ?></label>

			<p class="fz16"><span id="cr_extra_mileage_charge"><?php echo $extra_mileage_charge;?></span></p>
		</div>
	</div>
</div>


<div class="hr-line-dashed"></div>

	<div class="clearfix">
		<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in" style="margin-right: 15px;">
		<span class="ladda-label"><?php __('btnSave'); ?></span>
		<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
	</button>
	<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
</div><!-- /.clearfix -->