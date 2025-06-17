<?php
$controller_name = $controller->_get->toString('controller');
$action_name = $controller->_get->toString('action');

// Dashboard
$isScriptDashboard = in_array($controller_name, array('pjAdmin')) && in_array($action_name, array('pjActionIndex'));

// Bookings
$isScriptBookings = in_array($controller_name, array('pjAdminBookings'));

// Types
$isScriptTypes = in_array($controller_name, array('pjAdminTypes'));

// Cars
$isScriptCars = in_array($controller_name, array('pjAdminCars'));
$isScriptCarsIndex = $isScriptCars && in_array($action_name, array('pjActionIndex', 'pjActionCreate', 'pjActionUpdate'));
$isScriptCarsAvailability = $isScriptCars && in_array($action_name, array('pjActionAvailability'));

// Extras
$isScriptExtras = in_array($controller_name, array('pjAdminExtras'));

// Locations
$isScriptLocations = in_array($controller_name, array('pjAdminLocations'));

// Time
$isScriptTimeController = in_array($controller_name, array('pjAdminTime'));

// Payments
$isScriptPaymentsController = in_array($controller_name, array('pjPayments'));

// Settings
$isScriptOptionsController = in_array($controller_name, array('pjAdminOptions')) && !in_array($action_name, array('pjActionPreview', 'pjActionInstall'));

$isScriptOptionsBooking         = $isScriptOptionsController && in_array($action_name, array('pjActionBooking'));
$isScriptOptionsBookingForm     = $isScriptOptionsController && in_array($action_name, array('pjActionBookingForm'));
$isScriptOptionsTerm            = $isScriptOptionsController && in_array($action_name, array('pjActionTerm'));
$isScriptOptionsNotifications   = $isScriptOptionsController && in_array($action_name, array('pjActionNotifications'));
$isScriptTime       			= in_array($controller_name, array('pjAdminTime'));

// Permissions - Dashboard
$hasAccessScriptDashboard = pjAuth::factory('pjAdmin', 'pjActionIndex')->hasAccess();

// Permissions - Bookings
$hasAccessScriptBookings = pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess();

// Permissions - Types
$hasAccessScriptTypes          = pjAuth::factory('pjAdminTypes')->hasAccess();

// Permissions - Cars
$hasAccessScriptCars          = pjAuth::factory('pjAdminCars')->hasAccess();
$hasAccessScriptCarsIndex     = pjAuth::factory('pjAdminCars', 'pjActionIndex')->hasAccess();
$hasAccessScriptCarsAvailability     = pjAuth::factory('pjAdminCars', 'pjActionAvailability')->hasAccess();

// Permissions - Extras
$hasAccessScriptExtras          = pjAuth::factory('pjAdminExtras')->hasAccess();

// Permissions - Locations
$hasAccessScriptLocations          = pjAuth::factory('pjAdminLocations')->hasAccess();

// Permissions - Time
$hasAccessScriptTime    = pjAuth::factory('pjAdminTime', 'pjActionIndex')->hasAccess();

// Permissions - Payments
$hasAccessScriptPayments = pjAuth::factory('pjPayments', 'pjActionIndex')->hasAccess();

// Permissions - Settings
$hasAccessScriptOptions                 = pjAuth::factory('pjAdminOptions')->hasAccess();
$hasAccessScriptOptionsBooking          = pjAuth::factory('pjAdminOptions', 'pjActionBooking')->hasAccess();
$hasAccessScriptOptionsPayments         = pjAuth::factory('pjAdminOptions', 'pjActionPayments')->hasAccess();
$hasAccessScriptOptionsBookingForm      = pjAuth::factory('pjAdminOptions', 'pjActionBookingForm')->hasAccess();
$hasAccessScriptOptionsTerm             = pjAuth::factory('pjAdminOptions', 'pjActionTerm')->hasAccess();
$hasAccessScriptOptionsNotifications    = pjAuth::factory('pjAdminOptions', 'pjActionNotifications')->hasAccess();
?>

<?php if ($hasAccessScriptDashboard): ?>
    <li<?php echo $isScriptDashboard ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdmin&amp;action=pjActionIndex"><i class="fa fa-th-large"></i> <span class="nav-label"><?php __('plugin_base_menu_dashboard');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptBookings): ?>
    <li<?php echo $isScriptBookings ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex"><i class="fa fa-list"></i> <span class="nav-label"><?php __('menuBookings');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptTypes): ?>
    <li<?php echo $isScriptTypes ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminTypes&amp;action=pjActionIndex"><i class="fa fa-list"></i> <span class="nav-label"><?php __('menuRates');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptCars): ?>
    <li<?php echo $isScriptCars ? ' class="active"' : NULL; ?>>
    	<a href="#"><i class="fa fa-car"></i> <span class="nav-label"><?php __('menuCars');?></span><span class="fa arrow"></span></a>
    	<ul class="nav nav-second-level collapse">
			<?php if ($hasAccessScriptCarsIndex): ?>
				<li<?php echo $isScriptCarsIndex ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminCars&amp;action=pjActionIndex"><?php __('lblAllCars');?></a></li>
			<?php endif; ?>
			<?php if ($hasAccessScriptCarsAvailability): ?>
				<li<?php echo $isScriptCarsAvailability ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminCars&amp;action=pjActionAvailability"><?php __('lblAvailability');?></a></li>
			<?php endif; ?>
		</ul>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptExtras): ?>
    <li<?php echo $isScriptExtras ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminExtras&amp;action=pjActionIndex"><i class="fa fa-plus"></i> <span class="nav-label"><?php __('menuExtras');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptLocations): ?>
    <li<?php echo $isScriptLocations || $isScriptTimeController ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminLocations&amp;action=pjActionIndex"><i class="fa fa-map-marker"></i> <span class="nav-label"><?php __('menuLocations');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptOptions || $hasAccessScriptPayments): ?>
    <li<?php echo $isScriptOptionsController || $isScriptPaymentsController ? ' class="active"' : NULL; ?>>
        <a href="#"><i class="fa fa-cogs"></i> <span class="nav-label"><?php __('menuOptions');?></span><span class="fa arrow"></span></a>
        <ul class="nav nav-second-level collapse">
            <?php if ($hasAccessScriptOptionsBooking): ?>
                <li<?php echo $isScriptOptionsBooking ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionBooking"><?php __('menuRentalSettings');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptPayments): ?>
                <li<?php echo $isScriptPaymentsController ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjPayments&amp;action=pjActionIndex"><?php __('menuPayments');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsBookingForm): ?>
                <li<?php echo $isScriptOptionsBookingForm ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionBookingForm"><?php __('menuCheckoutForm');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsNotifications): ?>
                <li<?php echo $isScriptOptionsNotifications ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionNotifications&amp;recipient=client&transport=email&amp;variant=confirmation"><?php __('menuConfirmation');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsTerm): ?>
                <li<?php echo $isScriptOptionsTerm ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionTerm"><?php __('menuTerms');?></a></li>
            <?php endif; ?>

        </ul>
    </li>
<?php endif; ?>