<select id="car_id" name="car_id[]" multiple="multiple" class="form-control select-item">
	<?php
	foreach ($tpl['car_arr'] as $v)
	{
	    $car_types = explode("~::~", pjSanitize::html($v['car_types']));
	    ?><option value="<?php echo $v['id']; ?>" ><?php echo pjSanitize::clean($v['car_name'] ." - ". $v['registration_number']); ?> / <?php echo $car_types[0];?></option><?php
	}
	?>
</select>