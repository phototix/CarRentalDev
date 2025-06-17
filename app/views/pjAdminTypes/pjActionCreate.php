<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php echo __('infoAddTypeTitle', true);?></h2>
                <ol class="breadcrumb">
					<li><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminTypes&amp;action=pjActionIndex"><?php __('menuRates'); ?></a></li>
					<li class="active">
						<strong><?php echo __('infoAddTypeTitle', true);?></strong>
					</li>
				</ol>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
				<?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
			</div>
        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo __('infoAddTypeBody', true); ?></p>
    </div>
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminTypes&amp;action=pjActionCreate" method="post" id="frmCreate" class="form pj-form" autocomplete="off" enctype="multipart/form-data">
				<input type="hidden" name="action_create" value="1" />
            	<div class="ibox-content">
            		<div class="row">
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('lblStatus');?></label>

                                <div class="clearfix">
                                    <div class="switch onoffswitch-data pull-left">
                                        <div class="onoffswitch">
                                            <input type="checkbox" value="1" class="onoffswitch-checkbox" id="status" name="status" checked>
                                            <label class="onoffswitch-label" for="status">
                                                <span class="onoffswitch-inner" data-on="<?php __('filter_ARRAY_active', false, true); ?>" data-off="<?php __('filter_ARRAY_inactive', false, true); ?>"></span>
                                                <span class="onoffswitch-switch"></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
					</div>
                    <div class="row">
                    	<div class="col-sm-6 col-xs-12">
                    		<div class="form-group">
                                <label class="control-label"><?php __('type_name');?></label>
								<?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][name]" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
                            </div>
                            <div class="form-group">
                                <label class="control-label"><?php __('type_extras');?></label>
								<select name="extra_id[]" class="select-item form-control" multiple>
									<?php
									foreach ($tpl['extra_arr'] as $extra)
									{
										?><option value="<?php echo $extra['id']; ?>"><?php echo pjSanitize::html($extra['name']); ?></option><?php
									}
									?>
								</select>
                            </div>
                            <div class="form-group">
								<label class="control-label"><?php __('type_image'); ?></label>
								<br/>
	                    		<div class="fileinput fileinput-new" data-provides="fileinput">
									<span class="btn btn-primary btn-outline btn-file">
										<span class="fileinput-new"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_select_image'); ?></span>
										<span class="fileinput-exists"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_change_image'); ?></span>
										<input type="file" name="thumb_path">
									</span>
									<span class="fileinput-filename"></span>
									<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">×</a>
								</div>
							</div>
                    	</div>
                    	<div class="col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('type_description'); ?></label>
                                
                                <?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<textarea class="form-control" name="i18n[<?php echo $v['id']; ?>][description]" cols="30" rows="10" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>"></textarea>	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
							</div>
                    	</div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="row">
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('lblPricePerDay'); ?> <span class="type-rates-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblPricePerDayTip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>
								
								<div class="input-group">
									<input type="text" name="price_per_day" id="price_per_day" class="form-control number text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>" />

									<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false) ?></span>
								</div>
							</div>
                    	</div>
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('lblPricePerHour'); ?> <span class="type-rates-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblPricePerHourTip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>

								<div class="input-group">
									<input type="text" name="price_per_hour" id="price_per_hour" class="form-control number text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>" />

									<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false) ?></span>
								</div>
							</div>
                    	</div>
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('type_default_distance'); ?>(<?php echo $tpl['option_arr']['o_unit'] ?>) <span class="type-rates-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("type_default_distance_tip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>

								<input type="text" name="default_distance" id="default_distance" class="form-control touchspin3 required text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
							</div>
                    	</div>
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('type_extra_price'); ?>(<?php echo $tpl['option_arr']['o_unit'] ?>) <span class="type-rates-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("type_extra_price_tip", false, true) ?>"><i class="fa fa-info-circle"></i></span></label>
								
								<div class="input-group">
									<input type="text" name="extra_price" id="extra_price" class="form-control number text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>" />

									<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false) ?></span>
								</div>
							</div>
                    	</div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="row">
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('type_passengers'); ?></label>

								<input type="text" name="passengers" id="passengers" class="form-control touchspin3 required text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
							</div>
                    	</div>
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('type_luggages'); ?></label>

								<input type="text" name="luggages" id="luggages" class="form-control touchspin3 required text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
							</div>
                    	</div>
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
								<label class="control-label"><?php __('type_doors'); ?></label>

								<input type="text" name="doors" id="doors" class="form-control touchspin3 required text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
							</div>
                    	</div>
                    	<div class="col-md-3 col-sm-6 col-xs-12">
                    		<div class="form-group">
                                <label class="control-label"><?php __('type_transmission');?></label>
								<select name="transmission" class="select-item form-control required" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
									<option value=""><?php __('cr_choose'); ?></option>
									<?php
									foreach (__('type_transmissions', true) as $k => $v)
									{
										?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
									}
									?>
								</select>
                            </div>
                    	</div>
                    </div>
	            </div>

				<div class="hr-line-dashed"></div>
                    
				<div class="clearfix">
					<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
						<span class="ladda-label"><?php __('btnSave', false, true); ?></span>
						<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
					</button>

					<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminTypes&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
				</div>
			</form>
        </div>
    </div>
</div>

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.isFlagReady = "<?php echo $tpl['is_flag_ready'] ? 1 : 0;?>";
myLabel.choose = <?php x__encode('lblChoose', false, true); ?>;
<?php if ($tpl['is_flag_ready']) : ?>
	var pjLocale = pjLocale || {};
	pjLocale.langs = <?php echo $tpl['locale_str']; ?>;
	pjLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
<?php endif; ?>
</script>