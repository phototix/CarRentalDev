 <?php
 if($tpl['option_arr']['o_hide_footer'] == 'No')
 {
     ?>
     <div class="footer clearfix">
        <div class="pull-left">
        	<?php
        	if(!empty($tpl['option_arr']['o_footer_text']))
        	{
        	    echo pjSanitize::html($tpl['option_arr']['o_footer_text']);
        	}else{
            	?>
                Copyright <strong><a href="https://www.PHPJabbers.com/" target="_blank">PHPJabbers.com</a></strong> &copy; <?php echo date("Y"); ?>
                <?php
        	}
            ?>
        </div>
    
        <div class="pull-right">
        	version <?php echo PJ_SCRIPT_VERSION;?>
        </div><!-- /.pull-right -->
    </div>
    <?php
}
?>