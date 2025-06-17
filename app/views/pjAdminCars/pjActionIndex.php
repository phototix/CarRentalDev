<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$get = $controller->_get->raw();
?>
	<div class="row wrapper border-bottom white-bg page-heading">
		<div class="col-sm-12">
			<div class="row">
				<div class="col-lg-9 col-md-8 col-sm-6">
					<h2><?php __('infoCarsTitle'); ?></h2>
				</div>
				<div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
                    <?php if ($tpl['is_flag_ready']) : ?>
					<div class="multilang"></div>
					<?php endif; ?>    
            	</div>
			</div>
			<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoCarsBody'); ?></p>
		</div>
	</div>
	
	<div class="row wrapper wrapper-content animated fadeInRight">
		<div class="col-lg-9">
			<div class="ibox float-e-margins">
				<div class="ibox-content">
					<div class="row">
						<div class="col-lg-6">
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
						</div><!-- /.col-lg-6 -->
					</div><!-- /.row -->
					<div id="grid"></div>
				</div>
			</div>
		</div><!-- /.col-lg-8 -->
	
		<div class="col-lg-3">
			<div class="panel no-borders boxFormCar">
				<?php 
				if(pjAuth::factory('pjAdminCars', 'pjActionCreate')->hasAccess())
				{
				    include_once dirname(__FILE__) . '/elements/add-car.php';
				}
				?>
			</div><!-- /.panel panel-primary -->
		</div><!-- /.col-lg-4 -->
	</div>
	
	<script type="text/javascript">
	var myLabel = myLabel || {};
	var pjGrid = pjGrid || {};
	pjGrid.queryString = "";
	<?php
	if (isset($get['type_id']) && (int) $get['type_id'] > 0)
	{
		?>pjGrid.queryString += "&type_id=<?php echo (int) $get['type_id']; ?>";<?php
	}
	?>
	myLabel.selected_car_id = 0;
	<?php if (isset($get['id']) && (int)$get['id'] > 0)
	{
		?>
		myLabel.selected_car_id = <?php echo (int)$get['id'];?>;
		<?php 
	}
	?>
	pjGrid.hasAccessCreate = <?php echo pjAuth::factory('pjAdminCars', 'pjActionCreate')->hasAccess() ? 'true' : 'false';?>;
	pjGrid.hasAccessUpdate = <?php echo pjAuth::factory('pjAdminCars', 'pjActionUpdate')->hasAccess() ? 'true' : 'false';?>;
	pjGrid.hasAccessDeleteSingle = <?php echo pjAuth::factory('pjAdminCars', 'pjActionDelete')->hasAccess() ? 'true' : 'false';?>;
	pjGrid.hasAccessDeleteMulti = <?php echo pjAuth::factory('pjAdminCars', 'pjActionDeleteBulk')->hasAccess() ? 'true' : 'false';?>;
	
	myLabel.car_location = <?php x__encode('car_location'); ?>;
	myLabel.car_make = <?php x__encode('car_make'); ?>;
	myLabel.car_model = <?php x__encode('car_model'); ?>;
	myLabel.car_reg = <?php x__encode('car_reg'); ?>;
	myLabel.car_type = <?php x__encode('car_type'); ?>;	
	myLabel.status = <?php x__encode('lblStatus'); ?>;
	myLabel.active = <?php x__encode('filter_ARRAY_active'); ?>;
	myLabel.inactive = <?php x__encode('filter_ARRAY_inactive'); ?>;
	myLabel.delete_selected = <?php x__encode('delete_selected', false, true); ?>;
	myLabel.delete_confirmation = <?php x__encode('delete_confirmation', false, true); ?>;
	myLabel.isFlagReady = "<?php echo $tpl['is_flag_ready'] ? 1 : 0;?>";
	myLabel.choose = <?php x__encode('lblChoose', false, true); ?>;
	myLabel.car_same_reg = <?php x__encode('car_same_reg'); ?>;
	<?php if ($tpl['is_flag_ready']) : ?>
		var pjLocale = pjLocale || {};
		pjLocale.langs = <?php echo $tpl['locale_str']; ?>;
		pjLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
	<?php endif; ?>
	</script>