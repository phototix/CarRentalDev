<div class="alert alert-success">
	<i class="fa fa-check m-r-xs"></i>
	<strong><?php echo __('infoUpdatePaymentTitle', true); ?></strong>
	<?php echo __('infoUpdatePaymentDesc', true);?>
</div>
<div class="row">
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_total_price'); ?> <span class="booking-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblTotalPriceTip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>

			<p class="fz16 cr-total-quote"><?php echo pjCurrency::formatPrice($tpl['arr']['total_price']);?></p>
		</div>
	</div>
	
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_payments_made'); ?> <span class="booking-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblPaymentMadeTip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>

			<p class="fz16"><span id="pj_collected"><?php echo pjCurrency::formatPrice($tpl['collected']);?></span></p>
		</div>
	</div>
	
	<div class="col-md-4 col-sm-6">
		<div class="form-group">
			<label class="control-label"><?php __('booking_payment_due'); ?> <span class="booking-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblPaymentDueTip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>

			<p class="fz16">
				<span id="pj_due_payment"  class="cr-due-payment">
				<?php
				$amount_due = $tpl['arr']['total_price'] - $tpl['collected'];				
				if($amount_due < 0)
				{
					$amount_due = 0;
				}
				echo pjCurrency::formatPrice($amount_due);
				?>
				</span>
			</p>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-xs-12">
		<div class="table-responsive table-responsive-secondary">
			<table class="table table-striped table-hover" id="tblPayment">
				<thead>
					<tr>
						<th><?php __('booking_payment_method'); ?></th>
						<th><?php __('booking_payment_type'); ?></th>
						<th><?php __('booking_payment_amount'); ?></th>
						<th><?php __('booking_payment_status'); ?></th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<?php
						if (isset($tpl['payment_arr']) && count($tpl['payment_arr']) > 0)
						{
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
							foreach ($tpl['payment_arr'] as $payment)
							{
								?>
								<tr>
									<td>
										<select name="p_payment_method[<?php echo $payment['id']; ?>]" class="form-control">
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
                                                ?><option value="<?php echo $k; ?>"<?php echo isset($payment['payment_method']) && $payment['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
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
                                                        ?><option value="<?php echo $k; ?>"<?php echo isset($payment['payment_method']) && $payment['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
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
										<select id="payment_type_<?php echo $payment['id']; ?>" name="p_payment_type[<?php echo $payment['id']; ?>]" data-index="<?php echo $payment['id']; ?>" class="form-control pj-payment-type" >
											<option value="">---<?php __('lblChoose');?>---</option>
											<?php
											foreach (__('payment_types',true) as $k => $v)
											{
												?><option value="<?php echo $k; ?>"<?php echo $payment['payment_type'] == $k ? 'selected="selected"' : null;?>><?php echo $v; ?></option><?php
											}
											?>
										</select>
									</td>
									<td>
										<div class="input-group">
											<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false);?></span> 
						
											<input type="text" name="p_amount[<?php echo $payment['id']; ?>]" id="amount_<?php echo $payment['id']; ?>" class="form-control number pj-payment-amount" data-index="<?php echo $payment['id']; ?>" value="<?php echo (float) $payment['amount']; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>"> 
										</div>
									</td>
									<td>
										<select id="payment_status_<?php echo $payment['id']; ?>" name="p_payment_status[<?php echo $payment['id']; ?>]" class="form-control pj-payment-status" >
											<?php
											foreach (__('payment_statuses',true) as $k => $v)
											{
												?><option value="<?php echo $k; ?>"<?php echo $payment['status'] == $k ? 'selected="selected"' : null;?>><?php echo $v; ?></option><?php
											}
											?>
										</select>
									</td>
									<td><a class="btn btn-danger btn-outline btn-sm btn-delete btnDeletePayment" href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionDeletePayment&amp;id=<?php echo $payment['id'];?>" data-id="<?php echo $payment['id']; ?>"><i class="fa fa-trash"></i></a></td>
								</tr>
								<?php
							}
						} else {
							?>
							<tr class="notFound">
								<td colspan="5"><?php __('lblNoRecordsFound');?></td>
							</tr>
							<?php
						}
						?>
				</tbody>
			</table>
		</div>
	</div>
	<div class="col-xs-12">
		<a href="javascript:void(0);" class="btn btn-primary m-t-xs btnAddPayment"><i class="fa fa-plus"></i> <?php __('btnBookingAddPayment', false, true); ?></a>
	</div><!-- /.col-sm-6 -->
</div>


<div class="hr-line-dashed"></div>

	<div class="clearfix">
		<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in" style="margin-right: 15px;">
		<span class="ladda-label"><?php __('btnSave'); ?></span>
		<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
	</button>
	<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
</div><!-- /.clearfix -->