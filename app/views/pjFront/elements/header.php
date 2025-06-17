<?php $get = $controller->_get->raw();?>
<div class="panel-heading clearfix pjCrHeading">
	<div class="row">
		<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
			<div class="btn-group pjCrNav">
				<button type="button" class="btn btn-default dropdown-toggle text-capitalize pjCrBtnNav" data-pj-toggle="dropdown" aria-expanded="false">
				<?php
				switch ($get['action']) {
					case 'pjActionLoadSearch':
						__('front_menu_1_of_5');
						break;
					
					case 'pjActionLoadCars':
						__('front_menu_2_of_5');
						break;
					case 'pjActionLoadExtras':
						__('front_menu_3_of_5');
						break;
					case 'pjActionLoadCheckout':
						__('front_menu_4_of_5');
						break;
					case 'pjActionLoadFinal':
						__('front_menu_5_of_5');
						break;
				} 
				?> 
				<span class="caret"></span></button>
					
				<ul class="dropdown-menu text-uppercase" role="menu">
					<li><a href="javascript:void(0);" rel="1" class="crBreadcrumbsEl btn btn-link pjCrBtn<?php echo $get['action'] == 'pjActionLoadSearch' ? ' pjCrBtnActive' : NULL; ?><?php echo isset($_SESSION[$controller->default_product][$controller->default_order]['1_passed']) && $_SESSION[$controller->default_product][$controller->default_order]['1_passed'] && $get['action'] != 'pjActionLoadSearch' ?  ' pjCrBtnPassed' : NULL; ?>"><?php  __('front_menu_step1'); ?></a></li>
					<li><a href="javascript:void(0);" rel="2" class="crBreadcrumbsEl btn btn-link pjCrBtn<?php echo $get['action'] == 'pjActionLoadCars' ? ' pjCrBtnActive' : NULL; ?><?php echo isset($_SESSION[$controller->default_product][$controller->default_order]['2_passed']) && $_SESSION[$controller->default_product][$controller->default_order]['2_passed'] && $get['action'] != 'pjActionLoadCars' ?  ' pjCrBtnPassed' : ($get['action'] != 'pjActionLoadCars' ? ' disabled' : NULL); ?>"><?php  __('front_menu_step2'); ?></a></li>
					<li><a href="javascript:void(0);" rel="3" class="crBreadcrumbsEl btn btn-link pjCrBtn<?php echo $get['action'] == 'pjActionLoadExtras' ? ' pjCrBtnActive' : NULL; ?><?php echo isset($_SESSION[$controller->default_product][$controller->default_order]['3_passed']) && $_SESSION[$controller->default_product][$controller->default_order]['3_passed'] && $get['action'] != 'pjActionLoadExtras' ?  ' pjCrBtnPassed' : ($get['action'] != 'pjActionLoadExtras' ? ' disabled' : NULL); ?>"><?php  __('front_menu_step3'); ?></a></li>
					<li><a href="javascript:void(0);" rel="4" class="crBreadcrumbsEl btn btn-link pjCrBtn<?php echo $get['action'] == 'pjActionLoadCheckout' ? ' pjCrBtnActive' : NULL; ?><?php echo isset($_SESSION[$controller->default_product][$controller->default_order]['4_passed']) && $_SESSION[$controller->default_product][$controller->default_order]['4_passed'] && $get['action'] != 'pjActionLoadCheckout' ?  ' pjCrBtnPassed' : ($get['action'] != 'pjActionLoadCheckout' ? ' disabled' : NULL); ?>"><?php  __('front_menu_step4'); ?></a></li>
					<li><a href="javascript:void(0);" rel="5" class="crBreadcrumbsEl btn btn-link pjCrBtn<?php echo $get['action'] == 'pjActionLoadFinal' ? ' pjCrBtnActive' : ' disabled'; ?>"><?php  __('front_menu_step5'); ?></a></li>
				</ul>
			</div><!-- /.btn-group pjCrNav -->
		</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
		<?php
		if(!isset($get['pjLang']))
		{
			if (!isset($get['locale']) || (int) $get['locale'] <= 0)
			{
				if (isset($tpl['locale_arr']) && is_array($tpl['locale_arr']) && count($tpl['locale_arr']) > 1)
				{
					$selected_title = null;
					$selected_src = NULL;
					foreach ($tpl['locale_arr'] as $locale)
					{
						if($controller->getLocaleId() == $locale['id'])
						{
							$selected_title = $locale['language_iso'];
							$lang_iso = explode("-", $selected_title);
							if(isset($lang_iso[1]))
							{
								$selected_title = $lang_iso[1];
							}
							if (!empty($locale['flag']) && is_file(PJ_INSTALL_PATH . $locale['flag']))
							{
								$selected_src = PJ_INSTALL_URL . $locale['flag'];
							} elseif (!empty($locale['file']) && is_file(PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'])) {
								$selected_src = PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'];
							}
							break;
						}
					}
					?>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						<div class="btn-group pjCrLanguage">
							<button type="button" class="btn btn-default dropdown-toggle pjCrBtnNav" data-pj-toggle="dropdown" aria-expanded="false">
								<img src="<?php echo $selected_src; ?>" alt="">
								<span class="title"><?php echo $selected_title; ?></span>
								<span class="caret"></span>
							</button>
							
							<ul class="dropdown-menu text-capitalize" role="menu">
								<?php
								foreach ($tpl['locale_arr'] as $locale)
								{
									$selected_src = NULL;
									if (!empty($locale['flag']) && is_file(PJ_INSTALL_PATH . $locale['flag']))
									{
										$selected_src = PJ_INSTALL_URL . $locale['flag'];
									} elseif (!empty($locale['file']) && is_file(PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'])) {
										$selected_src = PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'];
									}
									?>
									<li>
										<a href="#" class="crLocaleEl<?php echo $controller->getLocaleId() == $locale['id'] ? ' pjCrBtnActive' : NULL; ?>" rel="<?php echo $locale['id']; ?>" data-id="<?php echo $locale['id']; ?>" title="<?php echo htmlspecialchars($locale['title']); ?>">
											<img src="<?php echo $selected_src; ?>" alt="">
											<?php echo pjSanitize::html($locale['name']); ?>
										</a>
									</li>
									<?php
								} 
								?>
							</ul><!-- /.dropdown-menu text-uppercase -->
						</div><!-- /.btn-group pjCrLanguage -->
					</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-12 -->
					<?php
				}
			}
		}
		?>
	</div><!-- /.row -->
</div><!-- /.panel-heading clearfix pjCrHeading -->