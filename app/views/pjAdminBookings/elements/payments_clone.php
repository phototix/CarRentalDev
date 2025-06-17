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
<table id="tblPaymentsClone" style="display: none">
		<tbody>
			<tr>
				<td>
					<select name="p_payment_method[{INDEX}]" class="form-control" >
						<option value="">-- <?php __('plugin_base_choose'); ?> --</option>
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
                            ?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
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
                                    ?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
                                }
                            }
                        }
                        if ($haveOnline && $haveOffline)
                        {
                            ?></optgroup><?php
                        }
        				?>
					</select>
				</td>
				<td>
					<select id="payment_type_{INDEX}" name="p_payment_type[{INDEX}]" class="form-control {PTCLASS}" data-index="{INDEX}">
						<option value="">---<?php __('lblChoose');?>---</option>
						<?php
						foreach (__('payment_types',true) as $k => $v)
						{
							?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
						}
						?>
					</select>
				</td>
				<td>
					<div class="input-group">
						<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false);?></span> 
	
						<input type="text" name="p_amount[{INDEX}]" id="amount_{INDEX}" class="form-control number {ACLASS}" data-index="{INDEX}" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>"> 
					</div>
				</td>
				<td>
					<select id="payment_status_{INDEX}" name="p_payment_status[{INDEX}]" class="form-control {SCLASS}" >
						<?php
						foreach (__('payment_statuses',true) as $k => $v)
						{
							?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
						}
						?>
					</select>
				</td>
				<td><a href="javascript:void(0);" class="btn btn-danger btn-outline btn-sm btn-delete btnRemovePayment"><i class="fa fa-trash"></i></a></td>
			</tr>
		</tbody>
	</table>