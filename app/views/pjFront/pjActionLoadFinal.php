<div class="container-fluid pjCrContainer">
	<div class="panel panel-default">
		<?php include_once dirname(__FILE__) . '/elements/header.php';?>
		
		<div class="panel-body text-center pjCrBody">
			<?php
			if($tpl['arr']['total_price'] > 0)
			{ 
				if (isset($tpl['arr']['payment_method']) && !empty($tpl['arr']['payment_method']))
				{
					if(isset($tpl['params']['plugin']) && !empty($tpl['params']['plugin'])) {
						$payment_messages = __('payment_plugin_messages');
		        		$message = isset($payment_messages[$tpl['arr']['payment_method']]) ? $payment_messages[$tpl['arr']['payment_method']]: __('front_booking_success', true);
		        		?>
		        		<div class="alert alert-info" role="alert" data-payment="<?php echo $tpl['arr']['payment_method']; ?>"><?php echo $message; ?></div>
		        		<?php 
						if (pjObject::getPlugin($tpl['params']['plugin']) !== NULL)
				        {
				            $controller->requestAction(array('controller' => $tpl['params']['plugin'], 'action' => 'pjActionForm', 'params' => $tpl['params']));
				        }
					} else {
						switch ($tpl['arr']['payment_method'])
						{
							case 'bank':
								?><div class="text-success text-center">
									<p><?php __('front_final_message_1');?></p>
									<?php __('front_final_message_2');?> <?php echo $tpl['arr']['booking_id'];?>
								</div><?php
								break;
							case 'cash':
							default:
								?><div class="text-success text-center">
									<p><?php __('front_final_message_1');?></p>
									<?php __('front_final_message_2');?> <?php echo $tpl['arr']['booking_id'];?>
								</div><?php
						}	
					}
				} else {
					?>
					<div class="text-success text-center">
						<p><?php __('front_final_message_1');?></p>
						<?php __('front_final_message_2');?> <?php echo $tpl['arr']['booking_id'];?>
					</div>
				<?php 
				}
			} 
			?>
		</div><!-- /.panel-body text-center pjCrBody -->
		<?php
		if($tpl['arr']['payment_method'] == 'bank' || $tpl['arr']['payment_method'] == 'creditcard' || $tpl['arr']['payment_method'] == 'cash' || $tpl['option_arr']['o_payment_disable'] == '1') 
		{
			?>
			<div class="panel-footer clearfix text-center pjCpbFooter">
				<button id="crBtnStartOver" class="btn btn-default text-capitalize pjCrBtntDefault crBtnStartOver" type="button"><?php __('front_button_start_new');?></button>
			</div><!-- /.panel-footer clearfix text-right pjCpbFooter -->
			<?php
		} 
		?>
	</div><!-- /.panel panel-default -->
</div><!-- /.container-fluid pjCrContainer -->