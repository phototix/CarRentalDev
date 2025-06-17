<?php
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
				<h2><?php __('infoAddBookingTitle');?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoAddBookingBody');?></p>
	</div><!-- /.col-md-12 -->
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<div class="col-lg-9">
		<div class="tabs-container tabs-reservations m-b-lg">
			<ul class="nav nav-tabs booking-tabs" role="tablist">
        		<li role="presentation" class="active"><a href="#booking-details" aria-controls="booking-details" role="tab" data-toggle="tab" data-tab="0" class="tab-booking-details"><?php __('lblBookingDetails');?></a></li>
        		<li role="presentation"><a href="#client-details" aria-controls="client-details" role="tab" data-toggle="tab" data-tab="1" class="tab-client-details"><?php __('lblClientDetails');?></a></li>
        	</ul>
			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" method="post" id="frmCreate">
	        	<input type="hidden" name="booking_create" value="1" />
	        	<input type="hidden" id="rental_days" name="rental_days"/>
				<input type="hidden" id="rental_hours" name="rental_hours"/>
				<input type="hidden" id="price_per_day" name="price_per_day"/>
				<input type="hidden" id="price_per_day_detail" name="price_per_day_detail"/>
				<input type="hidden" id="price_per_hour" name="price_per_hour"/>
				<input type="hidden" id="price_per_hour_detail" name="price_per_hour_detail" />
				<input type="hidden" id="car_rental_fee" name="car_rental_fee"/>
				<input type="hidden" id="extra_price" name="extra_price" />
				<input type="hidden" id="insurance" name="insurance"/>
				<input type="hidden" id="sub_total" name="sub_total" />
				<input type="hidden" id="tax" name="tax"/>
				<input type="hidden" id="total_price" name="total_price"/>
				<input type="hidden" id="required_deposit" name="required_deposit"/>
				<input type="hidden" id="security_deposit" name="security_deposit"/>
				<input type="hidden" name="tab_id" id="tab_id" value="0" />
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="booking-details">
						<div class="panel-body">					
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/booking_details.php';?>
						</div>
					</div>
		
					<div role="tabpanel" class="tab-pane" id="client-details">
						<div class="panel-body">
							<?php include PJ_VIEWS_PATH . 'pjAdminBookings/elements/client_details.php';?>
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
	                <div class="panel-heading bg-status bg-<?php echo $k; ?>"<?php echo $k == 'pending' ? '' : ' style="display:none"'; ?>>
	                    <p class="lead m-n"><i class="fa fa-check"></i> <?php __('lblStatus'); ?>: <span class="pull-right status-text"><?php echo $status; ?></span></p>    
	                </div>
	                <?php 
            	}
            	?>
                <div class="panel-body pj-price-details">
                	
                    <p class="lead m-b-md"><?php __('lblRentalDuration'); ?>: <span id="cr_rental_time" class="pull-right">0</span></p>
                    
                    <p class="lead" style="display:<?php echo in_array($tpl['option_arr']['o_booking_periods'], array('both', 'perday')) ? 'block' : 'none';?>"><?php __('lblPricePerDay'); ?>: <span id="cr_price_per_day" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
                    <p class="m-b-md" id="cr_price_per_day_detail"></p>
                    
					<p class="lead" style="display:<?php echo in_array($tpl['option_arr']['o_booking_periods'], array('both', 'perhour')) ? 'block' : 'none';?>"><?php __('lblPricePerHour'); ?>: <span id="cr_price_per_hour" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
					<p class="m-b-md" id="cr_price_per_hour_detail"></p>
					
					<div class="hr-line-dashed"></div>
					<p class="lead"><?php __('lblCarRentalFee'); ?>: <span id="cr_rental_fee" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
					<p class="m-b-md" id="cr_rental_fee_detail"></p>
					
					<p class="lead m-b-md"><?php __('booking_extra_price'); ?>: <span id="cr_extra_price" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
					
					<p class="lead"><?php __('booking_insurance'); ?>: <span id="cr_insurance" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
					<p class="m-b-md" id="cr_insurance_detail"></p>
					
					<div class="hr-line-dashed"></div>
					<p class="lead m-b-md"><?php __('booking_subtotal'); ?>: <span id="cr_sub_total" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
					
					<p class="lead"><?php __('booking_tax'); ?>: <span id="cr_tax" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
                    <p class="m-b-md" id="cr_tax_detail"></p>
                    
                    <div class="hr-line-dashed"></div>

                    <h3 class="lead m-b-md"><?php __('booking_total_price'); ?>: <strong id="cr_total_price" class="pull-right text-right"><?php echo pjCurrency::formatPrice(0); ?></strong></h3>
                    <p class="lead"><?php __('booking_required_deposit'); ?>: <span id="cr_required_deposit" class="pull-right text-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
                    <p class="m-b-md" id="cr_required_deposit_detail"></p>
                </div><!-- /.panel-body -->
            </div>
        </div><!-- /.m-b-lg -->
    </div>
</div><!-- /.wrapper wrapper-content -->

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.choose = <?php x__encode('lblChoose', false, true); ?>;
myLabel.dateRangeValidation = <?php x__encode('lblBookingDateRangeValidation'); ?>;
myLabel.numDaysValidation = <?php x__encode('lblBookingNumDaysValidation'); ?>;
myLabel.months = "<?php echo implode("_", $months);?>";
myLabel.days = "<?php echo implode("_", $short_days);?>";
</script>