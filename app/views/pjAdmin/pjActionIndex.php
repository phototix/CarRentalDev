<?php 
$today = pjDateTime::formatDate(date('Y-m-d'), 'Y-m-d', $tpl['option_arr']['o_date_format']);
$months = __('months', true);
ksort($months);
$bs = __('booking_statuses', true); 
?>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5><?php __('label_today');?></h5>
		</div>
		<div class="ibox-content">
			<div class="row">
				<div class="col-sm-3 col-xs-6">
					<p class="h1 no-margins"><?php echo $tpl['cnt_new_reservations_today'];?></p>
					<small class="text-info"><?php echo (int) $tpl['cnt_new_reservations_today'] !== 1 ? strtolower(__('lblDashNewTodayPlural', true)) : strtolower(__('lblDashNewTodaySingular', true)); ?></small>        
				</div><!-- /.col-xs-6 -->
	
				<div class="col-sm-3 col-xs-6">
					<p class="h1 no-margins"><?php echo $tpl['cnt_today_pickup'];?></p>
					<small class="text-info"><?php echo (int) $tpl['cnt_today_pickup'] !== 1 ? strtolower(__('lblDashPickupsToday', true)) : strtolower(__('lblDashPickupToday', true)); ?></small>        
				</div><!-- /.col-xs-6 -->

				<div class="col-sm-3 col-xs-6">
					<p class="h1 no-margins"><?php echo $tpl['cnt_today_return'];?></p>
					<small class="text-info"><?php echo (int) $tpl['cnt_today_return'] !== 1 ? strtolower(__('lblDashReturnsToday', true)) : strtolower(__('lblDashReturnToday', true)); ?></small>        
				</div><!-- /.col-xs-6 -->
				
				<div class="col-sm-3 col-xs-6">
					<p class="h1 no-margins"><?php echo $tpl['cnt_avail_today'];?></p>
					<small class="text-info"><?php echo (int) $tpl['cnt_avail_today'] !== 1 ? strtolower(__('lblDashAvailCarsToday', true)) : strtolower(__('lblDashAvailCarToday', true)); ?></small>        
				</div><!-- /.col-xs-6 -->
			</div><!-- /.row -->
		</div>
	</div><!-- /.row -->

	<div class="row">
		<div class="col-lg-4">
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('lblDashLatestBookings');?></h3>
						<small>
						<?php
						if (count($tpl['latest_bookings']) != 1) { 
							echo sprintf(__('lblDashTotalBookingsToday', true), count($tpl['latest_bookings']));
						} else {
							echo sprintf(__('lblDashTotalBookingToday', true), count($tpl['latest_bookings']));
						}
						?>
						</small>
					</div><!-- /.pull-left -->
					<?php if (pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess()) { ?>
					<div class="pull-right m-t-md">
						<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex" class="btn btn-primary btn-sm btn-outline m-n"><?php __('lblDashViewAll');?></a>
					</div><!-- /.pull-right -->
					<?php } ?>
				</div>

				<div class="ibox-content inspinia-timeline">
					<?php if (count($tpl['latest_bookings']) > 0) { 
						$url_update = 'javascript:void(0);';
						foreach ($tpl['latest_bookings'] as $k => $v) { 
							$rental_time = '';
							$rental_days = $v['rental_days'];
							$rental_hours = $v['rental_hours'];
							if($rental_days > 0 || $rental_hours > 0){
								if($rental_days > 0){
									$rental_time .= $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false));
								}
								if($rental_hours > 0){
									$rental_time .= ' ' . $rental_hours . ' ' . ($rental_hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false));
								}
							}
							if (pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess()) {
								$url_update = $_SERVER['PHP_SELF'].'?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id='.$v['id'];
							}
							?>
							<div class="timeline-item">
								<div class="row">
									<div class="col-xs-3 date">
										<i class="fa fa-calendar"></i>
										<?php echo date('dS', strtotime($v['from']));?>, <?php echo @$months[date('n', strtotime($v['from']))];?> <?php echo date($tpl['option_arr']['o_time_format'], strtotime($v['from']));?>
									</div>
									<div class="col-xs-7 content">
										<a href="<?php echo $url_update; ?>">
											<p class="m-b-xs"><strong><?php echo pjSanitize::html($v['c_name']);?></strong></p>
											<p class="m-n"><?php __('booking_id')?>: <em><?php echo pjSanitize::clean($v['booking_id']);?></em></p>
											<p class="m-n"><?php __('booking_total_price')?>: <em><?php echo pjCurrency::formatPrice($v['total_price']);?></em></p>
											<p class="m-n"><?php __('lblDashPickup')?>: <em><?php echo date($tpl['option_arr']['o_date_format'], strtotime($v['from'])); ?></em></p>
											<p class="m-n"><?php __('lblDashReturn')?>: <em><?php echo date($tpl['option_arr']['o_date_format'], strtotime($v['to'])); ?></em></p>
											<p class="m-n"><?php __('lblRentalDuration')?>: <em><?php echo $rental_time;?></em></p>										
											<p class="m-n"><?php __('lblDashCarAssigned')?>: <em><?php echo pjSanitize::clean($v['car_type']);?>, <?php echo pjSanitize::clean($v['car_name']);?></em></p>
										</a>
									</div>
		
									<div class="badge bg-<?php echo $v['status'];?> b-r-sm pull-right m-t-md m-r-sm"><?php echo @$bs[$v['status']];?></div>
								</div>
							</div>
						<?php } ?>
					<?php } else { ?>
						<p><?php __('lblDashNoBookingsFound');?></p>
					<?php } ?>
				</div>
			</div>
		</div><!-- /.col-lg-4 -->

		<div class="col-lg-4">
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('lblDashTodayPickups');?></h3>
						<small><?php echo sprintf(__('lblDashTotalPickupToday', true), count($tpl['today_pickups']));?></small>
					</div><!-- /.pull-left -->
					<?php if (pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess()) { ?>
					<div class="pull-right m-t-md">
						<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex&amp;filter=p_today" class="btn btn-primary btn-sm btn-outline m-n"><?php __('lblDashViewAll');?></a>
					</div><!-- /.pull-right -->
					<?php } ?>
				</div>

				<div class="ibox-content inspinia-timeline">
					<?php if (count($tpl['today_pickups']) > 0) { 
						$url_update = 'javascript:void(0);';
						foreach ($tpl['today_pickups'] as $k => $v) { 
							$rental_time = '';
							$rental_days = $v['rental_days'];
							$rental_hours = $v['rental_hours'];
							if($rental_days > 0 || $rental_hours > 0){
								if($rental_days > 0){
									$rental_time .= $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false));
								}
								if($rental_hours > 0){
									$rental_time .= ' ' . $rental_hours . ' ' . ($rental_hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false));
								}
							}
							if (pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess()) {
								$url_update = $_SERVER['PHP_SELF'].'?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id='.$v['id'];
							}
							?>
							<div class="timeline-item">
								<div class="row">
									<div class="col-xs-3 date">
										<i class="fa fa-calendar"></i>
										<?php echo date('dS', strtotime($v['from']));?>, <?php echo @$months[date('n', strtotime($v['from']))];?> <?php echo date($tpl['option_arr']['o_time_format'], strtotime($v['from']));?>
									</div>
									<div class="col-xs-7 content">
										<a href="<?php echo $url_update; ?>">
											<p class="m-b-xs"><strong><?php echo pjSanitize::html($v['c_name']);?></strong></p>
											<p class="m-n"><?php __('booking_id')?>: <em><?php echo pjSanitize::clean($v['booking_id']);?></em></p>
											<p class="m-n"><?php __('booking_total_price')?>: <em><?php echo pjCurrency::formatPrice($v['total_price']);?></em></p>
											<p class="m-n"><?php __('lblDashPickup')?>: <em><?php echo date($tpl['option_arr']['o_date_format'], strtotime($v['from'])); ?></em></p>
											<p class="m-n"><?php __('lblDashReturn')?>: <em><?php echo date($tpl['option_arr']['o_date_format'], strtotime($v['to'])); ?></em></p>
											<p class="m-n"><?php __('lblRentalDuration')?>: <em><?php echo $rental_time;?></em></p>										
											<p class="m-n"><?php __('lblDashCarAssigned')?>: <em><?php echo pjSanitize::clean($v['car_type']);?>, <?php echo pjSanitize::clean($v['car_name']);?></em></p>
										</a>
									</div>
		
									<div class="badge bg-<?php echo $v['status'];?> b-r-sm pull-right m-t-md m-r-sm"><?php echo @$bs[$v['status']];?></div>
								</div>
							</div>
						<?php } ?>
					<?php } else { ?>
						<p><?php __('lblDashNoCarsFound');?></p>
					<?php } ?>
				</div>
			</div>
			
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('lblDashTodayReturns');?></h3>
						<small><?php echo sprintf(__('lblDashTotalReturnToday', true), count($tpl['today_returns']));?></small>
					</div><!-- /.pull-left -->
					<?php if (pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess()) { ?>
					<div class="pull-right m-t-md">
						<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex&amp;filter=r_today" class="btn btn-primary btn-sm btn-outline m-n"><?php __('lblDashViewAll');?></a>
					</div><!-- /.pull-right -->
					<?php } ?>
				</div>

				<div class="ibox-content inspinia-timeline">
					<?php if (count($tpl['today_returns']) > 0) { 
						$url_update = 'javascript:void(0);';
						foreach ($tpl['today_returns'] as $k => $v) { 
							$rental_time = '';
							$rental_days = $v['rental_days'];
							$rental_hours = $v['rental_hours'];
							if($rental_days > 0 || $rental_hours > 0){
								if($rental_days > 0){
									$rental_time .= $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false));
								}
								if($rental_hours > 0){
									$rental_time .= ' ' . $rental_hours . ' ' . ($rental_hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false));
								}
							}
							if (pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess()) {
								$url_update = $_SERVER['PHP_SELF'].'?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id='.$v['id'];
							}
							?>
							<div class="timeline-item">
								<div class="row">
									<div class="col-xs-3 date">
										<i class="fa fa-calendar"></i>
										<?php echo date('dS', strtotime($v['from']));?>, <?php echo @$months[date('n', strtotime($v['from']))];?> <?php echo date($tpl['option_arr']['o_time_format'], strtotime($v['from']));?>
									</div>
									<div class="col-xs-7 content">
										<a href="<?php echo $url_update; ?>">
											<p class="m-b-xs"><strong><?php echo pjSanitize::html($v['c_name']);?></strong></p>
											<p class="m-n"><?php __('booking_id')?>: <em><?php echo pjSanitize::clean($v['booking_id']);?></em></p>
											<p class="m-n"><?php __('booking_total_price')?>: <em><?php echo pjCurrency::formatPrice($v['total_price']);?></em></p>
											<p class="m-n"><?php __('lblDashPickup')?>: <em><?php echo date($tpl['option_arr']['o_date_format'], strtotime($v['from'])); ?></em></p>
											<p class="m-n"><?php __('lblDashReturn')?>: <em><?php echo date($tpl['option_arr']['o_date_format'], strtotime($v['to'])); ?></em></p>
											<p class="m-n"><?php __('lblRentalDuration')?>: <em><?php echo $rental_time;?></em></p>										
											<p class="m-n"><?php __('lblDashCarAssigned')?>: <em><?php echo pjSanitize::clean($v['car_type']);?>, <?php echo pjSanitize::clean($v['car_name']);?></em></p>
										</a>
									</div>
		
									<div class="badge bg-<?php echo $v['status'];?> b-r-sm pull-right m-t-md m-r-sm"><?php echo @$bs[$v['status']];?></div>
								</div>
							</div>
						<?php } ?>
					<?php } else { ?>
						<p><?php __('lblDashNoCarsFound');?></p>
					<?php } ?>
				</div>
			</div>
			
		</div><!-- /.col-lg-4 -->

		<div class="col-lg-4">
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<h3><?php __('lblDashQuickLinks');?></h3>
				</div>

				<div class="ibox-content inspinia-timeline">
					<?php
					if(pjAuth::factory('pjAdminCars', 'pjActionAvailability')->hasAccess())
					{
						?>
						<p><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminCars&amp;action=pjActionAvailability"><?php __('lblDashCarAvailability'); ?></a></p>
						<?php
					}
					if (pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess())
					{
						?>
						<p><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex&amp;filter=p_tomorrow"><?php __('lblDashTomorrowPickups'); ?></a></p>
						<p><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex&amp;filter=r_tomorrow"><?php __('lblDashTomorrowReturns'); ?></a></p>
					<?php 
					}
					?>
					<p><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionPreview" target="_blank"><?php __('lblDashFrontEndPreview'); ?></a></p>
				</div>
			</div>
		</div><!-- /.col-lg-4 -->
	</div><!-- /.row -->
</div><!-- /.wrapper wrapper-content -->