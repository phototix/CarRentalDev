<?php
$pickup_date = strtotime($tpl['arr']['from']);
if(!empty($tpl['arr']['pickup_date']))
{
	$pickup_date = strtotime($tpl['arr']['pickup_date']);
}
$pickup_date = date($tpl['option_arr']['o_date_format'], $pickup_date) . ' ' . date($tpl['option_arr']['o_time_format'], $pickup_date);
?>
<div class="alert alert-success">
	<i class="fa fa-check m-r-xs"></i>
	<strong><?php echo __('infoUpdateCollectTitle', true); ?></strong>
	<?php echo __('infoUpdateCollectDesc', true);?>
</div>
<div class="row">
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_pickup_date'); ?></label>

			<div class="input-group">
				<input type="text" name="pickup_date" id="pickup_date" value="<?php echo $pickup_date;?>" class="form-control datetimepick" data-wt="open" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-remote="<?php __('lblPickupWorkingTime');?>">

				<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_car');?></label>
			<div id="boxCollectCars">
				<select name="collect_car_id" id="collect_car_id" class="form-control select-item required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
					<option value="">-- <?php __('lblChoose'); ?>--</option>
					<?php
					foreach ($tpl['car_arr'] as $v)
					{
						?><option value="<?php echo $v['car_id']; ?>"<?php echo $tpl['arr']['car_id'] == $v['car_id'] ? ' selected="selected"' : NULL; ?>><?php echo stripslashes($v['make'] . " " . $v['model'] . " - " . $v['registration_number']); ?></option><?php
					}
					?>
				</select>
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('car_current_mileage'); ?></label>

			<p class="fz16"><span id="collect_current_mileage"><?php echo @$tpl['booking_car_arr']['mileage'];?>&nbsp;<?php echo $tpl['option_arr']['o_unit'] ?></span></p>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_pickup_mileage');?> (<?php echo $tpl['option_arr']['o_unit'] ?>)</label>
			<div class="row">
				<div class="col-sm-4">
					<input type="text" name="pickup_mileage" id="pickup_mileage" value="<?php echo $tpl['arr']['pickup_mileage']; ?>" class="form-control touchspin3 text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
				</div>
				<div class="col-sm-8">(<a href="#" id="cr_set_as_current" rev="<?php echo @$tpl['booking_car_arr']['mileage'];?>"><?php __('booking_set_as_current'); ?></a>)</div>
			</div>
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