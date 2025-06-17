<div class="panel no-borders">
	<div class="panel-heading bg-completed">
		<p class="lead m-n"><?php __('infoUpdateCarTitle')?></p>
	</div><!-- /.panel-heading -->

	<div class="panel-body">
		<form action="" method="post" id="frmUpdate">
			<input type="hidden" name="update_car" value="1" />
			<input type="hidden" name="id" value="<?php echo $tpl['arr']['id'];?>" />
			<div class="form-group">
				<label class="control-label"><?php __('car_make');?>:</label>			
				<?php
				foreach ($tpl['lp_arr'] as $v)
				{
					?>
					<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group' : '';?> pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
						<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][make]" value="<?php echo pjSanitize::html(@$tpl['arr']['i18n'][$v['id']]['make']); ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
						<?php if ($tpl['is_flag_ready']) : ?>
						<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
						<?php endif; ?>
					</div>
					<?php 
				}
				?>
			</div>
			<div class="form-group">
				<label class="control-label"><?php __('car_model');?>:</label>			
				<?php
				foreach ($tpl['lp_arr'] as $v)
				{
					?>
					<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group' : '';?> pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
						<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][model]" value="<?php echo pjSanitize::html(@$tpl['arr']['i18n'][$v['id']]['model']); ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
						<?php if ($tpl['is_flag_ready']) : ?>
						<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
						<?php endif; ?>
					</div>
					<?php 
				}
				?>
			</div>
			<div class="form-group">
				<label class="control-label"><?php __('car_reg');?>:</label>			
				<input type="text" class="form-control required" name="registration_number" value="<?php echo pjSanitize::html($tpl['arr']['registration_number']);?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
			<div class="form-group">
				<label class="control-label"><?php __('car_current_mileage');?> (<?php echo $tpl['option_arr']['o_unit'] ?>) <span class="car-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblCurrentMileageTip", false, true) ?>"><i class="fa fa-info-circle"></i></span> :</label>			
				<input type="text" class="form-control touchspin3" name="mileage" value="<?php echo pjSanitize::html($tpl['arr']['mileage']);?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
			<div class="form-group">
				<label class="control-label"><?php __('car_location');?> <span class="car-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("lblLocationTip", false, true) ?>"><i class="fa fa-info-circle"></i></span> :</label>			
				<select name="location_id" id="location_id" class="form-control required select-item" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
					<option value=""><?php __('cr_choose'); ?></option>
					<?php
					foreach ($tpl['location_arr'] as $k => $v)
					{
						?><option value="<?php echo $v['id']; ?>" <?php echo $tpl['arr']['location_id'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo pjSanitize::html($v['name']); ?></option><?php
					}
					?>
				</select>
			</div>
			<div class="form-group">
				<label class="control-label"><?php __('car_type');?>:</label>			
				<select name="type_id[]" id="type_id" class="form-control select-item" multiple="multiple" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
					<?php
					foreach ($tpl['type_arr'] as $k => $v)
					{
					    ?><option value="<?php echo $v['id']; ?>" <?php echo in_array($v['id'], $tpl['car_type_id_arr']) ? 'selected="selected"' : '';?>><?php echo pjSanitize::html($v['name']); ?></option><?php
					}
					?>
				</select>
			</div>
			
			<div class="m-t-sm">
				<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
					<span class="ladda-label"><?php __('btnSave', false, true); ?></span>
					<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
				</button>
				<button type="button" class="btn btn-white btn-lg pull-right pjBtnCancelUpdateCar"><?php __('btnCancel'); ?></button>
			</div><!-- /.m-b-lg -->
		</form>
	</div><!-- /.panel-body -->
</div><!-- /.panel panel-primary -->