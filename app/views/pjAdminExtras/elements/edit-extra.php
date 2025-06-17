<div class="panel no-borders">
	<div class="panel-heading bg-completed">
		<p class="lead m-n"><?php __('infoUpdateExtraTitle')?></p>
	</div><!-- /.panel-heading -->

	<div class="panel-body">
		<form action="" method="post" id="frmUpdate">
			<input type="hidden" name="update_extra" value="1" />
			<input type="hidden" name="id" value="<?php echo $tpl['arr']['id'];?>" />
			<div class="form-group">
				<label class="control-label"><?php __('extra_title');?>:</label>
			
				<?php
				foreach ($tpl['lp_arr'] as $v)
				{
					?>
					<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group' : '';?> pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
						<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][name]" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" value="<?php echo pjSanitize::html(@$tpl['arr']['i18n'][$v['id']]['name']); ?>">	
						<?php if ($tpl['is_flag_ready']) : ?>
						<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
						<?php endif; ?>
					</div>
					<?php 
				}
				?>
			</div>

			<div class="form-group">
				<label class="control-label"><?php __('extra_price');?>:</label>
				<div class="row">
					<div class="col-sm-5 col-xs-6">
						<div class="input-group">
							<input type="text" id="price" name="price" value="<?php echo (float)$tpl['arr']['price'];?>" class="form-control required number" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-number="<?php __('prices_invalid_price', false, true);?>">
			
							<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false);?></span> 
						</div>
					</div>
					<div class="col-sm-7 col-xs-6">
						<select name="per" class="form-control" >
							<?php
							foreach (__('extra_per', true) as $k => $v)
							{
								?><option value="<?php echo $k; ?>" <?php echo $tpl['arr']['per'] == $k ? 'selected="selected"' : null;?>><?php echo $v; ?></option><?php
							}
							?>
						</select>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label"><?php __('extra_type');?>:</label>
				<div class="row">
					<div class="col-xs-6">
						<label class="radio radio-inline">
							<input type="radio" name="type" id="type_single" value="single" <?php echo $tpl['arr']['type'] == 'single' ? 'checked="checked"' : null;?>>
							<?php __('extra_single', false, true);?>
						</label>
					</div>
					<div class="col-xs-6">
						<label class="radio radio-inline">
							<input type="radio" name="type" id="type_multi" value="multi" <?php echo $tpl['arr']['type'] == 'multi' ? 'checked="checked"' : null;?>>
							<?php __('extra_multi', false, true);?>
						</label>
					</div>
				</div>
			</div>
			
			<div class="m-t-sm">
				<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
					<span class="ladda-label"><?php __('btnSave', false, true); ?></span>
					<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
				</button>
				<button type="button" class="btn btn-white btn-lg pull-right pjBtnCancelUpdateExtra"><?php __('btnCancel'); ?></button>
			</div><!-- /.m-b-lg -->
		</form>
	</div><!-- /.panel-body -->
</div><!-- /.panel panel-primary -->