<?php if (isset($tpl['arr']) && $tpl['arr']) { ?>
	<div class="alert alert-success">
		<i class="fa fa-check m-r-xs"></i>
		<strong><?php echo __('infoUpdateClientDetailsTitle', true); ?></strong>
		<?php echo __('infoUpdateClientDetailsDesc', true);?>
	</div>
<?php } else { ?>
	<div class="alert alert-success">
		<i class="fa fa-check m-r-xs"></i>
		<strong><?php echo __('infoAddClientDetailsTitle', true); ?></strong>
		<?php echo __('infoAddClientDetailsDesc', true);?>
	</div>
<?php } ?>
<div class="row">
	<?php 
	if (in_array((int) $tpl['option_arr']['o_bf_include_title'], array(2,3))) { ?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_title'); ?></label>

				<select name="c_title" id="c_title" class="form-control<?php echo $tpl['option_arr']['o_bf_include_title'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
					<option value="">-- <?php __('lblChoose'); ?>--</option>
					<?php
					$title_arr = pjUtil::getTitles();
					$name_titles = __('personal_titles', true, false);
					foreach ($title_arr as $v)
					{
						?><option value="<?php echo $v; ?>" <?php echo isset($tpl['arr']['c_title']) && $tpl['arr']['c_title'] == $v ? 'selected="selected"' : '';?>><?php echo $name_titles[$v]; ?></option><?php
					}
					?>
				</select>
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	if (in_array((int) $tpl['option_arr']['o_bf_include_name'], array(2,3))) {
	?>
		<div class="col-md-8 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_name'); ?></label>

				<input type="text" name="c_name" id="c_name" value="<?php echo isset($tpl['arr']['c_name']) ? pjSanitize::html($tpl['arr']['c_name']) : '';?>" class="form-control<?php echo $tpl['option_arr']['o_bf_include_name'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	?>
</div>
<div class="row">
	<?php 
	if (in_array((int) $tpl['option_arr']['o_bf_include_email'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_email'); ?></label>

				<input type="text" name="c_email" id="c_email" value="<?php echo isset($tpl['arr']['c_email']) ? pjSanitize::html($tpl['arr']['c_email']) : '';?>" class="form-control email <?php echo $tpl['option_arr']['o_bf_include_email'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-email="<?php __('lblEmailInvalid');?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	if (in_array((int) $tpl['option_arr']['o_bf_include_phone'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_phone'); ?></label>

				<input type="text" name="c_phone" id="c_phone" value="<?php echo isset($tpl['arr']['c_phone']) ? pjSanitize::html($tpl['arr']['c_phone']) : '';?>" class="form-control <?php echo $tpl['option_arr']['o_bf_include_phone'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	if (in_array((int) $tpl['option_arr']['o_bf_include_company'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_company'); ?></label>

				<input type="text" name="c_company" id="c_company" value="<?php echo isset($tpl['arr']['c_company']) ? pjSanitize::html($tpl['arr']['c_company']) : '';?>" class="form-control <?php echo $tpl['option_arr']['o_bf_include_company'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	?>
</div>
<div class="hr-line-dashed"></div>
<div class="row">
	<?php 
	if (in_array((int) $tpl['option_arr']['o_bf_include_address'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_address'); ?></label>

				<input type="text" name="c_address" id="c_address" value="<?php echo isset($tpl['arr']['c_address']) ? pjSanitize::html($tpl['arr']['c_address']) : '';?>" class="form-control <?php echo $tpl['option_arr']['o_bf_include_address'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	if (in_array((int) $tpl['option_arr']['o_bf_include_city'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_city'); ?></label>

				<input type="text" name="c_city" id="c_city" value="<?php echo isset($tpl['arr']['c_city']) ? pjSanitize::html($tpl['arr']['c_city']) : '';?>" class="form-control <?php echo $tpl['option_arr']['o_bf_include_city'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	}
	if (in_array((int) $tpl['option_arr']['o_bf_include_state'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_state'); ?></label>

				<input type="text" name="c_state" id="c_state" value="<?php echo isset($tpl['arr']['c_state']) ? pjSanitize::html($tpl['arr']['c_state']) : '';?>" class="form-control <?php echo $tpl['option_arr']['o_bf_include_state'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	if (in_array((int) $tpl['option_arr']['o_bf_include_zip'], array(2,3))) {
	?>
		<div class="col-md-4 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_zip'); ?></label>

				<input type="text" name="c_zip" id="c_zip" value="<?php echo isset($tpl['arr']['c_zip']) ? pjSanitize::html($tpl['arr']['c_zip']) : '';?>" class="form-control <?php echo $tpl['option_arr']['o_bf_include_zip'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	if (in_array((int) $tpl['option_arr']['o_bf_include_country'], array(2,3))) {
	?>
		<div class="col-md-8 col-sm-6">
			<div class="form-group">
				<label class="control-label"><?php __('booking_country'); ?></label>

				<select name="c_country" id="c_country" class="select-item form-control <?php echo $tpl['option_arr']['o_bf_include_country'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
					<option value="">-- <?php __('booking_country'); ?>--</option>
					<?php
					foreach ($tpl['country_arr'] as $v)
					{
						?><option value="<?php echo $v['id']; ?>" <?php echo isset($tpl['arr']['c_country']) && $tpl['arr']['c_country'] == $v['id'] ? 'selected="selected"' : '';?>><?php echo stripslashes($v['name']); ?></option><?php
					}
					?>
				</select>
			</div>
		</div><!-- /.col-md-3 -->
	<?php 
	} 
	?>
</div>
<?php if (in_array((int) $tpl['option_arr']['o_bf_include_notes'], array(2,3))) { ?>
<div class="hr-line-dashed"></div>
<div class="row">
	<div class="col-xs-12">
		<div class="form-group">
			<label class="control-label"><?php __('booking_notes'); ?></label>

			<textarea rows="5" name="c_notes" id="c_notes" class="form-control <?php echo $tpl['option_arr']['o_bf_include_notes'] == 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>"><?php echo isset($tpl['arr']['c_notes']) ? pjSanitize::html($tpl['arr']['c_notes']) : '';?></textarea>
		</div>
	</div>
</div>
<?php } ?>
<div class="hr-line-dashed"></div>
<div class="clearfix">
	<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in" style="margin-right: 15px;">
		<span class="ladda-label"><?php __('btnSave'); ?></span>
		<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
	</button>
	<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
</div><!-- /.clearfix -->