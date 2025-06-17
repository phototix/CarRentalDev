<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAppController extends pjBaseAppController
{
	public $models = array();

	private $layoutRange = array(1, 2);
	
    public function pjActionCheckInstall()
    {
        $this->setLayout('pjActionEmpty');

        $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());
        $folders = array('app/web/upload');
        foreach ($folders as $dir)
        {
            if (!is_writable($dir))
            {
                $result['status'] = 'ERR';
                $result['code'] = 101;
                $result['text'] = 'Permission requirement';
                $result['info'][] = sprintf('Folder \'<span class="bold">%1$s</span>\' is not writable. You need to set write permissions (chmod 777) to directory located at \'<span class="bold">%1$s</span>\'', $dir);
            }
        }

        return $result;
    }

    /**
     * Sets some predefined role permissions and grants full permissions to Admin.
     */
    public function pjActionAfterInstall()
    {
        $this->setLayout('pjActionEmpty');

        $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());

        $pjAuthRolePermissionModel = pjAuthRolePermissionModel::factory();
        $pjAuthUserPermissionModel = pjAuthUserPermissionModel::factory();

        $permissions = pjAuthPermissionModel::factory()->findAll()->getDataPair('key', 'id');

        $roles = array(1 => 'admin', 2 => 'editor', 3 => 'employee');
        foreach ($roles as $role_id => $role)
        {
            if (isset($GLOBALS['CONFIG'], $GLOBALS['CONFIG']["role_permissions_{$role}"])
                && is_array($GLOBALS['CONFIG']["role_permissions_{$role}"])
                && !empty($GLOBALS['CONFIG']["role_permissions_{$role}"]))
            {
                $pjAuthRolePermissionModel->reset()->where('role_id', $role_id)->eraseAll();

                foreach ($GLOBALS['CONFIG']["role_permissions_{$role}"] as $role_permission)
                {
                    if($role_permission == '*')
                    {
                        // Grant full permissions for the role
                        foreach($permissions as $key => $permission_id)
                        {
                            $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
                        }
                        break;
                    }
                    else
                    {
                        $hasAsterix = strpos($role_permission, '*') !== false;
                        if($hasAsterix)
                        {
                            $role_permission = str_replace('*', '', $role_permission);
                        }

                        foreach($permissions as $key => $permission_id)
                        {
                            if($role_permission == $key || ($hasAsterix && strpos($key, $role_permission) !== false))
                            {
                                $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
                            }
                        }
                    }
                }
            }
        }

		// Grant full permissions to Admin
        $user_id = 1; // Admin ID
        $pjAuthUserPermissionModel->reset()->where('user_id', $user_id)->eraseAll();
        foreach($permissions as $key => $permission_id)
        {
            $pjAuthUserPermissionModel->setAttributes(compact('user_id', 'permission_id'))->insert();
        }

        return $result;
    }
	
	public function getLayoutRange()
	{
		return $this->layoutRange;
	}
	
    public function beforeFilter()
    {
        parent::beforeFilter();

        if(!in_array($this->_get->toString('controller'), array('pjFront')))
        {
            $this->appendJs('pjAdminCore.js');
            // TODO: DELETE unnecessary files
            #$this->appendCss('reset.css');
            #$this->appendCss('pj-all.css', PJ_FRAMEWORK_LIBS_PATH . 'pj/css/');
            $this->appendCss('admin.css');
            
            /* $this->appendJs('jquery-ui.min.js', PJ_THIRD_PARTY_PATH . 'jquery_ui/');
            $this->appendCss('jquery-ui.min.css', PJ_THIRD_PARTY_PATH . 'jquery_ui/'); */
        }
        
        return true;
    }
    
    public function getForeignId()
    {
    	return 1;
    }
    
    public function isInvoiceReady()
	{
		return $this->isAdmin();
	}
    
    public function isCountryReady()
    {
    	return $this->isAdmin();
    }
    
    public function isOneAdminReady()
    {
    	return $this->isAdmin();
    }
    
    public function isWebsiteContentReady()
	{
		return $this->isAdmin();
	}
	
	public function isContactFormReady()
	{
		return $this->isAdmin();
	}	
    
    public static function jsonDecode($str)
	{
		$Services_JSON = new pjServices_JSON();
		return $Services_JSON->decode($str);
	}
	
	public static function jsonEncode($arr)
	{
		$Services_JSON = new pjServices_JSON();
		return $Services_JSON->encode($arr);
	}
	
	public static function jsonResponse($arr)
	{
		header("Content-Type: application/json; charset=utf-8");
		echo pjAppController::jsonEncode($arr);
		exit;
	}

	public function getLocaleId()
	{
		return isset($_SESSION[$this->defaultLocale]) && (int) $_SESSION[$this->defaultLocale] > 0 ? (int) $_SESSION[$this->defaultLocale] : 1;
	}
	
	public function setLocaleId($locale_id)
	{
		$_SESSION[$this->defaultLocale] = (int) $locale_id;
	}
	
	public function setTheme($theme)
	{
		$_SESSION[$this->defaultTheme] = $theme;
	}
	
	public function getTheme()
	{
		return isset($_SESSION[$this->defaultTheme]) && !empty($_SESSION[$this->defaultTheme]) ? $_SESSION[$this->defaultTheme] : false;
	}
	
	public function friendlyURL($str, $divider='-')
	{
		$str = mb_strtolower($str, mb_detect_encoding($str)); // change everything to lowercase
		$str = trim($str); // trim leading and trailing spaces
		$str = preg_replace('/[_|\s]+/', $divider, $str); // change all spaces and underscores to a hyphen
		$str = preg_replace('/\x{00C5}/u', 'AA', $str);
		$str = preg_replace('/\x{00C6}/u', 'AE', $str);
		$str = preg_replace('/\x{00D8}/u', 'OE', $str);
		$str = preg_replace('/\x{00E5}/u', 'aa', $str);
		$str = preg_replace('/\x{00E6}/u', 'ae', $str);
		$str = preg_replace('/\x{00F8}/u', 'oe', $str);
		$str = preg_replace('/[^a-z\x{0400}-\x{04FF}0-9-]+/u', '', $str); // remove all non-cyrillic, non-numeric characters except the hyphen
		$str = preg_replace('/[-]+/', $divider, $str); // replace multiple instances of the hyphen with a single instance
		$str = preg_replace('/^-+|-+$/', '', $str); // trim leading and trailing hyphens
		return $str;
	}
	
	public static function getCartPrices($productName, $cartName)
    {
		$_arr = array();
		$e_arr = array();
		if (isset($_SESSION[$productName][$cartName]) && isset($_SESSION[$productName][$cartName]['extras']))
		{
			$_arr = array_keys($_SESSION[$productName][$cartName]['extras']);
		}
		$_arr = array_unique($_arr);
		
		if(count($_arr) > 0){
			$e_arr = pjExtraModel::factory()->select('t1.*')
										  ->where('t1.status', 'T')
										  ->where('t1.id IN (' . join(',', $_arr) . ')')
										  ->findAll()->getData();
		}
		
		$extra_arr = array();
		foreach ($e_arr as $extra)
		{
			$extra_arr[$extra['id']] = $extra;
		}
		return $extra_arr;
    }
    
	public static function getCartTotal($productName, $cartName, $option_arr)
    {
    	$arr = pjAppController::getCartPrices($productName, $cartName);
    	
    	$price = 0;
    	$extra_price = 0;
    	$price_per_day = 0;
    	$price_per_hour = 0;
    	$price_per_day_detail = '';
    	$price_per_hour_detail = '';
    	$car_rental_fee = 0;
    	$sub_total = 0;
    	$total_price = 0;
    	$required_deposit = 0;
    	
    	$date_from = $_SESSION[$productName][$cartName]['date_from'];
		$date_to = $_SESSION[$productName][$cartName]['date_to'];
		
		$datetime_from = $date_from." ".$_SESSION[$productName][$cartName]['hour_from'] . ":" . $_SESSION[$productName][$cartName]['minutes_from'];
		$datetime_to = $date_to." ".$_SESSION[$productName][$cartName]['hour_to'] . ":" . $_SESSION[$productName][$cartName]['minutes_to'];
    	
    	$real_rental_days = pjAppController::getRealRentalDays($datetime_from, $datetime_to, $option_arr);
    	
    	if (isset($_SESSION[$productName][$cartName]) && isset($_SESSION[$productName][$cartName]['extras']))
    	{
    		foreach ($_SESSION[$productName][$cartName]['extras'] as $extra_id => $v)
    		{
				if (isset($arr[$extra_id]) && isset($arr[$extra_id]['price']))
				{
					switch ($arr[$extra_id]['per'])
					{
						case 'day':
							$price += (float) $arr[$extra_id]['price'] * $real_rental_days * $_SESSION[$productName][$cartName]['extras'][$extra_id]['extra_quantity'];
							break;
						case 'booking':
							$price += (float) $arr[$extra_id]['price'] * $_SESSION[$productName][$cartName]['extras'][$extra_id]['extra_quantity'];
							break;
					}
				}
    		}
    	}
    	$extra_price = $price;
    	
    	$type_arr = pjTypeModel::factory()->find($_SESSION[$productName][$cartName]['type_id'])->getData();
    	
		$seconds = abs(strtotime($datetime_from) - strtotime($datetime_to));
		$rental_days = floor($seconds / 86400);
		$rental_hours = ceil($seconds / 3600);
		$extra_hours = intval($rental_hours - ($rental_days * 24));
		
    	$price_arr = pjAppController::getPrices($datetime_from, $datetime_to, $type_arr, $option_arr);
    	
    	if($price_arr['price'] == 0)
    	{
    		$price_arr = pjAppController::getDefaultPrices($datetime_from, $datetime_to, $type_arr, $option_arr);
    	}
    	$car_rental_fee = $price_arr['price'];
    	$price_per_day = $price_arr['price_per_day'];
    	$price_per_hour = $price_arr['price_per_hour'];
    	$price_per_day_detail = $price_arr['price_per_day_detail'];
    	$price_per_hour_detail = $price_arr['price_per_hour_detail'];
    	
    	$price += $car_rental_fee;
    	
    	$insurance = $option_arr['o_insurance_payment'];
    	if($option_arr['o_insurance_payment_type'] == 'percent')
		{
			$insurance = ($price * $option_arr['o_insurance_payment']) / 100;
		}elseif($option_arr['o_insurance_payment_type'] == 'perday'){
			$_rental_days = $rental_days;
			if($extra_hours > 0 && $option_arr['o_booking_periods'] == 'perday')
			{
				if($option_arr['o_new_day_per_day'] == 0)
				{
					$_rental_days++;
				}
				if($option_arr['o_new_day_per_day'] > 0 && $extra_hours > $option_arr['o_new_day_per_day']){
					$_rental_days++;
				}
			}
			$insurance = $_rental_days * $option_arr['o_insurance_payment'];
		}
    	$sub_total = $car_rental_fee + $extra_price + $insurance;
		
    	$tax =  $option_arr['o_tax_payment'];
    	if($option_arr['o_tax_type'] == 'percent')
    	{
    		$tax = ($sub_total * $option_arr['o_tax_payment']) / 100;
    	}
    	$total_price = $sub_total + $tax;
    	    	
    	$security  = (float)$option_arr['o_security_payment'];
		
		switch ($option_arr['o_deposit_type'])
		{
			case 'percent':
				$required_deposit = (float)(($total_price * $option_arr['o_deposit_payment']) / 100);
				break;
			case 'amount':
				$required_deposit = (float)$option_arr['o_deposit_payment'];
				break;
		}
    
		return array(	'rental_days' => $rental_days, 'rental_hours' => $extra_hours,
						'price_per_day' => round($price_per_day, 2), 'price_per_hour' => round($price_per_hour, 2),
						'price_per_day_detail' => $price_per_day_detail, 'price_per_hour_detail' => $price_per_hour_detail,
						'price' => round($price, 2), 'day_added' => $price_arr['day_added'],
						'car_rental_fee' => round($car_rental_fee, 2), 'extra_price' => round($extra_price, 2),
						'insurance' => round($insurance, 2), 'sub_total' => round($sub_total, 2),
						'tax' => round($tax, 2), 'total_price' => round($total_price, 2),
						'required_deposit' => round($required_deposit, 2), 'security_deposit' => round($security, 2));
    }
    
    static public function getRealRentalDays($datetime_from, $datetime_to, $option_arr)
    {
    	$seconds = abs(strtotime($datetime_from) - strtotime($datetime_to));
		$rental_days = floor($seconds / 86400);
		$rental_hours = ceil($seconds / 3600);
		$extra_hours = intval($rental_hours - ($rental_days * 24));
		
		if ($option_arr['o_booking_periods'] == 'perday')
		{
			if ($extra_hours > 0)
			{
				if ($option_arr['o_new_day_per_day'] == 0)
				{
					$rental_days += 1;
				}
				if ($option_arr['o_new_day_per_day'] > 0 && $extra_hours > $option_arr['o_new_day_per_day'])
				{
					$rental_days += 1;
				}
			}
		}
		
		return $rental_days;
    }
    
    public static function getPrices($datetime_from, $datetime_to, $type_arr, $option_arr)
    {
    	$pjPriceModel = pjPriceModel::factory();
    	
    	$date_from = date('Y-m-d',strtotime($datetime_from));
    	$date_to = date('Y-m-d',strtotime($datetime_to));
    	
    	$seconds = abs(strtotime($datetime_from) - strtotime($datetime_to));
		$rental_days = floor($seconds / 86400);
		$rental_hours = ceil($seconds / 3600);
		$extra_hours = intval($rental_hours - ($rental_days * 24));
		
		$price = 0;
		$price_per_day = 0;
		$price_per_hour = 0;
		$day_added = 0;
		$price_per_day_detail = '';
		$price_per_hour_detail = '';
		$price_per_day_arr = array();
		$price_per_hour_arr = array();
				
		$begin_date = strtotime($date_from);
		$end_date = strtotime($date_to);
		$i = $begin_date;
		$j = 1;
		
		if($option_arr['o_booking_periods'] == 'perday')
		{
			if($extra_hours > 0)
			{
				if($option_arr['o_new_day_per_day'] == 0)
				{
					$rental_days++;
					$day_added = 1;
				}
				if($option_arr['o_new_day_per_day'] > 0 && $extra_hours > $option_arr['o_new_day_per_day']){
					$rental_days++;
					$day_added = 1;
				}
			}
			while ($j <= $rental_days)
			{
				$price_arr = $pjPriceModel->reset()
									->where('t1.type_id',$type_arr['id'])
									->where("t1.id > 0 AND ('" . date('Y-m-d',$i) . "' BETWEEN t1.date_from AND t1.date_to ) AND price_per = 'day'")
									->where('("'.$rental_days.'" BETWEEN t1.from AND t1.to )')
									->limit(1)
									->findAll()->getData();
									
				if (count($price_arr) > 0)
				{
					$price_arr = $price_arr[0];
					$price += (float) $price_arr['price'];
					$price_per_day_arr[(string) $price_arr['price']][] = $i;
				}else{
					$price += $type_arr['price_per_day'];
					$price_per_day_arr[(string) $type_arr['price_per_day']][] = $i;
				}
				
				$j++;
	   			$i = strtotime(date('Y-m-d', $i) . ' +1 day');
			}
			$price_per_day = $price;
			
		} elseif($option_arr['o_booking_periods'] == 'perhour'){
			
			if($rental_hours > 0)
			{
				$j = 1;
				while ($j <= $rental_hours)
				{
					$price_arr = $pjPriceModel->reset()
									->where('t1.type_id',$type_arr['id'])
									->where('t1.id > 0 AND ("'.date('Y-m-d', strtotime($datetime_from) + ($j * 3600)).'" BETWEEN t1.date_from AND t1.date_to ) AND price_per = "hour"')
									->where('("'.$rental_hours.'" BETWEEN t1.from AND t1.to )')
									->limit(1)
									->findAll()->getData();
					if (count($price_arr) > 0 ) {
		    		    $price_arr = $price_arr[0];
				    	$price += (float) $price_arr['price'];
				    	$price_per_hour_arr[(string) $price_arr['price']][] = $j;
			    	}else{
			    		$price += $type_arr['price_per_hour'];
			    		$price_per_hour_arr[(string) $type_arr['price_per_hour']][] = $j;
			    	}
					$j++;
				}
			}
			$price_per_hour = $price;
		
		} elseif($option_arr['o_booking_periods'] == 'both'){
			while ($j <= $rental_days)
			{
				$price_arr = $pjPriceModel->reset()
								->where('t1.type_id',$type_arr['id'])
								->where('t1.id > 0 AND ("'.date('Y-m-d',$i).'" BETWEEN t1.date_from AND t1.date_to ) AND price_per = "day"')
								->where('("'.$rental_days.'" BETWEEN t1.from AND t1.to )')
								->limit(1)
								->findAll()->getData();
			   	if (count($price_arr) > 0) 
			   	{
				    $price_arr = $price_arr[0];
			    	$price += (float) $price_arr['price'];
			    	$price_per_day_arr[(string) $price_arr['price']][] = $i;
			   	}else{
			   		$price += $type_arr['price_per_day'];
			   		$price_per_day_arr[(string) $type_arr['price_per_day']][] = $i;
			   	}
			   	
			   	$j++;
			   	$i = strtotime(date('Y-m-d', $i) . ' +1 day');
			}
			$price_per_day = $price;
			
			$_end_ts = strtotime($datetime_from . ' +' . $rental_days . ' days');
			if($extra_hours > 0)
			{
				$j = 1;
				while ($j <= $extra_hours)
				{
					$price_arr = $pjPriceModel->reset()
									->where('t1.type_id',$type_arr['id'])
									->where('t1.id > 0 AND ("'.date('Y-m-d', $_end_ts + ($j * 3600)).'" BETWEEN t1.date_from AND t1.date_to ) AND price_per = "hour"')
									->where('("'.$extra_hours.'" BETWEEN t1.from AND t1.to )')
									->limit(1)
									->findAll()->getData();
					if (count($price_arr) > 0 ) {
		    		    $price_arr = $price_arr[0];
				    	$price += (float) $price_arr['price'];
				    	$price_per_hour_arr[(string) $price_arr['price']][] = $j;
			    	}else{
			    		$price += $type_arr['price_per_hour'];
			    		$price_per_hour_arr[(string) $type_arr['price_per_hour']][] = $j;
			    	}
					$j++;
				}
			}
			$price_per_hour = $price - $price_per_day;
		}
		
		if(!empty($price_per_day_arr))
		{
			$_day_key_arr = array();
			$_day_detail_arr = array();
			foreach($price_per_day_arr as $k => $v)
			{
				$_day_key_arr[] = $k;
			}
			foreach($_day_key_arr as $v)
			{
			    if((float) $v > 0)
			    {
    				$number_of_days = count($price_per_day_arr[$v]);
    				$_day_detail_arr[] = $number_of_days . ' ' . ($number_of_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false)) . ' x ' . pjCurrency::formatPrice($v);
			    }
			}
			$price_per_day_detail = join("<br/>", $_day_detail_arr);
		}
    	if(!empty($price_per_hour_arr))
		{
			$_hour_key_arr = array();
			$_hour_detail_arr = array();
			foreach($price_per_hour_arr as $k => $v)
			{
				$_hour_key_arr[] = $k;
			}
			foreach($_hour_key_arr as $v)
			{
			    if((float) $v > 0)
			    {
    				$number_of_hours = count($price_per_hour_arr[$v]);
    				$_hour_detail_arr[] = $number_of_hours . ' ' . ($number_of_hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false)) . ' x ' . pjCurrency::formatPrice($v);
			    }
			}
			$price_per_hour_detail = join("<br/>", $_hour_detail_arr);
		}
		
		return array('price_per_day' => $price_per_day, 'price_per_day_detail' => $price_per_day_detail,
					'price_per_hour' => $price_per_hour, 'price_per_hour_detail' => $price_per_hour_detail,
					'price' => $price, 'day_added' => $day_added);
    }
    
	public static function getDefaultPrices($datetime_from, $datetime_to, $type_arr, $option_arr)
    {
    	$pjPriceModel = pjPriceModel::factory();
    	
    	$date_from = date('Y-m-d',strtotime($datetime_from));
    	$date_to = date('Y-m-d',strtotime($datetime_to));
    	
    	$seconds = abs(strtotime($datetime_from) - strtotime($datetime_to));
		$rental_days = floor($seconds / 86400);
		$rental_hours = ceil($seconds / 3600);
		$extra_hours = intval($rental_hours - ($rental_days * 24));
		
		$price = 0;
		$price_per_day = 0;
		$price_per_hour = 0;
		$price_per_day_detail = '';
		$price_per_hour_detail = '';
		$day_added = 0;
		
		if($option_arr['o_booking_periods'] == 'perday')
		{
			if($extra_hours > 0)
			{
				if($option_arr['o_new_day_per_day'] == 0)
				{
					$rental_days++;
					$day_added = 1;
				}
				if($option_arr['o_new_day_per_day'] > 0 && $extra_hours > $option_arr['o_new_day_per_day']){
					$rental_days++;
					$day_added = 1;
				}
			}
			$price = $type_arr['price_per_day'] * $rental_days;
			$price_per_day = $price;
			$price_per_day_detail = $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false)) . ' x ' . pjCurrency::formatPrice(round($type_arr['price_per_day'], 2));
		} elseif($option_arr['o_booking_periods'] == 'perhour'){
			
			$price = $type_arr['price_per_hour'] * $rental_hours;
			$price_per_hour = $price;
			$price_per_hour_detail = $rental_hours . ' ' . ($rental_hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false)) . ' x ' . pjCurrency::formatPrice(round($type_arr['price_per_hour'], 2));
		
		} elseif($option_arr['o_booking_periods'] == 'both'){
			
			$price = $type_arr['price_per_day'] * $rental_days;
			$price_per_day = $price;
			$price_per_day_detail = $rental_days . ' ' . ($rental_days > 1 ? __('plural_day', true, false) : __('singular_day', true, false)) . ' x ' . pjCurrency::formatPrice(round($type_arr['price_per_day'], 2));
			
			$price += $type_arr['price_per_hour'] * $extra_hours;
			$price_per_hour = $price - $price_per_day;
			$price_per_hour_detail = $extra_hours . ' ' . ($extra_hours > 1 ? __('plural_hour', true, false) : __('singular_hour', true, false)) . ' x ' . pjCurrency::formatPrice(round($type_arr['price_per_hour'], 2));
			
		}
		
		return array('price_per_day' => $price_per_day, 'price_per_day_detail' => $price_per_day_detail,
					'price_per_hour' => $price_per_hour, 'price_per_hour_detail' => $price_per_hour_detail,
					'price' => $price, 'day_added' => $day_added);
    }
    
	public static function getTokens($booking_arr, $option_arr, $salt, $locale_id)
	{
		$country = NULL;
		if (!empty($booking_arr['c_country']))
		{
			$country_arr = pjBaseCountryModel::factory()
						->select('t1.*, t2.content AS country_title')
						->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$locale_id."'", 'left outer')
						->find($booking_arr['c_country'])->getData();
			if (count($country_arr) > 0)
			{
			    $country = pjSanitize::clean($country_arr['country_title']);
			}
		}
		$name_titles = __('personal_titles', true, false);
		$c_title = isset($name_titles[$booking_arr['c_title']]) ? $name_titles[$booking_arr['c_title']] : $booking_arr['c_title'];
		$payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentTitles(1, $locale_id): __('payment_methods',true);
		$payment_method = @$payment_methods[$booking_arr['payment_method']];
		$row = array();
		foreach ($booking_arr['extra_arr'] as $v)
		{
			$row[] = $v['quantity'].' x '.pjSanitize::clean($v['name']);
		}
		$booking_data = count($row) > 0 ? join("\n", $row) : NULL;
		$date_from = date($option_arr['o_date_format'], strtotime($booking_arr['from'])).', '.date($option_arr['o_time_format'], strtotime($booking_arr['from']));
		$date_to = date($option_arr['o_date_format'], strtotime($booking_arr['to'])).', '.date($option_arr['o_time_format'], strtotime($booking_arr['to']));
		$cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFront&action=pjActionCancel&id='.$booking_arr['id'].'&hash='.sha1($booking_arr['id'].$booking_arr['created'].$salt);
		$cancelURL = '<a href="'.$cancelURL.'">'.__('front_cancel_reservation', true, false).'</a>';
		$deposit = pjCurrency::formatPrice($booking_arr['required_deposit']);
		$total = pjCurrency::formatPrice($booking_arr['total_price']);
		$tax = pjCurrency::formatPrice($booking_arr['tax']);
		$security_deposit = pjCurrency::formatPrice($booking_arr['security_deposit']);
		$insurance = pjCurrency::formatPrice($booking_arr['insurance']);
		$search = array(
			'{Title}', '{Name}', '{Email}', '{Phone}', '{Country}', '{CustomerName}',
			'{City}', '{State}', '{Zip}', '{Address}',
			'{Company}', '{Notes}', '{CCType}', '{CCNum}', '{CCExp}',
			'{CCSec}', '{PaymentMethod}', '{PickupLocation}', '{ReturnLocation}', '{UniqueID}',
			'{DtFrom}', '{DtTo}', '{Type}',
			'{Deposit}', '{Total}', '{Tax}','{Security}','{Insurance}', '{BookingID}', '{Extras}', '{CancelURL}');
		$replace = array(
			$c_title, pjSanitize::html(@$booking_arr['c_name']),  pjSanitize::html(@$booking_arr['c_email']), pjSanitize::html(@$booking_arr['c_phone']), $country, pjSanitize::html(@$booking_arr['c_name']),
			pjSanitize::html(@$booking_arr['c_city']), pjSanitize::html(@$booking_arr['c_state']), pjSanitize::html(@$booking_arr['c_zip']), pjSanitize::html(@$booking_arr['c_address']),
			pjSanitize::html(@$booking_arr['c_company']), pjSanitize::html(@$booking_arr['c_notes']), $booking_arr['cc_type'], $booking_arr['cc_num'], ($booking_arr['payment_method'] == 'creditcard' ? $booking_arr['cc_exp'] : NULL),
		    $booking_arr['cc_code'], $payment_method, pjSanitize::clean($booking_arr['pickup_location']), pjSanitize::clean($booking_arr['return_location']), $booking_arr['uuid'],
			$date_from, $date_to, $booking_arr['type'],
		    $deposit, $total, $tax, $security_deposit, $insurance, $booking_arr['booking_id'], $booking_data, $cancelURL);
		
		return compact('search', 'replace');
	}
    
    public function getBookingID()
    {
    	$booking_id = '000001';
    	
    	$pjBookingModel = pjBookingModel::factory();
    	$arr = $pjBookingModel->limit(1)->orderBy("booking_id DESC")->findAll()->getData();
    	if(count($arr) > 0)
    	{
    		$_bid = $arr[0]['booking_id'];
    		$_bid = str_replace("-", "", $_bid);
    		$_bid = intval($_bid) + 1;
    		$booking_id = str_pad($_bid, 6, '0', STR_PAD_LEFT);
    	}
    	return $booking_id;
    }
    
	static public function getFromEmail()
	{
		$arr = pjAuthUserModel::factory()
			->findAll()
			->orderBy("t1.id ASC")
			->limit(1)
			->getData();
		return !empty($arr) ? $arr[0]['email'] : null;
	}
	
	static public function getAdminEmail()
	{
		 $arr = pjAuthUserModel::factory()->select('t1.email')->find(1)->getData();	    
	    return $arr ? $arr['email'] : NULL;
	}
	
	static public function getAdminPhone()
	{
		$arr = pjAuthUserModel::factory()->select('t1.phone')->find(1)->getData();	    
	    return $arr ? $arr['phone'] : NULL;
	}
}
?>