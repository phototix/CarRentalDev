<?php if(count($tpl['extra_arr']) > 0) { 
	mt_srand();
	$index = 'x_' . mt_rand();
	$per_extra = __('per_extras', true, false);
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
						?><option value="<?php echo $v['extra_id']; ?>" data-type="<?php echo $v['type'];?>" data-original_price="<?php echo (float)$v['price'];?>" data-price="<?php echo pjCurrency::formatPrice($v['price']) . ' ' . $per_extra[$v['per']]; ?>"><?php echo stripslashes($v['name']); ?></option><?php
					}
				}
				?>
			</select>
		</td>
		<td>
			<input type="hidden" name="ex_price[<?php echo $index; ?>]" id="ex_price_<?php echo $index; ?>" value="" class="form-control" />
			<div class="pj-extra-price"></div>
		</td>
		<td>
			<input type="text" name="ex_cnt[<?php echo $index; ?>]" id="ex_cnt_<?php echo $index; ?>" value="1" class="form-control extra-touchspin3 text-right pj-extra-qty" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
		</td>
		<td>
			<a href="javascript:void(0);" class="btn btn-danger btn-outline btn-sm btn-delete crRemoveExtra"><i class="fa fa-trash"></i></a>
		</td>
		
	</tr>
<?php }?>
