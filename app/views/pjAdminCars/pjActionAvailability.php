<?php
$date_format = pjUtil::toBootstrapDate($tpl['option_arr']['o_date_format']);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);

$post = $controller->_post->raw();
$date_from = isset($post['date_from']) ? pjDateTime::formatDate(date('Y-m-d', strtotime($post['date_from'])), "Y-m-d", $tpl['option_arr']['o_date_format']) : date($tpl['option_arr']['o_date_format']);
$date_to = isset($post['date_to']) ? pjDateTime::formatDate(date('Y-m-d', strtotime($post['date_to'])),"Y-m-d", $tpl['option_arr']['o_date_format']) : date($tpl['option_arr']['o_date_format'], strtotime(date('Y-m-d') . ' +7 days'));
?>
<div id="datePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-format="<?php echo $date_format; ?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php echo __('infoAvailabilityTitle', true); ?></h2>
            </div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo __('infoAvailabilityDesc', true);?></p>
    </div><!-- /.col-md-12 -->
</div>

<div class="wrapper wrapper-content animated fadeInRight">
	
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form action="" method="get" name="frmAvailability" id="frmAvailability" class="form-horizontal frm-filter">
                    	<div class="row m-b-md">
                    		<div class="col-md-2 col-sm-6">
	                    		<label class="control-label"><?php __('lblFrom'); ?></label>
                                <div class="input-group"> 
									<input type="text" name="date_from" id="date_from" value="<?php echo $date_from; ?>" class="form-control datepick" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" /> 
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
	                    	</div>
	                    	<div class="col-md-2 col-sm-6">
	                    		<label class="control-label"><?php __('lblTo'); ?></label>
                                <div class="input-group"> 
									<input type="text" name="date_to" id="date_to" value="<?php echo $date_to; ?>" class="form-control datepick" readonly="readonly" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" /> 
									<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
	                    	</div>
	                    	<div class="col-md-4 col-sm-6">
	                    		<label class="control-label"><?php __('lblFilterByType'); ?></label>
                                <select name="car_type" id="car_type" class="form-control select-item">
                                	<option value="">-- <?php __('lblChoose'); ?> --</option>
									<?php
									foreach ($tpl['type_arr'] as $type)
									{
										
										?><option value="<?php echo $type['id']; ?>" ><?php echo pjSanitize::clean($type['name']); ?></option><?php
										
									}
									?>
                                </select>
	                    	</div>
	                    	<div class="col-md-4 col-sm-6">
	                    		<label class="control-label"><?php __('lblCars'); ?></label>
	                    		<div id="pjCrCarSelection">
                                    <select id="car_id" name="car_id[]" multiple="multiple" class="form-control select-item">
                                    	<?php
    									foreach ($tpl['car_arr'] as $v)
    									{
    									    $car_types = explode("~::~", pjSanitize::html($v['car_types']));
    									    ?><option value="<?php echo $v['id']; ?>" ><?php echo pjSanitize::clean($v['car_name'] ." - ". $v['registration_number']); ?> / <?php echo $car_types[0];?></option><?php
    									}
    									?>
                                    </select>
                                </div>
	                    	</div>
                    	</div>
                    </form>
                    
                    <div class="row">
                    	<div class="col-xs-12">
                    		<div class="pj-availability-outer">
                    			<div class="pj-availability-loader"></div>
								<div id="pj_availability_content" class="pj-availability-content"></div>
							</div>
                    	</div>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.choose = <?php x__encode('lblChoose', false, true); ?>;
</script>