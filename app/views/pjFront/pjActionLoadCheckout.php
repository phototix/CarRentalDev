<?php
$extra_per = __('extra_per',true);
$get = $controller->_get->raw();
$post = $controller->_post->raw();
?>
<div class="container-fluid pjCrContainer">
	<div class="panel panel-default">
		<?php include_once dirname(__FILE__) . '/elements/header.php';?>
		
		<div class="panel-body pjCrBody">
			<button class="btn btn-default text-capitalize pjCrBtnPannelTrigger visible-xs-block"><?php __('front_3_booking'); ?></button>
			<br class="visible-xs-inline" />
			
			<div class="row">
				<div class="col-lg-4 col-md-4 col-sm-12 col-xs-12 hidden-xs pjCrPanelLeft">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h1 class="panel-title"><?php __('front_3_booking'); ?></h1><!-- /.panel-title -->
						</div><!-- /.panel-heading -->

						<div class="panel-body">
							<p class="clearfix">
								<strong><?php __('front_3_when'); ?></strong>

								<a href="<?php echo $_SERVER['PHP_SELF']; ?>" id="crBtnWhen" class="pull-right text-capitalize pjCrColorPrimary"><?php __('front_3_change'); ?></a>
							</p>

							<div class="row">
								<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12"><span class="text-muted"><?php __('front_3_pickup'); ?>:</span></div><!-- /.col-lg-5 col-md-5 col-sm-5 col-xs-12 -->

								<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12">
									<?php echo stripslashes($tpl['pickup_location']['name']); ?><br/>
									<?php 
									$dt_from = $_SESSION[$controller->default_product][$controller->default_order]['date_from'] . " " . $_SESSION[$controller->default_product][$controller->default_order]['hour_from'] . ":" . $_SESSION[$controller->default_product][$controller->default_order]['minutes_from'] . ":00";
									echo date($tpl['option_arr']['o_date_format'], strtotime($dt_from)).', '.date($tpl['option_arr']['o_time_format'], strtotime($dt_from)); 
									?>
									</div><!-- /.col-lg-7 col-md-7 col-sm-7 col-xs-12 -->
							</div><!-- /.row -->

							<div class="row">
								<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12"><span class="text-muted"><?php __('front_3_return'); ?>:</span></div><!-- /.col-lg-5 col-md-5 col-sm-5 col-xs-12 -->

								<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12">
									<?php echo isset($tpl['return_location']['name']) ? stripslashes($tpl['return_location']['name']) : stripslashes($tpl['pickup_location']['name']); ?><br/>
									<?php
									$dt_to = $_SESSION[$controller->default_product][$controller->default_order]['date_to'] . " " . $_SESSION[$controller->default_product][$controller->default_order]['hour_to'] . ":" . $_SESSION[$controller->default_product][$controller->default_order]['minutes_to'] . ":00";
									echo date($tpl['option_arr']['o_date_format'], strtotime($dt_to)).', '.date($tpl['option_arr']['o_time_format'], strtotime($dt_to)); 
									?>
									</div><!-- /.col-lg-7 col-md-7 col-sm-7 col-xs-12 -->
							</div><!-- /.row -->
							<?php
							$rental_hours = $_SESSION[$controller->default_product][$controller->default_order]['rental_hours'];
							$hours = $rental_hours %24;
							if($tpl['option_arr']['o_booking_periods'] == 'perday') 
							{
								$days = $_SESSION[$controller->default_product][$controller->default_order]['rental_days'];
								?>
								<div class="row">
									<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12"><span class="text-muted"><?php __('front_3_rental'); ?>:</span></div><!-- /.col-lg-5 col-md-5 col-sm-5 col-xs-12 -->
	
									<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12"><?php echo $days == 1 ? $days ." ". __('front_label_day',true) : $days ." ". __('front_3_days',true); ?><?php echo $days > 0 && $hours > 0 ? ' ' :'';?><?php echo $hours > 0 ?  $hours." ".__('front_3_hours',true) : ''?></div><!-- /.col-lg-7 col-md-7 col-sm-7 col-xs-12 -->
								</div><!-- /.row -->
								<?php
							}else{
								$days = 0;
								if($hours == 0 )
								{
									$days = $rental_hours / 24;
								}else {
									$days = floor($rental_hours / 24);
								}
								?>
								<div class="row">
									<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12"><span class="text-muted"><?php __('front_3_rental_duration'); ?>:</span></div><!-- /.col-lg-5 col-md-5 col-sm-5 col-xs-12 -->
	
									<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12"><?php echo $rental_duration = $days > 0 ? ($days == 1 ? $days ." ". __('front_label_day',true) : $days ." ". __('front_3_days',true) ) : ''?><?php echo $days > 0 && $hours > 0 ? ' ' :'';?><?php echo $hours > 0 ?  $hours." ".__('front_3_hours',true) : ''?></div><!-- /.col-lg-7 col-md-7 col-sm-7 col-xs-12 -->
								</div><!-- /.row -->
								<?php
							} 
							?>

							<br />

							<p class="clearfix">
								<strong><?php __('front_3_choise'); ?></strong>

								<a href="<?php echo $_SERVER['PHP_SELF']; ?>" id="crBtnChoise" class="pull-right text-capitalize pjCrColorPrimary"><?php __('front_3_change'); ?></a>
							</p>

							<div class="row">
								<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<img src="<?php echo is_file(@$tpl['type_arr']['thumb_path']) ? PJ_INSTALL_URL . $tpl['type_arr']['thumb_path'] : PJ_INSTALL_URL . PJ_IMG_PATH . 'frontend/dummy_1.png'; ?>" alt="" class="img-responsive"/>
								</div><!-- /.col-lg-4 col-md-4 col-sm-4 col-xs-4 -->

								<div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
									<p><strong><?php echo stripslashes(@$tpl['type_arr']['name']); ?></strong></p>
									<p>(<?php __('front_3_example'); ?>: <?php echo stripslashes(@$tpl['type_arr']['example']['make'] . " " . @$tpl['type_arr']['example']['model']); ?>)</p>
								</div><!-- /.col-lg-8 col-md-8 col-sm-8 col-xs-8 -->
							</div><!-- /.row -->
						</div><!-- /.panel-body -->
					</div><!-- /.panel panel-default pjCrPanelLeft -->
				</div><!-- /.col-lg-4 col-md-4 col-sm-12 col-xs-12 pjCrPanelLeft -->

				<div class="col-lg-8 col-md-8 col-sm-12 col-xs-12 pjCrPanelRight">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h1 class="panel-title"><?php __('front_3_payment'); ?></h1><!-- /.panel-title -->
						</div><!-- /.panel-heading -->
						<?php
						$rental_fee_detail = array();
						?>
						<div class="panel-body">
							<div class="table-responsive">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="table">
									<tr>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
											<strong><?php __('front_3_rental_duration'); ?></strong>
										</td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
											<?php
											if($tpl['cart']['day_added'] == 1)
											{
												$days++;
												echo $rental_duration = $days > 0 ? ($days == 1 ? $days ." ". __('front_label_day',true) : $days ." ". __('front_3_days',true) ) : '';
											}else{
												echo $rental_duration = $days > 0 ? ($days == 1 ? $days ." ". __('front_label_day',true) : $days ." ". __('front_3_days',true) ) : ''?><?php echo $days > 0 && $hours > 0 ? ' ' :'';?><?php echo $hours > 0 ?  $hours." ".__('front_3_hours',true) : '';
											}
											?>
										</td>
									</tr>
									<tr style="display:<?php echo in_array($tpl['option_arr']['o_booking_periods'], array('both', 'perday')) ? 'table-row' : 'none';?>">
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5"><strong><?php __('front_3_price_per_day'); ?></strong><br/><?php echo $tpl['cart']['price_per_day_detail']; ?></td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
											<?php echo $rental_fee_detail[] = pjCurrency::formatPrice($tpl['cart']['price_per_day']);?>
										</td>
									</tr>
									<tr style="display:<?php echo in_array($tpl['option_arr']['o_booking_periods'], array('both', 'perhour')) ? 'table-row' : 'none';?>">
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5"><strong><?php __('front_3_price_per_hour'); ?></strong><br/><?php echo $tpl['cart']['price_per_hour_detail']; ?></td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
											<?php echo $rental_fee_detail[] = pjCurrency::formatPrice($tpl['cart']['price_per_hour']);?>
										</td>
									</tr>
									<tr>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
											<strong><?php __('front_3_price'); ?></strong><br/><?php echo join(" + ", $rental_fee_detail);?>
										</td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right"><?php echo pjCurrency::formatPrice($tpl['cart']['car_rental_fee']);?></td>
									</tr>

									<tr>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
											<strong><?php __('front_3_extra_price'); ?></strong>
										</td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right"><?php echo pjCurrency::formatPrice($tpl['cart']['extra_price']);?></td>
									</tr>
									<?php
									if ($tpl['option_arr']['o_insurance_payment'] > 0)
									{
										$insurance_types = __('insurance_type_arr', true, false);
										?>
										<tr>
											<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5"><strong><?php __('front_3_insurance'); ?></strong><br/>
												<?php
												switch ($tpl['option_arr']['o_insurance_payment_type']) {
													case 'perday':
														echo pjCurrency::formatPrice($tpl['option_arr']['o_insurance_payment']) . ' ' . strtolower($insurance_types['perday']);
													;
													break;
													case 'percent':
														echo $tpl['option_arr']['o_insurance_payment'] . '% ' . __('front_label_of', true, false) . ' ' . pjCurrency::formatPrice($tpl['cart']['price']);
													;
													break;
													case 'perbooking':
														echo pjCurrency::formatPrice($tpl['option_arr']['o_insurance_payment']) . ' ' . strtolower($insurance_types['perbooking']);
													;
													break;
												}
												?>
											</td>
											<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
												<?php echo pjCurrency::formatPrice($tpl['cart']['insurance']);?>
											</td>
										</tr>
										<?php
									} 
									?>
									<tr>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
											<strong><?php __('front_3_sub_total'); ?></strong>
										</td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right"><?php echo pjCurrency::formatPrice($tpl['cart']['sub_total']);?></td>
									</tr>
									<?php
									if ($tpl['option_arr']['o_tax_payment'] > 0)
									{
										?>
										<tr>
											<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5"><strong><?php __('front_3_tax'); ?></strong><br/>
												<?php
												if($tpl['option_arr']['o_tax_type'] == 'percent')
												{
													echo $tpl['option_arr']['o_tax_payment'] . '% ' . __('front_label_of', true, false) . ' ' . pjCurrency::formatPrice($tpl['cart']['sub_total']);
												}
												?>
											</td>
											<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
												<?php echo pjCurrency::formatPrice($tpl['cart']['tax']);?>
											</td>
										</tr>
										<?php
									}
									?>
									<tr>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
											<strong class="text-danger pjCrColorPrimary"><?php __('front_3_total_price'); ?></strong>
										</td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right"><?php echo pjCurrency::formatPrice($tpl['cart']['total_price']);?></td>
									</tr>
									<?php
									if ($tpl['option_arr']['o_security_payment'] > 0)
									{
										?>
										<tr>
											<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
												<strong><?php __('front_3_security_deposit'); ?></strong>
											</td>
											<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
												<?php echo pjCurrency::formatPrice($tpl['option_arr']['o_security_payment']);?>
											</td>
										</tr>
										<?php
									} 
									?>
									<tr>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
											<strong><?php __('front_3_required_deposit'); ?></strong>
											<br />
											<?php
											switch ($tpl['option_arr']['o_deposit_type'])
											{
												case 'percent':
													echo $tpl['option_arr']['o_deposit_payment'] . '% ' . __('front_label_of', true, false) . ' ' . pjCurrency::formatPrice($tpl['cart']['total_price']);
													break;
												case 'amount':
													break;
											}
											?>
										</td>
										<td class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right"><?php echo pjCurrency::formatPrice($tpl['cart']['required_deposit']);?></td>
									</tr>
								</table><!-- /.table -->
							</div><!-- /.table-responsive -->
						</div><!-- /.panel-body -->
					</div><!-- /.panel panel-default -->
				</div><!-- /.col-lg-8 col-md-8 col-sm-12 col-xs-12 pjCrPanelRight -->
			</div><!-- /.row -->
			
			<form id="crCheckoutForm" name="crCheckoutForm" class="pjCrFormCheckout" action="" method="post" role="form" data-toggle="validator">
				<?php
				if(in_array($tpl['option_arr']['o_bf_include_title'], array(2, 3)) || 
				    in_array($tpl['option_arr']['o_bf_include_name'], array(2, 3)) ||
				    in_array($tpl['option_arr']['o_bf_include_email'], array(2, 3)) ||
				    in_array($tpl['option_arr']['o_bf_include_phone'], array(2, 3)) ||
				    in_array($tpl['option_arr']['o_bf_include_notes'], array(2, 3)))
				{
    				?>
    				<div class="panel panel-default">
    					<div class="panel-heading">
    						<h2 class="panel-title text-muted"><?php __('front_4_personal'); ?></h2><!-- /.panel-title text-muted -->
    					</div><!-- /.panel-heading -->
    				
    					<div class="panel-body">
    						<div class="row">
    							<?php
    							if (in_array($tpl['option_arr']['o_bf_include_title'], array(2, 3)))
    							{
    								$title_arr = pjUtil::getTitles();
    								$name_titles = __('personal_titles', true, false);
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php __('front_4_title'); ?> <?php if ($tpl['option_arr']['o_bf_include_title'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<select name="c_title" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_title'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_title'))); ?>">
    											<option value=""><?php __('front_4_select_title'); ?></option>
    											<?php
    											foreach ($title_arr as $v)
    											{
    												?><option value="<?php echo $v; ?>"><?php echo $name_titles[$v]; ?></option><?php
    											}
    											?>
    										</select>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_name'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php __('front_4_name'); ?> <?php if ($tpl['option_arr']['o_bf_include_name'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_name" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_name'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_name'))); ?>" />
    										
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							} 
    							if (in_array($tpl['option_arr']['o_bf_include_email'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_email'); ?> <?php if ($tpl['option_arr']['o_bf_include_email'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" id="crEmail" name="c_email" class="form-control email<?php echo ($tpl['option_arr']['o_bf_include_email'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_email'))); ?>" data-msg-email="<?php echo htmlspecialchars(stripslashes(__('front_4_v_email_invalid'))); ?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_phone'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_phone'); ?> <?php if ($tpl['option_arr']['o_bf_include_phone'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_phone" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_phone'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_phone'))); ?>" />
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							} 
    							?>
    						</div><!-- /.row -->
    						<?php
    						if (in_array($tpl['option_arr']['o_bf_include_notes'], array(2, 3)))
    						{
    							?>
    							<div class="row">
    								<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
    									<label for="" class="control-label"><?php  __('front_4_notes'); ?> <?php if ($tpl['option_arr']['o_bf_include_notes'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    									<textarea name="c_notes" rows="6"  class="form-control<?php echo ($tpl['option_arr']['o_bf_include_notes'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_notes'))); ?>"></textarea>
    									<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    								</div>
    							</div><!-- /.row -->
    							<?php
    						}
    						?>
    					</div><!-- /.panel-body -->
    				</div><!-- /.panel panel-default -->
    				<?php
				}
				if(in_array($tpl['option_arr']['o_bf_include_company'], array(2, 3)) || 
				    in_array($tpl['option_arr']['o_bf_include_address'], array(2, 3)) || 
				    in_array($tpl['option_arr']['o_bf_include_city'], array(2, 3)) ||
				    in_array($tpl['option_arr']['o_bf_include_state'], array(2, 3)) ||
				    in_array($tpl['option_arr']['o_bf_include_zip'], array(2, 3)) ||
				    in_array($tpl['option_arr']['o_bf_include_country'], array(2, 3)))
				{
    				?>
    				<div class="panel panel-default">
    					<div class="panel-heading">
    						<h2 class="panel-title text-muted"><?php  __('front_4_billing'); ?></h2><!-- /.panel-title text-muted -->
    					</div><!-- /.panel-heading -->
    				
    					<div class="panel-body">
    						<div class="row">
    							<?php
    							if (in_array($tpl['option_arr']['o_bf_include_company'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_company'); ?> <?php if ($tpl['option_arr']['o_bf_include_company'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_company" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_company'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_company'))); ?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_address'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_address'); ?> <?php if ($tpl['option_arr']['o_bf_include_address'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_address" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_address'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_address'))); ?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_city'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_city'); ?> <?php if ($tpl['option_arr']['o_bf_include_city'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_city" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_city'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_city'))); ?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_state'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_state'); ?> <?php if ($tpl['option_arr']['o_bf_include_state'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_state" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_state'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_city'))); ?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_zip'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_zip'); ?> <?php if ($tpl['option_arr']['o_bf_include_zip'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<input type="text" name="c_zip" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_zip'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_city'))); ?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}
    							if (in_array($tpl['option_arr']['o_bf_include_country'], array(2, 3)))
    							{
    								?>
    								<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
    									<div class="form-group">
    										<label for="" class="control-label"><?php  __('front_4_country'); ?> <?php if ($tpl['option_arr']['o_bf_include_country'] == 3) : ?><span class="text-danger">*</span><?php endif; ?></label>
    																	
    										<select name="c_country" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_country'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_country'))); ?>">
    											<option value=""><?php echo __('front_4_select_country'); ?></option>
    											<?php
    											foreach ($tpl['country_arr'] as $country)
    											{
    												?><option value="<?php echo $country['id']; ?>"><?php echo stripslashes($country['country_title']); ?></option><?php
    											}
    											?>
    										</select>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
    								<?php
    							}  
    							?>
    						</div><!-- /.row -->
    					</div><!-- /.panel-body -->
    				</div><!-- /.panel panel-default -->
    				<?php
				}
				if ($tpl['option_arr']['o_payment_disable'] == '0')
				{ 
					?>
					<div class="panel panel-default">
						<div class="panel-heading">
							<h2 class="panel-title text-muted"><?php  __('front_4_payment'); ?> </h2><!-- /.panel-title text-muted -->
						</div><!-- /.panel-heading -->
					
						<div class="panel-body">
							<div class="row">
								<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
									<div class="form-group">
										<label for="" class="control-label"><?php  __('front_4_payment'); ?> <span class="text-danger">*</span></label>
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
										<select name="payment_method" class="form-control required" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_payment'))); ?>">
											<option value=""><?php echo __('front_4_select_payment'); ?></option>
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
						                        ?><option value="<?php echo $k; ?>"<?php echo isset($FORM['payment_method']) && $FORM['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
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
						                                ?><option value="<?php echo $k; ?>"<?php echo isset($FORM['payment_method']) && $FORM['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
						                            }
						                        }
						                    }
						                    if ($haveOnline && $haveOffline)
						                    {
						                        ?></optgroup><?php
						                    }
											?>
										</select>
										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
									</div><!-- /.form-group -->
								</div><!-- /.col-lg-3 col-md-3 col-sm-6 col-xs-12 -->
							</div><!-- /.row -->
							
							<br />
							
							<div id="crBankData" style="display:none">
								<div class="crLeft100">
									<p>
										<strong><?php __('front_4_bank_account'); ?> </strong>
									</p>
									<p><?php echo pjSanitize::html($tpl['bank_account']); ?></p>
								</div>
							</div>
							
							
						</div><!-- /.panel-body -->
					</div><!-- /.panel panel-default -->
					<?php
				}
				if (in_array($tpl['option_arr']['o_bf_include_captcha'], array(2, 3)))
				{ 
					?>
					<div class="panel panel-default">
						<div class="panel-heading">
							<h2 class="panel-title text-muted"><?php echo __('front_4_captcha'); ?></h2><!-- /.panel-title text-muted -->
						</div><!-- /.panel-heading -->
					
						<div class="panel-body">
							<div class="form-group">
								<?php
								if($tpl['option_arr']['o_captcha_type_front'] == 'system')
								{
    								?>
									<div class="row">
										<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
											<input type="text" id="pjCrCaptchaField" name="captcha" class="form-control<?php echo (int) $tpl['option_arr']['o_bf_include_captcha'] === 3 ? ' required' : NULL; ?>" maxlength="<?php echo $tpl['option_arr']['o_captcha_mode_front'] == 'string'? (int) $tpl['option_arr']['o_captcha_length_front']: 10 ?>" autocomplete="off" data-msg-required="<?php __('front_4_v_captcha', false, true); ?>" data-msg-remote="<?php __('front_4_v_captcha_incorrect', false, true); ?>" />
										</div>
										<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
											<img id="pjCrCaptchaImage" alt="Captcha" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFront&action=pjActionCaptcha&rand=<?php echo rand(1000, 999999); ?>&session_id=<?php echo $controller->_get->check('session_id') ? pjObject::escapeString($controller->_get->toString('session_id')) : NULL;?>" style="vertical-align: middle; cursor: pointer;" />
										</div>
									</div>
									<?php 
								} else {
									?>
								    <div id="g-recaptcha" class="g-recaptcha" data-sitekey="<?php echo $tpl['option_arr']['o_captcha_site_key_front'] ?>"></div>
									<input type="hidden" id="recaptcha" name="recaptcha" class="recaptcha<?php echo ($tpl['option_arr']['o_bf_include_captcha'] == 3) ? ' required' : NULL; ?>" autocomplete="off" data-msg-required="<?php __('front_4_v_captcha');?>" data-msg-remote="<?php __('front_4_v_captcha_incorrect');?>"/>
									<?php 
								}
								?>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div>
						</div><!-- /.panel-body -->
					</div><!-- /.panel panel-default -->
					<?php
				} 
				?>
				
				<div class="panel panel-default">
					<div class="panel-heading">
						<h2 class="panel-title text-muted"><?php echo __('front_4_terms'); ?></h2><!-- /.panel-title text-muted -->
					</div><!-- /.panel-heading -->
				
					<div class="panel-body">
						<div class="form-group">
							<div class="checkbox">
								<label><input type="checkbox" name="c_agree" value="1" class="required" data-msg-required="<?php echo htmlspecialchars(stripslashes(__('front_4_v_agree'))); ?>" /> <?php echo __('front_4_agree'); ?></label>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.checkbox -->
						</div><!-- /.form-group -->
						<?php
						if(!empty($tpl['term_arr'][0]['content']))
						{ 
							?>
							<a href="#" class="pjCrColorPrimary" data-pj-toggle="modal" data-pj-target="#myModal"><?php echo __('front_4_click'); ?></a>
							<?php
						} 
						?>
						<br />
						<br />
						<input type="button" value="<?php  __('front_btn_back'); ?>" id="crBtnBack" class="btn btn-default text-capitalize pjCrBtntDefault" />	
						<input type="submit" value="<?php  __('front_btn_confirm'); ?>" id="crBtnConfirm" class="btn btn-default pull-right text-capitalize pjCrBtntDefault crBtnConfirm" />
						
						<div class="crError text-danger text-center" style="display: none;"></div>
					</div><!-- /.panel-body -->
				</div><!-- /.panel panel-default -->
			</form><!-- /.pjCrFormCheckout -->
		</div><!-- /.panel-body pjCrBody -->
		
	</div><!-- /.panel panel-default -->
</div><!-- /.container-fluid pjCrContainer -->