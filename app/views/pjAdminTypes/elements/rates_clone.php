<table id="tblRatesClone" style="display: none">
	<tbody>
		<tr data-idx="{INDEX}">
			<td>
				<div class="form-group">
					<div class="input-group"> 
						<input type="text" name="date_from[{INDEX}]" id="date_from_{INDEX}" class="form-control datepick required" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" /> 
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
					</div>
				</div>
			</td>
			
			<td>
				<div class="form-group">
					<div class="input-group"> 
						<input type="text" name="date_to[{INDEX}]" id="date_to_{INDEX}" class="form-control datepick required" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" /> 
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
					</div>
				</div>
			</td>

			<td width="160">
				<div class="form-group">
					<div class="row">
						<div class="col-sm-3"><?php __('lblFrom');?>:</div>
						<div class="col-sm-9">
							<input class="form-control required from-touchspin3-{INDEX}" type="text" name="from[{INDEX}]" id="from_{INDEX}" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
						</div>
					</div>
				</div>
			</td>
			<td width="160">
				<div class="form-group">
					<div class="row">
						<div class="col-sm-3"><?php __('lblTo');?>:</div>
						<div class="col-sm-9">
							<input class="form-control required to-touchspin3-{INDEX}" type="text" name="to[{INDEX}]" id="to_{INDEX}" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
						</div>
					</div>
				</div>
			</td>
			<?php if ($tpl['option_arr']['o_booking_periods'] == 'both') { ?>
			<td>
				<div class="form-group">
					<select name="price_per[{INDEX}]" class="form-control pPeriod" >
						<option value="hour"><?php __('items_hour_plural'); ?></option>
						<option value="day"><?php __('items_day_plural'); ?></option>
					</select>
				</div>
			</td>
			<?php } ?>
			<td width="160">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false);?></span> 
	
						<input type="text" name="price[{INDEX}]" id="price_{INDEX}" class="form-control required number" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>"> 
					</div>
				</div>
			</td>
			<td>
				<div class="form-group">
				<?php
				$items_price_per = __('items_price_per', true);
				?>
				<?php
				if($tpl['option_arr']['o_booking_periods'] == 'both'){ 
					?>
					<span class="pHour" ><?php echo $items_price_per['hour']; ?></span>
					<span class="pDay" style="display: none"><?php echo $items_price_per['day']; ?></span>
					<?php
				}elseif($tpl['option_arr']['o_booking_periods'] == 'perday'){
					?>
					<span class="pDay"><?php echo $items_price_per['day']; ?></span>
					<?php
				}elseif($tpl['option_arr']['o_booking_periods'] == 'perhour'){
					?>
					<span class="pHour"><?php echo $items_price_per['hour']; ?></span>
					<?php
				} 
				?>
				</div>
			</td>
			<td>
				<div class="m-t-xs text-right">
					<div class="form-group">
						<a href="javascript:void(0);" class="btn btn-danger btn-outline btn-sm crRemoveRate"><i class="fa fa-trash"></i></a>
					</div>
				</div>
			</td>
		</tr>
	</tbody>
</table>