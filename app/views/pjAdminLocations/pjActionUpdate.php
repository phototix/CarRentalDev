<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$tab = $controller->_get->check('tab') ? $controller->_get->toInt('tab') : 0;
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php echo __('infoUpdateLocationTitle', true);?></h2>
                <ol class="breadcrumb">
					<li><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminLocations&amp;action=pjActionIndex"><?php __('menuLocations'); ?></a></li>
					<li class="active">
						<strong><?php echo __('infoUpdateLocationTitle', true);?></strong>
					</li>
				</ol>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
				<?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
			</div>
        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo __('infoUpdateLocationBody', true); ?></p>
    </div>
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<?php
	$error_code = $controller->_get->toString('err');
	if (!empty($error_code))
    {
    	switch (true)
    	{
    		case in_array($error_code, array('AL01', 'AL03')):
    			?>
    			<div class="alert alert-success">
    				<i class="fa fa-check m-r-xs"></i>
    				<strong><?php echo @$titles[$error_code]; ?></strong>
    				<?php echo @$bodies[$error_code]; ?>
    			</div>
    			<?php 
    			break;
            case in_array($error_code, array('AL04', 'AL08', 'AL12', 'AL13', 'AL14', 'AL15')):	
    			?>
    			<div class="alert alert-danger">
    				<i class="fa fa-exclamation-triangle m-r-xs"></i>
    				<strong><?php echo @$titles[$error_code]; ?></strong>
    				<?php echo @$bodies[$error_code]; ?>
    			</div>
    			<?php
    			break;
    	}
    }
    ?>
	<div class="col-lg-12">
        <div class="ibox float-e-margins">
        	<div class="tabs-container">
	        	<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminLocations&amp;action=pjActionUpdate&amp;id=<?php echo $tpl['arr']['id']; ?>"><?php __('menuAddress') ?></a></li>
					<?php if (pjAuth::factory('pjAdminTime', 'pjActionIndex')->hasAccess()) { ?>
						<li role="presentation"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminTime&amp;action=pjActionIndex&amp;foreign_id=<?php echo $tpl['arr']['id']; ?>&amp;tab=1"><?php __('menuDefaultWorkingTime') ?></a></li>
						<?php if (pjAuth::factory('pjAdminTime', 'pjActionGetDayOff')->hasAccess()) { ?>
							<li role="presentation"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminTime&amp;action=pjActionIndex&amp;foreign_id=<?php echo $tpl['arr']['id']; ?>&amp;tab=2"><?php __('menuCustomWorkingTime') ?></a></li>
						<?php } ?>
					<?php } ?>
				</ul>
				<div role="tabpanel" class="tab-pane active">
					<div class="panel-body">
			        	<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminLocations&amp;action=pjActionUpdate" method="post" id="frmUpdate" class="form pj-form" autocomplete="off" enctype="multipart/form-data">
							<input type="hidden" name="action_update" value="1" />
							<input type="hidden" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
			            	<div class="ibox-contenat">
			            		<div class="row">
			                        <div class="col-lg-3 col-md-4 col-sm-6">
			                            <div class="form-group">
			                                <label class="control-label"><?php __('lblStatus');?></label>
			
			                                <div class="clearfix">
			                                    <div class="switch onoffswitch-data pull-left">
			                                        <div class="onoffswitch">
			                                            <input type="checkbox" value="1" class="onoffswitch-checkbox" id="status" name="status" <?php echo $tpl['arr']['status'] == 'T' ? 'checked="checked"' : '';?>>
			                                            <label class="onoffswitch-label" for="status">
			                                                <span class="onoffswitch-inner" data-on="<?php __('filter_ARRAY_active', false, true); ?>" data-off="<?php __('filter_ARRAY_inactive', false, true); ?>"></span>
			                                                <span class="onoffswitch-switch"></span>
			                                            </label>
			                                        </div>
			                                    </div>
			                                </div>
			                            </div>
			                        </div>
			                        <div class="col-lg-9 col-md-8 col-sm-6">
			                            <div class="form-group">
			                                <label class="control-label"><?php __('location_email_notify');?></label>
			
			                                <div class="clearfix">
			                                    <div class="switch onoffswitch-data pull-left">
			                                        <div class="onoffswitch">
			                                            <input type="checkbox" value="1" class="onoffswitch-checkbox" id="notify_email" name="notify_email"  <?php echo $tpl['arr']['notify_email'] == 'T' ? 'checked="checked"' : '';?>>
			                                            <label class="onoffswitch-label" for="notify_email">
			                                                <span class="onoffswitch-inner" data-on="<?php __('_notify_email_ARRAY_T', false, true); ?>" data-off="<?php __('_notify_email_ARRAY_F', false, true); ?>"></span>
			                                                <span class="onoffswitch-switch"></span>
			                                            </label>
			                                        </div>
			                                    </div>
			                                    <span class="location-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("location_email_notify_tip", false, true) ?>"><i class="fa fa-info-circle"></i></span>
			                                </div>
			                            </div>
			                        </div>
								</div>
								<div class="hr-line-dashed"></div>
			                    <div class="row">
			                    	<div class="col-sm-4 col-xs-12">
			                    		<div class="form-group">
			                                <label class="control-label"><?php __('location_name');?></label>
											<?php
											foreach ($tpl['lp_arr'] as $v)
											{
												?>
												<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
													<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][name]" value="<?php echo htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['name'])); ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
													<?php if ($tpl['is_flag_ready']) : ?>
													<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
													<?php endif; ?>
												</div>
												<?php 
											}
											?>
			                            </div>
			                    	</div>
			                    	<div class="col-sm-4 col-xs-12">
			                    		<div class="form-group">
											<label class="control-label"><?php __('location_email'); ?></label>
											<input type="text" name="email" id="email" value="<?php echo pjSanitize::html($tpl['arr']['email']);?>" class="form-control email" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-email="<?php __('plugin_base_email_invalid', false, true);?>"/>
										</div>
			                    	</div>
			                    	<div class="col-sm-4 col-xs-12">
			                    		<div class="form-group">
											<label class="control-label"><?php __('location_phone'); ?></label>
											<input type="text" name="phone" id="phone" value="<?php echo pjSanitize::html($tpl['arr']['phone']);?>" class="form-control" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
										</div>
			                    	</div>
			                    </div>
			                    <div class="hr-line-dashed"></div>
			                    <div class="row">
									<div class="col-sm-7 col-xs-12">
										<div class="row">
											<div class="col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('location_address_1'); ?></label>
													<input type="text" name="address_content"  value="<?php echo pjSanitize::html($tpl['arr']['address_1']);?>" id="address_content" class="form-control" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
												</div>
											</div><!-- /.col-xs-12 -->
										</div>
										<div class="row">
											<div class="col-sm-6 col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('location_country'); ?></label>
													<select name="country_id" id="country_id" class="select-item form-control">
														<option value="">-- <?php __('lblChoose'); ?> --</option>
														<?php
														foreach ($tpl['country_arr'] as $v)
														{
															?><option value="<?php echo $v['id']; ?>" <?php echo $tpl['arr']['country_id'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo stripslashes($v['name']); ?></option><?php
														}
														?>
													</select>
												</div>
											</div>
											<div class="col-sm-6 col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('location_zip'); ?></label>
													<input type="text" name="zip" id="zip" value="<?php echo pjSanitize::html($tpl['arr']['zip']);?>" class="form-control" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-6 col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('location_state'); ?></label>
													<input type="text" name="state" id="state" value="<?php echo pjSanitize::html($tpl['arr']['state']);?>" class="form-control" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
												</div>
											</div>
											<div class="col-sm-6 col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('location_city'); ?></label>
													<input type="text" name="city" id="city" value="<?php echo pjSanitize::html($tpl['arr']['city']);?>" class="form-control" data-msg-required="<?php __('plugin_base_this_field_is_required');?>">
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-xs-12"><?php __('lblGMapNote'); ?></div>
										</div>
										<div class="row">
											<div class="col-xs-12">
												<input type="button" value="<?php __('btnGoogleMapsApi'); ?>" class="btn btn-primary btnGoogleMapsApi" />
												<span style="color: red; display: none"></span>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-6 col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('lblLatitude'); ?></label>
													<input type="text" name="lat" id="lat" value="<?php echo pjSanitize::html($tpl['arr']['lat']);?>" class="form-control number" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>">
												</div>
											</div>
											<div class="col-sm-6 col-xs-12">
												<div class="form-group">
													<label class="control-label"><?php __('lblLongitude'); ?></label>
													<input type="text" name="lng" id="lng" value="<?php echo pjSanitize::html($tpl['arr']['lng']);?>" class="form-control number" data-msg-required="<?php __('plugin_base_this_field_is_required');?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>">
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-xs-12">
												<label class="control-label"><?php __('lblLocationThumb'); ?></label>
												<br/>
												<?php
												if (!empty($tpl['arr']['thumb']) && is_file($tpl['arr']['thumb']))
												{
													?>
													<div class="pj-location-image">
														<p class="m-b-md">
															<img src="<?php echo PJ_INSTALL_URL . $tpl['arr']['thumb'];?>" alt="" class="pj-scale">
														</p>
														<p class="m-b-md">
															<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminLocations&amp;action=pjActionDeleteImage&amp;id=<?php echo $tpl['arr']['id'];?>" rev="<?php echo $tpl['arr']['id']; ?>" class="btn btn-xs btn-danger btn-outline btn-file pj-delete-image"><i class="fa fa-trash"></i> <?php __('btn_delete_image');?></a>
														</p>
													</div>
													<?php
												}
												?>
												<div class="fileinput fileinput-new" data-provides="fileinput">
													<span class="btn btn-primary btn-outline btn-file">
														<span class="fileinput-new"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_select_image'); ?></span>
														<span class="fileinput-exists"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_change_image'); ?></span>
														<input type="file" name="thumb">
													</span>
													<span class="fileinput-filename"></span>
													<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">×</a>
												</div>
											</div>
										</div>
									</div>
									<div class="col-sm-5 col-xs-12">
										<span id="map-message"></span>
										<div id="map_canvas" class="crMapCanvas" style="height: 400px;"></div>
									</div>
								</div>
								<div class="hr-line-dashed"></div>
			                    
								<div class="clearfix">
									<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
										<span class="ladda-label"><?php __('btnSave', false, true); ?></span>
										<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
									</button>
				
									<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminLocations&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.address_not_found = <?php x__encode('lblAddressNotFound'); ?>;
myLabel.alert_title = <?php x__encode('location_image_dtitle');?>;
myLabel.alert_text = <?php x__encode('location_image_dbody');?>;
myLabel.btn_delete = <?php x__encode('btnDelete'); ?>;
myLabel.btn_cancel = <?php x__encode('btnCancel'); ?>;
myLabel.isFlagReady = "<?php echo $tpl['is_flag_ready'] ? 1 : 0;?>";
myLabel.choose = <?php x__encode('lblChoose', false, true); ?>;
<?php if ($tpl['is_flag_ready']) : ?>
	var pjLocale = pjLocale || {};
	pjLocale.langs = <?php echo $tpl['locale_str']; ?>;
	pjLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
<?php endif; ?>
</script>