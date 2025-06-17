<?php 
$date_from = $date_to = '';
if (isset($tpl['arr']) && $tpl['arr']) { 
	$date_from = date($tpl['option_arr']['o_date_format'], strtotime($tpl['arr']['from'])) . ' ' . date($tpl['option_arr']['o_time_format'], strtotime($tpl['arr']['from']));
	$date_to = date($tpl['option_arr']['o_date_format'], strtotime($tpl['arr']['to'])) . ' ' . date($tpl['option_arr']['o_time_format'], strtotime($tpl['arr']['to']));
	?>
	<div class="alert alert-success">
		<i class="fa fa-check m-r-xs"></i>
		<strong><?php echo __('infoUpdateBookingDetailsTitle', true); ?></strong>
		<?php echo __('infoUpdateBookingDetailsDesc', true);?>
	</div>
	<div class="row">
		<div class="col-md-4 col-sm-6">
			<div class="form-group m-t-sm">
				<label class="control-label"><?php __('booking_id'); ?></label>
	
				<p class="fz16"><?php echo pjSanitize::html($tpl['arr']['booking_id']);?></p>
			</div>
		</div><!-- /.col-md-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="form-group m-t-sm">
				<label class="control-label"><?php __('booking_ip'); ?></label>
	
				<p class="fz16"><?php echo pjSanitize::html($tpl['arr']['ip']);?></p>
			</div>
		</div><!-- /.col-md-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="form-group m-t-sm">
				<label class="control-label"><?php __('booking_created_on'); ?></label>
	
				<p class="fz16"><?php echo $created_datetime;?></p>
			</div>
		</div><!-- /.col-md-4 -->
	</div>
<?php } else { ?>
	<div class="alert alert-success">
		<i class="fa fa-check m-r-xs"></i>
		<strong><?php echo __('infoAddBookingTitle', true); ?></strong>
		<?php echo __('infoAddBookingBody', true);?>
	</div>
<?php } ?>
<div class="row">								
	<div class="col-lg-3 col-sm-6 crDateFrom">
		<div class="form-group">
			<label class="control-label"><?php __('booking_from'); ?></label>

			<div class="input-group">
				<input type="text" name="date_from" id="date_from" value="<?php echo $date_from;?>" class="form-control datetimepick required" data-wt="open" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-remote="<?php __('lblPickupWorkingTime');?>">

				<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
			</div>
		</div>
	</div><!-- /.col-md-3 -->

	<div class="col-lg-3 col-sm-6 crDateTo">
		<div class="form-group">
			<label class="control-label"><?php __('booking_to'); ?></label>

			<div class="input-group">
				<input type="text" name="date_to" id="date_to" value="<?php echo $date_to;?>" class="form-control datetimepick required" data-wt="open" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-remote="<?php __('lblReturnWorkingTime');?>">

				<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
			</div>
			<input type="hidden" name="dates" id="dates" value="1" />
			<input type="hidden" name="isUpdate" id="isUpdate" value="0" />
		</div>
	</div><!-- /.col-md-3 -->

	<div class="col-lg-3 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('lblStatus');?></label>

			<select name="status" id="booking_status" class="form-control required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
				<option value="">-- <?php __('lblChoose'); ?>--</option>
				<?php
				foreach ($bs as $k => $v)
				{
					?><option value="<?php echo $k; ?>" <?php echo isset($tpl['arr']['status']) && $tpl['arr']['status'] == $k ? 'selected="selected"' : '';?>><?php echo stripslashes($v); ?></option><?php
				}
				?>
			</select>
		</div>
	</div><!-- /.col-md-3 -->
	
	<div class="col-lg-3 col-sm-6">
		<?php
		/* $plugins_payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentMethods(): array();
		$haveOnline = $haveOffline = false;
		foreach ($tpl['payment_titles'] as $k => $v)
		{
			if($k == 'creditcard') continue;
			if (array_key_exists($k, $plugins_payment_methods))
			{
				if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
				{
					continue;
				}
			}else if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '0') || $k == 'cash' || $k == 'bank' ){
				continue;
			}
			$haveOnline = true;
			break;
		}
		foreach ($tpl['payment_titles'] as $k => $v)
		{
			if($k == 'creditcard') continue;
			if( $k == 'cash' || $k == 'bank' )
			{
				if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '1'))
				{
					$haveOffline = true;
					break;
				}
			}
		} */
		?>
	
		<div class="form-group">
			<label class="control-label"><?php __('booking_payment_method') ?></label>
	
			<?php
			$plugins_payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentMethods(): array();
			$haveOnline = $haveOffline = false;
			foreach ($tpl['payment_titles'] as $k => $v)
			{
			    if( $k != 'cash' && $k != 'bank' )
			    {
			        if( (int) $tpl['payment_option_arr'][$k]['is_active'] == 1)
			        {
			            $haveOnline = true;
			            break;
			        }
			    }
			}
			foreach ($tpl['payment_titles'] as $k => $v)
			{
			    if( $k == 'cash' || $k == 'bank' )
			    {
			        if( (int) $tpl['payment_option_arr'][$k]['is_active'] == 1)
			        {
			            $haveOffline = true;
			            break;
			        }
			    }
			}
			?>							
			<select name="payment_method" id="payment_method" class="form-control<?php echo $tpl['option_arr']['o_payment_disable'] == '0' ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
				<option value=""><?php echo __('plugin_base_choose'); ?></option>
				<?php
				if ($haveOnline && $haveOffline)
				{
				    ?><optgroup label="<?php __('script_online_payment_gateway', false, true); ?>"><?php
                }
                foreach ($tpl['payment_titles'] as $k => $v)
                {
                    if($k == 'cash' || $k == 'bank' ){
                        continue;
                    }
                    if (array_key_exists($k, $plugins_payment_methods))
                    {
                        if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
                        {
                            continue;
                        }
                    }
                    ?><option value="<?php echo $k; ?>"<?php echo isset($tpl['arr']['payment_method']) && $tpl['arr']['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
                }
                if ($haveOnline && $haveOffline)
                {
                    ?>
                	</optgroup>
                	<optgroup label="<?php __('script_offline_payment', false, true); ?>">
                	<?php 
                }
                foreach ($tpl['payment_titles'] as $k => $v)
                {
                    if( $k == 'cash' || $k == 'bank' )
                    {
                        if( (int) $tpl['payment_option_arr'][$k]['is_active'] == 1)
                        {
                            ?><option value="<?php echo $k; ?>"<?php echo isset($tpl['arr']['payment_method']) && $tpl['arr']['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
                        }
                    }
                }
                if ($haveOnline && $haveOffline)
                {
                    ?></optgroup><?php
                }
				?>
			</select>
		</div>
	</div><!-- /.col-md-3 -->

</div><!-- /.row -->
   
	<div class="hr-line-dashed"></div>
	<div class="row">
		<div class="col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_type');?></label>

			<select name="type_id" id="type_id" class="form-control select-item required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
				<option value="">-- <?php __('lblChoose'); ?>--</option>
				<?php
				if (isset($tpl['type_arr']) && count($tpl['type_arr']) > 0)
				{
					foreach ($tpl['type_arr'] as $v)
					{
						if (isset($tpl['arr']['type_id']) && $tpl['arr']['type_id'] == $v['id']) {
							$daily_mileage_limit = $v['default_distance'];
							$price_for_extra_mileage = $v['extra_price'];
						}
						?><option value="<?php echo $v['id']; ?>" <?php echo isset($tpl['arr']['type_id']) && $tpl['arr']['type_id'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo $v['name']; ?></option><?php
					}
				}
				?>
			</select>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_car');?></label>
			<div id="boxCars">
				<select name="car_id" id="car_id" class="form-control select-item required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
					<option value="">-- <?php __('lblChoose'); ?>--</option>
					<?php
					foreach ($tpl['car_arr'] as $v)
					{
					    ?><option value="<?php echo $v['car_id']; ?>" <?php echo isset($tpl['arr']['car_id']) && $tpl['arr']['car_id'] == $v['car_id'] ? 'selected="selected"' : '';?>><?php echo pjSanitize::html($v['make'] . " " . $v['model'] . " - " . $v['registration_number']); ?></option><?php
					}
					?>
				</select>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_pickup');?></label>

			<select name="pickup_id" id="pickup_id" class="form-control select-item required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-remote="<?php __('lblPickupWorkingTime');?>">
				<option value="">-- <?php __('lblChoose'); ?>--</option>
				<?php
				if (isset($tpl['pickup_arr']) && count($tpl['pickup_arr']) > 0)
				{
					foreach ($tpl['pickup_arr'] as $v)
					{
					    ?><option value="<?php echo $v['id']; ?>" <?php echo isset($tpl['arr']['pickup_id']) && $tpl['arr']['pickup_id'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo $v['name']; ?></option><?php
					}
				}
				?>
			</select>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_return');?></label>

			<select name="return_id" id="return_id" class="form-control select-item required" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-remote="<?php __('lblReturnWorkingTime');?>">
				<option value="">-- <?php __('lblChoose'); ?>--</option>
				<?php
				if (isset($tpl['return_arr']) && count($tpl['return_arr']) > 0)
				{
					foreach ($tpl['return_arr'] as $v)
					{
					    ?><option value="<?php echo $v['id']; ?>" <?php echo isset($tpl['arr']['return_id']) && $tpl['arr']['return_id'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo $v['name']; ?></option><?php
					}
				}
				?>
			</select>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-9">
		<div class="form-group">
			<div class="table-responsive table-responsive-secondary">
				<table class="table table-striped table-hover" id="tblExtras">
					<thead>
						<tr>
							<th><?php __('lblExtra'); ?></th>
							<th><?php __('lblPrice'); ?></th>
							<th><?php __('lblQty'); ?></th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<?php if (isset($tpl['be_arr']) && count($tpl['be_arr']) > 0) { 
							$per_extra = __('per_extras', true, false);
							foreach ($tpl['be_arr'] as $key => $extra_id) { 
								mt_srand();
								$index = 'x_' . mt_rand();
								?>
								<tr data-idx="<?php echo $index; ?>">
									<td>
										<select name="ex_id[<?php echo $index; ?>]" class="form-control pj-extra-item">
											<option value="" data-type="multi" data-original_price="" data-price="">-- <?php __('lblChoose'); ?> --</option>
											<?php
											if (isset($tpl['extra_arr']))
											{
												foreach ($tpl['extra_arr'] as $v)
												{
												    ?><option value="<?php echo $v['extra_id']; ?>" <?php echo $v['extra_id'] == $extra_id ? ' selected="selected"' : NULL; ?> data-type="<?php echo $v['type'];?>" data-original_price="<?php echo (float)$v['price'];?>" data-price="<?php echo pjCurrency::formatPrice($v['price']) . ' ' . $per_extra[$v['per']]; ?>"><?php echo pjSanitize::html($v['name']); ?></option><?php
												}
											}
											?>
										</select>
									</td>
									<td>
										<input type="hidden" name="ex_price[<?php echo $index; ?>]" id="ex_price_<?php echo $index; ?>" value="<?php echo isset($tpl['extra_price_arr'][$extra_id]['price']) ? $tpl['extra_price_arr'][$extra_id]['price'] : '';?>" class="form-control" />
										<div class="pj-extra-price"><?php echo isset($tpl['extra_price_arr'][$extra_id]['price']) ? (pjCurrency::formatPrice($tpl['extra_price_arr'][$extra_id]['price']).' '.$per_extra[$tpl['extra_price_arr'][$extra_id]['per']]) : null;?></div>
									</td>
									<td>
										<input type="text" name="ex_cnt[<?php echo $index; ?>]" id="ex_cnt_<?php echo $index; ?>" value="<?php echo isset($tpl['be_quantity_arr'][$extra_id]) ? (int)$tpl['be_quantity_arr'][$extra_id] : 1;?>" class="form-control extra-touchspin3 text-right pj-extra-qty" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
									</td>
									<td>
										<a href="javascript:void(0);" class="btn btn-danger btn-outline btn-sm btn-delete crRemoveExtra"><i class="fa fa-trash"></i></a>
									</td>
									
								</tr>
							<?php } ?>
						<?php } ?>
					</tbody>
				</table>
			</div>
		</div>
	</div><!-- /.col-sm-6 -->

	<div class="col-sm-3">
		<div class="m-t-lg">
			<a href="javascript:void(0);" class="btn btn-primary m-t-xs crAddExtra"><i class="fa fa-plus"></i> <?php __('btnBookingAddExtra', false, true); ?></a>
		</div>
	</div><!-- /.col-sm-6 -->
</div><!-- /.row -->

<div class="hr-line-dashed"></div>

	<div class="clearfix">
		<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in" style="margin-right: 15px;">
		<span class="ladda-label"><?php __('btnSave'); ?></span>
		<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
	</button>
	<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
</div><!-- /.clearfix -->