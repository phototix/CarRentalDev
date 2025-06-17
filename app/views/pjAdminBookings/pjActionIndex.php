<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
$bs = __('booking_statuses', true);
$get = $controller->_get->raw();
?>
<div id="datePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-format="<?php echo $tpl['date_format']; ?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12 export-page-heading">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php echo __('infoReservationsTitle', true);?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php echo __('infoReservationsBody', true);?></p>
	</div><!-- /.col-md-12 -->
</div>

<div class="wrapper wrapper-content animated fadeInRight">
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
					<?php echo @$bodies[$error_code];?>
				</div>
				<?php 
				break;
			case in_array($error_code, array('AR04', 'AR08', 'AR09', 'AR10', 'AC08')):	
				?>
				<div class="alert alert-danger">
					<i class="fa fa-exclamation-triangle m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code];?>
				</div>
				<?php
				break;
		}
	} 
	?>
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content cardealer-no-border">
					<div class="row m-b-md">
						<div class="col-lg-2 col-md-3 col-sm-3">
						<?php 
                        if ($tpl['has_create'])
                        {
                        	?>
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" class="btn btn-primary"><i class="fa fa-plus m-r-xs"></i> <?php __('btnAddReservation'); ?></a>
							<?php 
                        }
                        ?>
						</div>
						<div class="col-lg-3 col-md-5 col-sm-5">
							<form action="" method="get" class="form-horizontal frm-filter">
								<div class="input-group">
									<input type="text" name="q" placeholder="<?php __('btnSearch', false, true); ?>" class="form-control">
									<div class="input-group-btn">
										<button class="btn btn-primary" type="submit">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
							</form>
                        </div>
                        <div class="col-lg-2 col-md-4 col-sm-4">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" class="btn btn-primary btn-outline btn-advance-search"><?php __('advance_search'); ?></a>
						</div>
						<div class="col-lg-5 col-md-12 text-right">
							<button type="button" class="btn btn-primary btn-all active"><?php __('lblAll');?></button>
                            <?php __('lblPickup')?>:
                            <button type="button" class="btn btn-default btn-filter <?php echo isset($get['filter']) ? ($get['filter'] == 'p_today' ? 'active' : null) : null;?>" data-column="filter" data-value="p_today"><?php __('booking_today'); ?></button>
                            <button type="button" class="btn btn-default btn-filter <?php echo isset($get['filter']) ? ($get['filter'] == 'p_tomorrow' ? 'active' : null) : null;?>" data-column="filter" data-value="p_tomorrow"><?php __('booking_tomorrow'); ?></button>
                            <label><?php __('lblReturn')?>:</label>
                            <button type="button" class="btn btn-default btn-filter <?php echo isset($get['filter']) ? ($get['filter'] == 'r_today' ? 'active' : null) : null;?>" data-column="filter" data-value="r_today"><?php __('booking_today'); ?></button>
                            <button type="button" class="btn btn-default btn-filter <?php echo isset($get['filter']) ? ($get['filter'] == 'r_tomorrow' ? 'active' : null) : null;?>" data-column="filter" data-value="r_tomorrow"><?php __('booking_tomorrow'); ?></button>
						</div>
					</div>				
					
					<div id="collapseOne" class="collapse">
						<div class="m-b-lg">
							<ul class="agile-list no-padding">
								<li class="success-element b-r-sm">
									<div class="panel-body">
										<form action="" method="get" class="frm-filter-advanced">
											<div class="row">
												<div class="col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('booking_id'); ?></label>

														<input type="text" name="booking_id" id="booking_id" class="form-control" value="<?php echo isset($get['booking_id']) ? pjSanitize::html($get['booking_id']) : NULL; ?>">
													</div><!-- /.form-group -->
													<div class="form-group">
														<label class="control-label"><?php __('car_type'); ?></label>

														<select class="form-control" name="type_id">
															<option value="">-- <?php __('lblChoose');?> --</option>
															<?php
															foreach ($tpl['type_arr'] as $v)
															{
																?><option value="<?php echo $v['id']; ?>"<?php echo isset($get['type_id']) && (int) $get['type_id'] == $v['id'] ? ' selected="selected"' : NULL; ?>><?php echo stripslashes($v['name']); ?></option><?php
															}
															?>
														</select>
													</div><!-- /.form-group -->
													<div class="form-group">
														<label class="control-label"><?php __('booking_pickup'); ?></label>

														<select class="form-control" name="pickup_id">
															<option value="">-- <?php __('lblChoose');?> --</option>
															<?php
															if (isset($tpl['pickup_arr']) && count($tpl['pickup_arr']) > 0)
															{
																foreach ($tpl['pickup_arr'] as $v)
																{
																	?><option value="<?php echo $v['id']; ?>"><?php echo stripslashes($v['name']); ?></option><?php
																}
															}
															?>
														</select>
													</div><!-- /.form-group -->
													<div class="form-group">
														<label class="control-label"><?php __('booking_return'); ?></label>

														<select class="form-control" name="return_id">
															<option value="">-- <?php __('lblChoose');?> --</option>
															<?php
															if (isset($tpl['return_arr']) && count($tpl['return_arr']) > 0)
															{
																foreach ($tpl['return_arr'] as $v)
																{
																	?><option value="<?php echo $v['id']; ?>"><?php echo stripslashes($v['name']); ?></option><?php
																}
															}
															?>
														</select>
													</div><!-- /.form-group -->
												</div>
												<div class="col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('lblBookingStatus'); ?></label>

														<select class="form-control" name="status">
															<option value="">-- <?php __('lblChoose');?> --</option>
															<?php
															foreach($bs as $k => $v)
															{
																?><option value="<?php echo $k;?>" <?php echo isset($get['status']) && $get['status'] == $k ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($v);?></option><?php
															} 
															?>
														</select>
													</div><!-- /.form-group -->
													<div class="form-group">
														<label class="control-label"><?php __('lblPickupDate'); ?></label>

														<div class="row">
															<div class="col-sm-5">
																<div class="input-group">
																	<input type="text" class="form-control datepick" name="pickup_from" readonly="readonly" />

																	<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
																</div>
															</div><!-- /.col-md-5 -->

															<div class="col-sm-2 text-center">
																<label class="control-label m-t-xs"><?php __('label_to');?></label>
															</div><!-- /.col-md-2 -->

															<div class="col-sm-5">
																<div class="input-group">
																	<input type="text" class="form-control datepick" name="pickup_to" readonly="readonly" />

																	<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
																</div>
															</div><!-- /.col-md-5 -->
														</div><!-- /.row -->
													</div><!-- /.form-group -->
													<div class="form-group">
														<label class="control-label"><?php __('lblReturnDate'); ?></label>

														<div class="row">
															<div class="col-sm-5">
																<div class="input-group">
																	<input type="text" class="form-control datepick" name="return_from" readonly="readonly" />

																	<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
																</div>
															</div><!-- /.col-md-5 -->

															<div class="col-sm-2 text-center">
																<label class="control-label m-t-xs"><?php __('label_to');?></label>
															</div><!-- /.col-md-2 -->

															<div class="col-sm-5">
																<div class="input-group">
																	<input type="text" class="form-control datepick" name="return_to" readonly="readonly" />

																	<span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
																</div>
															</div><!-- /.col-md-5 -->
														</div><!-- /.row -->
													</div><!-- /.form-group -->
												</div>
											</div>
											<div class="hr-line-dashed"></div>

											<div class="m-t-sm">
												<button class="btn btn-primary" type="submit"><?php __('btnSearch');?></button>

												<button class="btn btn-primary btn-outline" type="reset"><?php __('btnCancel');?></button>
											</div>
										</form>
									</div>
								</li>
							</ul>
						</div>
					</div>
                            
					<div id="grid"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var pjGrid = pjGrid || {};
pjGrid.queryString = "";
<?php
if (isset($get['car_id']) && (int) $get['car_id'] > 0)
{
	?>pjGrid.queryString += "&car_id=<?php echo (int) $get['car_id']; ?>";<?php
}
if (isset($get['filter']))
{
	?>pjGrid.queryString += "&filter=<?php echo $get['filter']; ?>";<?php
}
?>
var myLabel = myLabel || {};
myLabel.pick_drop = <?php x__encode('booking_pickup_dropoff'); ?>;
myLabel.booking_from = <?php x__encode('booking_from'); ?>;
myLabel.booking_to = <?php x__encode('booking_to'); ?>;
myLabel.booking_type = <?php x__encode('booking_type'); ?>;
myLabel.booking_car = <?php x__encode('booking_car'); ?>;
myLabel.booking_total = <?php x__encode('booking_total'); ?>;
myLabel.booking_client = <?php x__encode('booking_client'); ?>;
myLabel.delete_selected = <?php x__encode('delete_selected'); ?>;
myLabel.delete_confirmation = <?php x__encode('delete_confirmation'); ?>;
myLabel.status = <?php x__encode('lblStatus'); ?>;
myLabel.pending = <?php echo x__encode('booking_statuses_ARRAY_pending'); ?>;
myLabel.confirmed = <?php echo x__encode('booking_statuses_ARRAY_confirmed'); ?>;
myLabel.cancelled = <?php echo x__encode('booking_statuses_ARRAY_cancelled'); ?>;
myLabel.collected = <?php echo x__encode('booking_statuses_ARRAY_collected'); ?>;
myLabel.completed = <?php echo x__encode('booking_statuses_ARRAY_completed'); ?>;
myLabel.months = "<?php echo implode("_", $months);?>";
myLabel.days = "<?php echo implode("_", $short_days);?>";
myLabel.has_update = <?php echo (int) $tpl['has_update']; ?>;
myLabel.has_delete = <?php echo (int) $tpl['has_delete']; ?>;
myLabel.has_delete_bulk = <?php echo (int) $tpl['has_delete_bulk']; ?>;
myLabel.has_update_type = <?php echo (int) $tpl['has_update_type']; ?>;
myLabel.has_update_car = <?php echo (int) $tpl['has_update_car']; ?>;
</script>