<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$time_format = 'HH:mm';
if((strpos($tpl['option_arr']['o_time_format'], 'a') > -1))
{
    $time_format = 'hh:mm a';
}
if((strpos($tpl['option_arr']['o_time_format'], 'A') > -1))
{
    $time_format = 'hh:mm A';
}
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
$bs = __('booking_statuses', true);
?>
<div id="dateTimePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-dateformat="<?php echo pjUtil::toMomemtJS($tpl['option_arr']['o_date_format']); ?>" data-format="<?php echo pjUtil::toMomemtJS($tpl['option_arr']['o_date_format']); ?> <?php echo $time_format;?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12">
		<div class="row">
			<div class="col-lg-9 col-md-8 col-sm-6">
				<h2><?php __('infoUpdateBookingTitle');?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoUpdateBookingDesc');?></p>
	</div><!-- /.col-md-12 -->
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<?php
	$error_code = $controller->_get->toString('err');
	if (!empty($error_code))
	{
		switch (true)
		{
			case in_array($error_code, array('AR01', 'AR03')):
				?>
				<div class="alert alert-success">
					<i class="fa fa-check m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code]?>
				</div>
				<?php 
				break;
			case in_array($error_code, array('AR04', 'AR08', 'AR09', 'AR10')):	
				?>
				<div class="alert alert-danger">
					<i class="fa fa-exclamation-triangle m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code]?>
				</div>
				<?php
				break;
		}
	} 
	$tab = $controller->_get->check('tab') ? $controller->_get->toInt('tab') : 0;
	$created = strtotime($tpl['arr']['created']);
	$from_ts = strtotime($tpl['arr']['from']);
	$to_ts = strtotime($tpl['arr']['to']);
	$date_from = date($tpl['option_arr']['o_date_format'], $from_ts)." ".date('H:i',$from_ts);
	$date_to = date($tpl['option_arr']['o_date_format'], $to_ts)." ".date('H:i',$to_ts);
	$created_datetime = date($tpl['option_arr']['o_date_format'], $created)." ".date($tpl['option_arr']['o_time_format'], $created);
	
	$rental_time = '';
	$rental_days = $tpl['arr']['rental_days'];
	$hours = $tpl['arr']['rental_hours'];
	$daily_mileage_limit = 0;
	$price_for_extra_mileage = 0;
	if($rental_days > 0 || $tpl['arr']['rental_hours'] > 0){
		if($tpl['arr']['rental_days'] > 0){
			$rental_time .= $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false));
		}
		if($hours > 0){
			$rental_time .= ' ' . $hours . ' ' . ($hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false));
		}
	}
	$rental_fee_detail = array();
	$sum = (float)$tpl['arr']['car_rental_fee'] + (float)$tpl['arr']['extra_price'];
	?>
	<div class="col-lg-9">
		<div class="tabs-container m-b-lg">
			<ul class="nav nav-tabs booking-tabs" role="tablist">
				<li role="presentation" class="<?php echo $tab == 0 ? 'active' : '';?>"><a href="#booking-details" aria-controls="booking-details" role="tab" data-toggle="tab" data-tab="0" class="tab-booking-details"><?php __('lblBookingDetails') ?></a></li>
				<li role="presentation" class="<?php echo $tab == 1 ? 'active' : '';?>"><a href="#client-details" aria-controls="client-details" role="tab" data-toggle="tab" data-tab="1" class="tab-client-details"><?php __('lblClientDetails') ?></a></li>
				<li role="presentation" class="<?php echo $tab == 2 ? 'active' : '';?>"><a href="#booking-collect" aria-controls="booking-collect" role="tab" data-toggle="tab" data-tab="2" class="tab-booking-collect"><?php __('lblBookingCollect') ?></a></li>
				<li role="presentation" class="<?php echo $tab == 3 ? 'active' : '';?>"><a href="#booking-return" aria-controls="booking-return" role="tab" data-toggle="tab" data-tab="3" class="tab-booking-return"><?php __('lblBookingReturn') ?></a></li>
				<li role="presentation" class="<?php echo $tab == 4 ? 'active' : '';?>"><a href="#booking-payments" aria-controls="booking-payments" role="tab" data-toggle="tab" data-tab="4" class="tab-booking-payments"><?php __('lblBookingPayments') ?></a></li>
			</ul>        	
			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionUpdate" method="post" id="frmUpdate" class="form pj-form" autocomplete="off" enctype="multipart/form-data">
				<input type="hidden" name="booking_update" value="1" />
				<input type="hidden" name="tab_id" id="tab_id" value="0" />
				<input type="hidden" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
				<input type="hidden" id="rental_days" name="rental_days" value="<?php echo $tpl['arr']['rental_days']; ?>"/>
				<input type="hidden" id="rental_hours" name="rental_hours" value="<?php echo $tpl['arr']['rental_hours']; ?>"/>
				<input type="hidden" id="price_per_day" name="price_per_day" value="<?php echo $tpl['arr']['price_per_day']; ?>" />
				<input type="hidden" id="price_per_day_detail" name="price_per_day_detail" value="<?php echo !empty($tpl['arr']['price_per_day_detail']) ? $tpl['arr']['price_per_day_detail'] : null; ?>"/>
				<input type="hidden" id="price_per_hour" name="price_per_hour" value="<?php echo $tpl['arr']['price_per_hour']; ?>"/>
				<input type="hidden" id="price_per_hour_detail" name="price_per_hour_detail" value="<?php echo !empty($tpl['arr']['price_per_hour_detail']) ? $tpl['arr']['price_per_hour_detail'] : null; ?>"/>
				<input type="hidden" id="car_rental_fee" name="car_rental_fee" value="<?php echo $tpl['arr']['car_rental_fee']; ?>"/>
				<input type="hidden" id="extra_price" name="extra_price" value="<?php echo $tpl['arr']['extra_price']; ?>" />
				<input type="hidden" id="insurance" name="insurance" value="<?php echo $tpl['arr']['insurance']; ?>"/>
				<input type="hidden" id="sub_total" name="sub_total" value="<?php echo $tpl['arr']['sub_total']; ?>"/>
				<input type="hidden" id="tax" name="tax" value="<?php echo $tpl['arr']['tax']; ?>"/>
				<input type="hidden" id="total_price" name="total_price" value="<?php echo $tpl['arr']['total_price']; ?>"/>
				<input type="hidden" id="required_deposit" name="required_deposit" value="<?php echo $tpl['arr']['required_deposit']; ?>"/>
				<input type="hidden" id="security_deposit" name="security_deposit" value="<?php echo $tpl['arr']['security_deposit']; ?>"/>
				
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane <?php echo $tab == 0 ? 'active' : '';?>" id="booking-details">
						<div class="panel-body">
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/booking_details.php';?>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane <?php echo $tab == 1 ? 'active' : '';?>" id="client-details">
						<div class="panel-body">
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/client_details.php';?>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane <?php echo $tab == 2 ? 'active' : '';?>" id="booking-collect">
						<div class="panel-body">
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/booking_collect.php';?>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane <?php echo $tab == 3 ? 'active' : '';?>" id="booking-return">
						<div class="panel-body">
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/booking_return.php';?>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane <?php echo $tab == 4 ? 'active' : '';?>" id="booking-payments">
						<div class="panel-body">
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/booking_payments.php';?>
						</div>
					</div>
			   </div>
			</form>
		</div>
	</div>
	<div class="col-lg-3">
		<div class="m-b-lg">
			<div class="panel no-borders ibox-content">
				<div class="sk-spinner sk-spinner-double-bounce"><div class="sk-double-bounce1"></div><div class="sk-double-bounce2"></div></div>
				<?php 
				foreach($bs as $k => $status) 
				{
					?>
					<div class="panel-heading bg-status bg-<?php echo $k; ?>"<?php echo $k == $tpl['arr']['status'] ? '' : ' style="display:none"'; ?>>
						<p class="lead m-n"><i class="fa fa-check"></i> <?php __('lblStatus'); ?>: <span class="pull-right status-text"><?php echo $status; ?></span></p>    
					</div>
					<?php 
				}
				?>
				<div class="panel-body pj-price-details">
					<p class="lead m-b-xs"><span><a href="javascript:void(0);" class="btn btn-primary btn-md btn-block btn-outline" id="btnEmailConfirm" data-id="<?php echo $tpl['arr']['id'];?>"><i class="fa fa-envelope"></i> <?php __('booking_email_reminder'); ?></a></span></p>

                    <p class="lead m-b-xs"><span><a href="javascript:void(0);" class="btn btn-primary btn-md btn-block btn-outline" id="btnSmsConfirm" data-id="<?php echo $tpl['arr']['id'];?>"><i class="fa fa-phone"></i> <?php __('booking_sms_reminder'); ?></a></span></p>

                    <div class="hr-line-dashed"></div>
					
					
					<p class="lead m-b-md"><?php __('lblRentalDuration'); ?>: <span id="cr_rental_time" class="pull-right"><?php echo $rental_time;?></span></p>
					
					<p class="lead" style="display:<?php echo in_array($tpl['option_arr']['o_booking_periods'], array('both', 'perday')) ? 'block' : 'none';?>"><?php __('lblPricePerDay'); ?>: <span id="cr_price_per_day" class="pull-right"><?php echo $rental_fee_detail[] = pjCurrency::formatPrice($tpl['arr']['price_per_day']);?></span></p>
					<p class="m-b-md" id="cr_price_per_day_detail"><?php echo $tpl['arr']['price_per_day_detail']; ?></p>
					
					<p class="lead" style="display:<?php echo in_array($tpl['option_arr']['o_booking_periods'], array('both', 'perhour')) ? 'block' : 'none';?>"><?php __('lblPricePerHour'); ?>: <span id="cr_price_per_hour" class="pull-right"><?php echo $rental_fee_detail[] = pjCurrency::formatPrice($tpl['arr']['price_per_hour']);?></span></p>
					<p class="m-b-md" id="cr_price_per_hour_detail"><?php echo $tpl['arr']['price_per_hour_detail']; ?></p>
					
					<div class="hr-line-dashed"></div>
					<p class="lead"><?php __('lblCarRentalFee'); ?>: <span id="cr_rental_fee" class="pull-right"><?php echo pjCurrency::formatPrice($tpl['arr']['car_rental_fee']);?></span></p>
					<p class="m-b-md" id="cr_rental_fee_detail"><?php echo join(' + ', $rental_fee_detail);?></p>
					
					<p class="lead m-b-md"><?php __('booking_extra_price'); ?>: <span id="cr_extra_price" class="pull-right"><?php echo pjCurrency::formatPrice($tpl['arr']['extra_price']);?></span></p>
					
					<p class="lead"><?php __('booking_insurance'); ?>: <span id="cr_insurance" class="pull-right"><?php echo pjCurrency::formatPrice($tpl['arr']['insurance']);?></span></p>
					<p class="m-b-md" id="cr_insurance_detail">
						<?php
						$insurance_types = __('insurance_type_arr', true, false);
						switch ($tpl['option_arr']['o_insurance_payment_type']) {
							case 'perday':
								echo pjCurrency::formatPrice($tpl['option_arr']['o_insurance_payment']) . ' ' . strtolower($insurance_types['perday']);
							;
							break;
							case 'percent':
								echo $tpl['option_arr']['o_insurance_payment'] . '% ' . __('lblOf', true, false) . ' ' . pjCurrency::formatPrice($sum);
							;
							break;
							case 'perbooking':
								echo pjCurrency::formatPrice($tpl['option_arr']['o_insurance_payment']) . ' ' . strtolower($insurance_types['perbooking']);
							;
							break;
						}
						$sum += (float) $tpl['arr']['insurance'];
						?>
					</p>
					
					<div class="hr-line-dashed"></div>
					<p class="lead m-b-md"><?php __('booking_subtotal'); ?>: <span id="cr_sub_total" class="pull-right"><?php echo pjCurrency::formatPrice($tpl['arr']['sub_total']);?></span></p>
					
					<p class="lead"><?php __('booking_tax'); ?>: <span id="cr_tax" class="pull-right"><?php echo pjCurrency::formatPrice($tpl['arr']['tax']);?></span></p>
					<p class="m-b-md" id="cr_tax_detail">
						<?php
						if($tpl['option_arr']['o_tax_type'] == 'percent')
						{
							echo $tpl['option_arr']['o_tax_payment'] . '% ' . __('lblOf', true, false) . ' ' . pjCurrency::formatPrice($tpl['arr']['sub_total']);
						}
						?>
					</p>
					
					<div class="hr-line-dashed"></div>
	
					<h3 class="lead m-b-md"><?php __('booking_total_price'); ?>: <strong id="cr_total_price" class="pull-right text-right"><?php echo pjCurrency::formatPrice($tpl['arr']['total_price']);?></strong></h3>
					<p class="lead"><?php __('booking_required_deposit'); ?>: <span id="cr_required_deposit" class="pull-right text-right"><?php echo pjCurrency::formatPrice($tpl['arr']['required_deposit']);?></span></p>
					<p class="m-b-md" id="cr_required_deposit_detail">
						<?php
						switch ($tpl['option_arr']['o_deposit_type'])
						{
							case 'percent':
								echo $tpl['option_arr']['o_deposit_payment'] . '% ' . __('lblOf', true, false) . ' ' . pjCurrency::formatPrice($tpl['arr']['total_price']);
								break;
							case 'amount':
								break;
						}
						?>
					</p>
				</div><!-- /.panel-body -->
			</div>
	
		</div><!-- /.m-b-lg -->
	</div>
</div><!-- /.wrapper wrapper-content -->
<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/payments_clone.php';?>


<div class="modal fade" id="confirmEmailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        	<h4 class="modal-title"><?php __('booking_email_confirmation'); ?></h4>
		      </div>
		      <div id="emailContentWrapper" class="modal-body"></div>
		      <div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel');?></button>
		        	<button id="btnSendEmailConfirm" type="button" class="btn btn-primary"><?php __('btnSend');?></button>
		      </div>
	    </div><!-- /.modal-content -->
  	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="confirmSmsModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        	<h4 class="modal-title"><?php __('booking_sms_confirmation'); ?></h4>
		      </div>
		      <div id="smsContentWrapper" class="modal-body"></div>
		      <div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel');?></button>
		        	<button id="btnSendSmsConfirm" type="button" class="btn btn-primary"><?php __('btnSend');?></button>
		      </div>
	    </div><!-- /.modal-content -->
  	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.choose = <?php x__encode('lblChoose', false, true); ?>;
myLabel.dateRangeValidation = <?php x__encode('lblBookingDateRangeValidation'); ?>;
myLabel.numDaysValidation = <?php x__encode('lblBookingNumDaysValidation'); ?>;
myLabel.phone_not_available = <?php x__encode('lblPhoneNotAvailable'); ?>;
myLabel.security_deposit = "<?php echo $tpl['option_arr']['o_security_payment'];?>";
myLabel.currency = "<?php echo $tpl['option_arr']['o_currency'];?>";
myLabel.mileage_unit = "<?php echo $tpl['option_arr']['o_unit'];?>";
myLabel.months = "<?php echo implode("_", $months);?>";
myLabel.days = "<?php echo implode("_", $short_days);?>";

myLabel.alert_del_payment_title = <?php x__encode('booking_payment_dtitle');?>;
myLabel.alert_del_payment_text = <?php x__encode('booking_payment_dbody');?>;
myLabel.btn_delete = <?php x__encode('btnDelete'); ?>;
myLabel.btn_cancel = <?php x__encode('btnCancel'); ?>;
</script>