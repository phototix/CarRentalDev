<div class="pj-avail-legend">
	<div><abbr class="confirmed"></abbr><label><?php __('lblLegendConfirmed');?></label></div>
	<div><abbr class="pending"></abbr><label><?php __('lblLegendPending');?></label></div>
	<div><abbr class="pending-over"></abbr><label><?php __('lblLegendPendingOver');?></label></div>
</div>
<?php
if(count($tpl['car_arr']) > 0)
{ 
	?>
	<div class="pjTblAvailability">
		<table class="tblAvailability" id="tblAvailability" cellpadding="0" cellspacing="0" style="width: 100%;" border="0">
			<thead>
				<tr>
					<th class="crDateEmpty" width="100"><div class="text-center"><?php __('lblDate');?></div></th>
					<?php
					$j = 1;
					foreach($tpl['car_arr'] as $car)
					{
					    $car_types = explode("~::~", pjSanitize::html($car['car_types']));
						?>
						<th class="day">
							<div>
								<?php if (pjAuth::factory('pjAdminCars', 'pjActionUpdate')->hasAccess()) { ?>
									<?php echo pjSanitize::clean($car['car_name']);?> - <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminCars&amp;action=pjActionIndex&id=<?php echo $car['id'];?>"><?php echo pjSanitize::clean($car['registration_number']);?></a>
								<?php } else { 
									echo pjSanitize::clean($car['car_name']).' - '.pjSanitize::clean($car['registration_number']);
								}?>
								<br/>
								<?php echo join("<br/>", $car_types);?>
							</div>
						</th>
						<?php
						$j++;
					} 
					?>
				</tr>
			</thead>
			<tbody>
				<?php
				$run_date = $tpl['min_date'];
				$days = __('days', true, false);
				while(strtotime($run_date) <= strtotime($tpl['max_date']))
				{
					?>
					<tr class="" lang="<?php echo date('Ymd', strtotime($run_date)) ?>">
						<td class="crDate">
							<?php echo pjDateTime::formatDate($run_date, "Y-m-d", $tpl['option_arr']['o_date_format']); ?>
							<br/>
							<?php echo $days[date('w', strtotime($run_date))];?>
						</td>
						<?php
						$j = 1;
						foreach($tpl['car_arr'] as $car)
						{
							?>
							<td class="<?php echo $j == 1 ? 'first-col' : null;?>" >
								<?php
								$avail_arr = $tpl['avail_arr'][$car['id']][$run_date];
								if(empty($avail_arr))
								{
									?><br/></br><?php 
								}else{
									echo join(" ", $avail_arr);
								}
								?>
							</td>
							<?php
							$j++;
						} 
						?>
					</tr>
					<?php
					$run_date = date('Y-m-d', strtotime($run_date . ' +1 day'));
				} 
				?>
			</tbody>
		</table>
	</div>
	<?php
} else { ?>
	<h3 class="text-center"><?php __('lblAvailabilityCarsEmpty');?></h3>
<?php } ?>