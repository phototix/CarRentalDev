<select name="car_id" id="car_id" class="form-control select-item required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
	<option value="">-- <?php __('lblChoose'); ?> --</option>
	<?php
	foreach ($tpl['car_arr'] as $v)
	{
		?><option value="<?php echo $v['car_id']; ?>"><?php echo stripslashes($v['make'] . " " . $v['model'] . " - " . $v['registration_number']); ?></option><?php
	}
	?>
</select>
