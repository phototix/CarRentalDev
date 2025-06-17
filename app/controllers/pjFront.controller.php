<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFront extends pjAppController
{
	
	public $layout = 'pjFront';
	public $default_product = 'pjCarRental';
	public $defaultCaptcha = 'pjCarRental_Captcha';
	public $default_order = 'pjCarRental_Order';
	public $default_language = 'CarRental_Language';
	public $defaultLocale = 'pjCarRental_Locale';
	public $defaultMethod = 'pjCarRental_Integration_Method';
	public $defaultTheme = 'front_theme_id';
	public $defaultStep = 'pjCarRental_Step';
	
	public function __construct()
	{
		$this->setLayout('pjActionFront');
		self::allowCORS();
	}

	public function afterFilter()
	{
		$term_arr = pjMultiLangModel::factory()
			->select('t1.content')
			->where('model', 'pjOption')
			->where('field', 'o_terms')
			->where('locale', $this->getLocaleId())
			->findAll()
			->getData();
		$this->set('term_arr',$term_arr) ;
	}
	
	public function beforeFilter()
	{
		$cid = $this->getForeignId();
        $this->models['Option'] = pjBaseOptionModel::factory();
	    $base_option_arr = $this->models['Option']->getPairs($cid);
	    $script_option_arr = pjOptionModel::factory()->getPairs($cid);
	    $this->option_arr = array_merge($base_option_arr, $script_option_arr);
	    $this->set('option_arr', $this->option_arr);

		if($this->_get->check('theme'))
		{
			$this->setTheme($this->_get->toString('theme'));
		}
		
		if (!isset($_SESSION[$this->defaultLocale]))
		{
			$locale_arr = pjLocaleModel::factory()->where('is_default', 1)->limit(1)->findAll()->getData();
			if (count($locale_arr) === 1)
			{
				$this->setLocaleId($locale_arr[0]['id']);
			}
		}
		$pjLang = '';
		if($this->_get->check('pjLang') && $this->_get->toInt('pjLang') > 0)
		{
			$pjLang = $this->_get->toInt('pjLang');
			$_SESSION[$this->defaultLocale] = $pjLang;
		}
		
		if ($this->_get->check('action') && !in_array($this->_get->toString('action'), array('pjActionLoadCss')))
		{
			if((int) $pjLang > 0 && $this->_get->toString('action') == 'pjActionLoad')
			{
				$this->loadSetFields(true);
			}else{
				$this->loadSetFields();
			}
		}
		
		$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file, t2.title')
			->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
		
		$this->set('locale_arr', $locale_arr);
		
		return parent::beforeFilter();
	}
	
	public function beforeRender()
	{
	
	}
	
	public function pjActionLoadCss()
	{
		$theme = $this->_get->check('theme') ? $this->_get->toString('theme') : $this->option_arr['o_theme'];
		if((int) $theme > 0)
		{
			$theme = 'theme' . $theme;
		}
		$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
		$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
		$arr = array(
			array('file' => 'style.css', 'path' =>  PJ_CSS_PATH),
			array('file' => 'bootstrap-datetimepicker.min.css', 'path' => $dm->getPath('pj_bootstrap_datetimepicker')),
			array('file' => "$theme.css", 'path' => PJ_CSS_PATH . "themes/")
		);
		header("Content-type: text/css");
		foreach ($arr as $item)
		{
			echo str_replace(
				array("pjWrapper"),
				array("pjWrapperCarRental_" . $theme),
				@file_get_contents($item['path'] . $item['file'])) . "\n";
		}
		exit;
	}
	
	public function pjActionLoad()
	{
		$this->setAjax(false);
	    $this->setLayout('pjActionFront');
		ob_start();
		header("Content-type: text/javascript");
		
		$this->set('is_ip_blocked', pjBase::isBlockedIp(pjUtil::getClientIp(), $this->option_arr));
	}
	
	public function pjActionCaptcha()
	{
		$this->setAjax(true);
		 
		header("Cache-Control: max-age=3600, private");
		
		$rand = $this->_get->toInt('rand') ?: rand(1, 9999);
		$patterns = 'app/web/img/button.png';
		if(!empty($this->option_arr['o_captcha_background_front']) && $this->option_arr['o_captcha_background_front'] != 'plain')
		{
			$patterns = PJ_INSTALL_PATH . $this->getConstant('pjBase', 'PLUGIN_IMG_PATH') . 'captcha_patterns/' . $this->option_arr['o_captcha_background_front'];
		}
		$Captcha = new pjCaptcha(PJ_INSTALL_PATH . $this->getConstant('pjBase', 'PLUGIN_WEB_PATH') . 'obj/arialbd.ttf', $this->defaultCaptcha, (int) $this->option_arr['o_captcha_length_front']);
		$Captcha->setImage($patterns)->setMode($this->option_arr['o_captcha_mode_front'])->init($rand);
		
		exit;
	}
	
	public function pjActionCheckCaptcha()
	{
		if ($this->isXHR())
		{
			echo isset($_SESSION[$this->defaultCaptcha]) && $this->_get->check('captcha') && strtoupper($_SESSION[$this->defaultCaptcha]) == strtoupper($this->_get->toString('captcha')) ? 'true' : 'false';
		}
		exit;
	}
		
	public function pjActionCheckReCaptcha()
	{
		$this->setAjax(true);
		$verifyResponse = file_get_contents('https://www.google.com/recaptcha/api/siteverify?secret='.$this->option_arr['o_captcha_secret_key_front'].'&response='.$this->_get->toString('recaptcha'));
		$responseData = json_decode($verifyResponse);
		echo $responseData->success ? 'true': 'false';
		exit;
	}
	
	public function pjActionLoadFinal()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			if($this->_get->check('booking_id') && $this->_get->toInt('booking_id') > 0)
			{
				$booking_arr = pjBookingModel::factory()->select('t1.*')
								  		  			->find($this->_get->toInt('booking_id'))->getData();
			
				$car_arr = pjCarModel::factory()->select('t3.content as car_type')
												  ->join('pjCarType', "t1.id = t2.car_id", 'left')
												  ->join('pjMultiLang', "t3.model='pjType' AND t3.foreign_id=t2.type_id AND t3.field='name' AND t3.locale='".$booking_arr['locale_id']."'", 'left')
												  ->find($booking_arr['car_id'])->getData();
												 
				if(pjObject::getPlugin('pjPayments') !== NULL)
	            {
	                $pjPlugin = pjPayments::getPluginName($booking_arr['payment_method']);
	                if(pjObject::getPlugin($pjPlugin) !== NULL)
	                {
	                    $amount = pjCurrency::formatPriceOnly($booking_arr['required_deposit']);
	                    $params = $pjPlugin::getFormParams(array('payment_method' => $booking_arr['payment_method']), array(
	                        'locale_id'	 => $this->getLocaleId(),
	                        'return_url'	=> $this->option_arr['o_thankyou_page'],
	                        'id'			=> $booking_arr['id'],
	                        'foreign_id'	=> $this->getForeignId(),
	                        'uuid'		  => $booking_arr['uuid'],
	                        'name'		  => @$booking_arr['c_name'],
	                        'email'		 => @$booking_arr['c_email'],
	                        'phone'		 => @$booking_arr['c_phone'],
	                        'amount'		=> $amount,
	                        'cancel_hash'   => sha1($booking_arr['uuid'].strtotime($booking_arr['created']).PJ_SALT),
	                        'currency_code' => $this->option_arr['o_currency'],
	                    	'option_foreign_id' => $this->getForeignId()
	                    ));
	                    $this->set('params', $params);
	                }
	                
	                if ($booking_arr['payment_method'] == 'bank')
	                {
	                    $bank_account = pjMultiLangModel::factory()->select('t1.content')
	                    ->where('t1.model','pjOption')
	                    ->where('t1.locale', $this->getLocaleId())
	                    ->where('t1.field', 'o_bank_account')
	                    ->limit(1)
	                    ->findAll()->getDataIndex(0);
	                    $this->set('bank_account', $bank_account['content']);
	                }
	            }
			
				$this->set('arr', $booking_arr);
				$this->set('get', $this->_get->raw());
				
				if($this->_get->toString('controller') == 'pjWebsite')
				{
					$this->setTemplate('pjWebsite', 'pjActionLoadFinal');
				}
			}
		}
	}
	
	public function getCarTypes($get)
	{
		$pjTypeModel = pjTypeModel::factory ();
		
		if (isset ( $get ['type_id'] ) && ! empty ( $get ['type_id'] ) && ( int ) $get ['type_id'] > 0) {
			$pjTypeModel->where ( 't1.id', $get ['type_id'] );
		}
		if (isset ( $get ['transmission'] ) && ! empty ( $get ['transmission'] )) {
			$pjTypeModel->where ( 't1.transmission', $get ['transmission'] );
		}
		$col_name = 'total_price';
		$direction = 'asc';
		if (isset ( $get ['col_name'] ) && isset ( $get ['direction'] )) {
			$col_name = $get ['col_name'];
			$direction = in_array ( strtoupper ( $get ['direction'] ), array (
					'ASC',
					'DESC' 
			) ) ? $get ['direction'] : 'ASC';
		}
		
		$col_name = $col_name == 't1.name' ? 't2.content' : $col_name;
		
		$current_datetime = date ( 'Y-m-d H:i:s', time () - ($this->option_arr ['o_booking_pending'] * 3600) );
		$_from = $_SESSION [$this->default_product] [$this->default_order] ['date_from'] . " " . $_SESSION [$this->default_product] [$this->default_order] ['hour_from'] . ":" . $_SESSION [$this->default_product] [$this->default_order] ['minutes_from'];
		$_to = $_SESSION [$this->default_product] [$this->default_order] ['date_to'] . " " . $_SESSION [$this->default_product] [$this->default_order] ['hour_to'] . ":" . $_SESSION [$this->default_product] [$this->default_order] ['minutes_to'];
		
		$pjTypeModel->select ( "t1.*, t2.content  AS `name`, t3.content  AS `description`
			 											, " . sprintf ( "(SELECT COUNT(*) FROM `%1\$s` WHERE `type_id` = `t1`.`id` AND `car_id` NOT IN (SELECT `car_id` FROM `%2\$s` WHERE (`status` = 'confirmed' OR `status` = 'collected' OR (`status` = 'pending' AND `created` >= '$current_datetime'))
					 													AND ( ((`from` BETWEEN '%3\$s' AND '%4\$s') OR (`to` BETWEEN '%3\$s' AND '%4\$s'))
					 													OR (`from` < '%3\$s' AND `to` > '%4\$s') OR (`from` > '%3\$s' AND `to` < '%4\$s') )
					 											) LIMIT 1 ) AS `cnt_available` ", pjCarTypeModel::factory ()->getTable (), pjBookingModel::factory ()->getTable (), $_from, $_to ) . "
				" )->join ( 'pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='" . $this->getLocaleId () . "'", 'left' )->join ( 'pjMultiLang', "t3.model='pjType' AND t3.foreign_id=t1.id AND t3.field='description' AND t3.locale='" . $this->getLocaleId () . "'", 'left' )->where ( 't1.status', 'T' );
		
		// PRICE SORT
		if ($col_name == 'total_price') {
			$arr = $pjTypeModel->findAll ()->getData ();
		} else {
			$arr = $pjTypeModel->orderBy ( $col_name . " " . $direction )->findAll ()->getData ();
		}
		
		$pjCarTypeModel = pjCarTypeModel::factory ();
		foreach ( $arr as $k => $v ) {
			$arr [$k] ['example'] = array ();
			$example = $pjCarTypeModel->reset ()->select ( 't1.*, t2.content as make , t3.content as model' )->join ( 'pjMultiLang', "t2.model='pjCar' AND t2.foreign_id=t1.car_id AND t2.field='make' AND t2.locale='" . $this->getLocaleId () . "'", 'left' )->join ( 'pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t1.car_id AND t3.field='model' AND t3.locale='" . $this->getLocaleId () . "'", 'left' )->where ( "(car_id NOT IN(SELECT TB.`car_id` FROM `" . pjBookingModel::factory ()->getTable () . "` AS TB WHERE (TB.`status` = 'confirmed' OR TB.`status` = 'collected' OR (TB.`status` = 'pending' AND `created` >= '$current_datetime')) AND ( ((`from` BETWEEN '$_from' AND '$_to') OR (`to` BETWEEN '$_from' AND '$_to')) OR (`from` < '$_from' AND `to` > '$_to') OR (`from` > '$_from' AND `to` < '$_to') ) ))" )->where ( 'type_id', $v ['id'] )->findAll ()->getData ();
			if (count ( $example ) > 0)
				$arr [$k] ['example'] = $example [0];
		}
		
		// PRICES
		$date_from = $_SESSION [$this->default_product] [$this->default_order] ['date_from'];
		$date_to = $_SESSION [$this->default_product] [$this->default_order] ['date_to'];
		
		$datetime_from = $date_from . " " . $_SESSION [$this->default_product] [$this->default_order] ['hour_from'] . ":" . $_SESSION [$this->default_product] [$this->default_order] ['minutes_from'];
		$datetime_to = $date_to . " " . $_SESSION [$this->default_product] [$this->default_order] ['hour_to'] . ":" . $_SESSION [$this->default_product] [$this->default_order] ['minutes_to'];
		
		foreach ( $arr as $k => $type_arr ) {
			$amount = 0;
			$price = 0;
			$arr [$k] ['total_price'] = 0;
			$price_arr = pjAppController::getPrices( $datetime_from, $datetime_to, $type_arr, $this->option_arr);
			$amount = $price_arr ['price'];
			if ($amount == 0) {
				$price_arr = pjAppController::getDefaultPrices( $datetime_from, $datetime_to, $type_arr, $this->option_arr);
				$amount = $price_arr ['price'];
			}
			$arr [$k] ['total_price'] = $amount;
		}
		
		// PRICE SORT
		$temp_arr = array ();
		$not_avail_arr = array ();
		$value = array ();
		if ($col_name == 'total_price') {
			foreach ( $arr as $k => $v ) {
				if ($v ['total_price'] > 0 && $v ['cnt_available']) {
					$temp_arr [$k] = $v ['total_price'];
				} else {
					$not_avail_arr [$k] = 0;
				}
			}
			
			if ($direction == 'asc') {
				asort ( $temp_arr );
			} else if ($direction == 'desc') {
				arsort ( $temp_arr );
			}
			foreach ( $temp_arr as $id => $val ) {
				$value [$id] = $arr [$id];
			}
			foreach ( $not_avail_arr as $id => $val ) {
				$value [$id] = $arr [$id];
			}
			$arr = $value;
		}
		$arr = pjSanitize::clean($arr);
		return $arr;
	}
	
	public function pjActionLoadSearch()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$location_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('location_arr', pjSanitize::clean($location_arr));
			
			if (!isset($_SESSION[$this->default_product][$this->default_order]) || 
				(
					isset($_SESSION[$this->default_product][$this->default_order])) && 
					($_SESSION[$this->default_product][$this->default_order]['date_from'] < date('Y-m-d') || $_SESSION[$this->default_product][$this->default_order]['date_to'] < date('Y-m-d'))
				)
			{
				$to_string = "+2 days";
				switch ($this->option_arr['o_booking_periods'])
				{
					case 'perday':
						if ($this->option_arr['o_min_hour'] + 1 > 2)
						{
							$to_string = sprintf("+%u days", $this->option_arr['o_min_hour'] + 1);
						}
						break;
					default:
						if ($this->option_arr['o_min_hour'] > 24 * 2)
						{
							$to_string = sprintf("+%u hours", $this->option_arr['o_min_hour']);
						}
						break;
				}
				$_SESSION[$this->default_product][$this->default_order] = array();
				$_SESSION[$this->default_product][$this->default_order]['hour_from'] = "09";
				$_SESSION[$this->default_product][$this->default_order]['hour_to'] = "09";
				$_SESSION[$this->default_product][$this->default_order]['minutes_from'] = "00";
				$_SESSION[$this->default_product][$this->default_order]['minutes_to'] = "00";
				$_SESSION[$this->default_product][$this->default_order]['date_from'] = date('Y-m-d', strtotime("+1 day"));
				$_SESSION[$this->default_product][$this->default_order]['date_to'] = date('Y-m-d', strtotime($to_string));
				$_SESSION[$this->default_product][$this->default_order]['rental_days'] = 1;
			}
			
			if($this->_get->check('index') && $this->_get->toInt('index') == 0){
				unset($_SESSION[$this->default_product][$this->default_order]['1_passed']);
				unset($_SESSION[$this->default_product][$this->default_order]['2_passed']);
				unset($_SESSION[$this->default_product][$this->default_order]['3_passed']);
			}
			if($this->_get->toString('controller') == 'pjWebsite')
			{
				$this->setTemplate('pjWebsite', 'pjActionLoadSearch');
			}
		}
	}
	public function pjActionApplySearch()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			if ($this->_post->check('date_from'))
			{
				$date_from = pjDateTime::formatDate($this->_post->toString('date_from'), $this->option_arr['o_date_format']);
				$date_to = pjDateTime::formatDate($this->_post->toString('date_to'), $this->option_arr['o_date_format']);
			
				$seconds = abs(strtotime($date_to . " " . $this->_post->toString('hour_to').":".$this->_post->toString('minutes_to')) - strtotime($date_from. " " . $this->_post->toString('hour_from').":".$this->_post->toString('minutes_from')));
				$rental_days = floor($seconds / 86400);
				$rental_hours = ceil($seconds / 3600);
				$extra_hours = intval($rental_hours - ($rental_days * 24));
				$post = $this->_post->raw();
				unset($post['date_from']);
				unset($post['date_to']);
				$_SESSION[$this->default_product][$this->default_order] = array_merge($post, compact('date_from', 'date_to', 'rental_days','rental_hours'));
			}
			$_SESSION[$this->default_product][$this->default_order]['1_passed'] = true;
			unset($_SESSION[$this->default_product][$this->default_order]['2_passed']);
			unset($_SESSION[$this->default_product][$this->default_order]['3_passed']);
			unset($_SESSION[$this->default_product][$this->default_order]['4_passed']);
			$_SESSION[$this->defaultStep] = 2;
			
			pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Data has been applied.'));
		}
		exit;
	}
	public function pjActionSetCarType()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			
			$_SESSION[$this->default_product][$this->default_order]['1_passed'] = true;
			$_SESSION[$this->default_product][$this->default_order]['2_passed'] = true;
			unset($_SESSION[$this->default_product][$this->default_order]['3_passed']);
			unset($_SESSION[$this->default_product][$this->default_order]['4_passed']);
			
			if($_SESSION[$this->default_product][$this->default_order]['type_id'] != $this->_get->toInt('type_id'))
			{
				unset($_SESSION[$this->default_product][$this->default_order]['extras']);
			}
			
			$_SESSION[$this->default_product][$this->default_order]['type_id'] = $this->_get->toInt('type_id');
			$_SESSION[$this->defaultStep] = 3;
		}
	}
	public function pjActionLoadCars()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			if ($this->_post->check('date_from'))
			{
				$post = $this->_post->raw();
				$date_from = pjDateTime::formatDate($post['date_from'], $this->option_arr['o_date_format']);
				$date_to = pjDateTime::formatDate($post['date_to'], $this->option_arr['o_date_format']);
				
		    	$seconds = abs(strtotime($date_to . " " . $post['hour_to'].":".$post['minutes_to']) - strtotime($date_from. " " . $post['hour_from'].":".$post['minutes_from']));
				$rental_days = floor($seconds / 86400);
				$rental_hours = ceil($seconds / 3600);
				$extra_hours = intval($rental_hours - ($rental_days * 24));
				unset($post['date_from']);
				unset($post['date_to']);					
				$_SESSION[$this->default_product][$this->default_order] = array_merge($post, compact('date_from', 'date_to', 'rental_days','rental_hours'));
			}
			$_SESSION[$this->default_product][$this->default_order]['1_passed'] = true;
			unset($_SESSION[$this->default_product][$this->default_order]['2_passed']);
			unset($_SESSION[$this->default_product][$this->default_order]['3_passed']);
			unset($_SESSION[$this->default_product][$this->default_order]['4_passed']);
			
			$arr = $this->getCarTypes($this->_get->raw());
			
			$this->set('arr', $arr);
			
			$pjMultiLangModel = pjMultiLangModel::factory();
			$pickup_location = $pjMultiLangModel->select('t1.content AS name ')
													  ->where('model', 'pjLocation')
													  ->where('field', 'name')
													  ->where('foreign_id', @$_SESSION[$this->default_product][$this->default_order]['pickup_id'])
													  ->where('locale', $this->getLocaleId())
													  ->findAll()->getData();
            $this->set('pickup_location',pjSanitize::clean($pickup_location[0])) ;
			
			if (!isset($_SESSION[$this->default_product][$this->default_order]['same_location']))
			{
				$return_location_arr = $pjMultiLangModel->reset()->select('t1.content AS name ')
													  ->where('model', 'pjLocation')
													  ->where('field', 'name')
													  ->where('foreign_id', @$_SESSION[$this->default_product][$this->default_order]['return_id'])
													  ->where('locale', $this->getLocaleId())
													  ->findAll()->getData();
													
				$return_location = $return_location_arr[0] ;
			}else{
				$return_location = $pickup_location[0];
			}
			
			$this->set('return_location',pjSanitize::clean($return_location)) ;
			
			$type_arr = pjTypeModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
					
			$this->set('type_arr',pjSanitize::clean($type_arr)) ;
			
			if($this->_get->toString('controller') == 'pjWebsite')
			{
				$this->setTemplate('pjWebsite', 'pjActionLoadCars');
			}
		}
	}
	
	public function pjActionLoadExtras()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$arr = array();
			
			$_SESSION[$this->default_product][$this->default_order]['1_passed'] = true;
			$_SESSION[$this->default_product][$this->default_order]['2_passed'] = true;
			unset($_SESSION[$this->default_product][$this->default_order]['3_passed']);
			unset($_SESSION[$this->default_product][$this->default_order]['4_passed']);
			
			if(isset($_SESSION[$this->default_product][$this->default_order]['type_id']) && $_SESSION[$this->default_product][$this->default_order]['type_id'] != $this->_get->toInt('type_id'))
			{
				unset($_SESSION[$this->default_product][$this->default_order]['extras']);
			}
			
			$_SESSION[$this->default_product][$this->default_order]['type_id'] = $this->_get->toInt('type_id');
			
			$pjTypeModel = pjTypeModel::factory();
			$arr = pjTypeExtraModel::factory()->select('t1.*, t2.content AS name , t3.price , t3.per, t3.type AS extra_type')
									->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
									->join('pjExtra', 't3.id = t1.extra_id')
								    ->where('t1.type_id', $this->_get->toInt('type_id'))
								    ->where('t3.status', 'T')
								    ->orderBy('t1.extra_id ASC')->findAll()->getData();
			
		    $this->set('arr',pjSanitize::clean($arr)) ;
			
			
			$type_arr = $pjTypeModel->select("t1.*, t2.content as name")
									->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
									->find($this->_get->toInt('type_id'))->getData();
									
			$type_arr['example'] = array();
			$current_datetime = date('Y-m-d H:i:s', time() - ($this->option_arr['o_booking_pending'] * 3600));
			$_from = $_SESSION[$this->default_product][$this->default_order]['date_from'] . " " . $_SESSION[$this->default_product][$this->default_order]['hour_from'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_from'];
			$_to = $_SESSION[$this->default_product][$this->default_order]['date_to'] . " " . $_SESSION[$this->default_product][$this->default_order]['hour_to'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_to'];
			$example = pjCarTypeModel::factory()->reset()->select('t1.*, t2.content as make , t3.content as model')
												 ->join('pjMultiLang', "t2.model='pjCar' AND t2.foreign_id=t1.car_id AND t2.field='make' AND t2.locale='".$this->getLocaleId()."'", 'left')
												 ->join('pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t1.car_id AND t3.field='model' AND t3.locale='".$this->getLocaleId()."'", 'left')
												 ->where("(car_id NOT IN(SELECT TB.`car_id` FROM `".pjBookingModel::factory()->getTable()."` AS TB WHERE (TB.`status` = 'confirmed' OR TB.`status`='collected' OR (TB.`status` = 'pending' AND `created` >= '$current_datetime')) AND ( ((`from` BETWEEN '$_from' AND '$_to') OR (`to` BETWEEN '$_from' AND '$_to')) OR (`from` < '$_from' AND `to` > '$_to') OR (`from` > '$_from' AND `to` < '$_to') ) ))")
												 ->where('type_id',$this->_get->toInt('type_id'))->findAll()->getData();
			if(count($example) > 0)
			$type_arr['example'] = $example[0];
			
			
			$this->set('type_arr',pjSanitize::clean($type_arr)) ;
			
			$pjMultiLangModel = pjMultiLangModel::factory();
			$pickup_location = $pjMultiLangModel->select('t1.content AS name ')
													  ->where('model', 'pjLocation')
													  ->where('field', 'name')
													  ->where('foreign_id', @$_SESSION[$this->default_product][$this->default_order]['pickup_id'])
													  ->where('locale', $this->getLocaleId())
													  ->findAll()->getData();
            $this->set('pickup_location',pjSanitize::clean($pickup_location[0]));
			
			if (!isset($_SESSION[$this->default_product][$this->default_order]['same_location']))
			{
				$return_location_arr = $pjMultiLangModel->reset()->select('t1.content AS name ')
													  ->where('model', 'pjLocation')
													  ->where('field', 'name')
													  ->where('foreign_id', @$_SESSION[$this->default_product][$this->default_order]['return_id'])
													  ->where('locale', $this->getLocaleId())
													  ->findAll()->getData();
													
				$return_location = $return_location_arr[0] ;
			}else{
				$return_location = $pickup_location[0];
			}
			
			$this->set('return_location',pjSanitize::clean($return_location)) ;
			
			$type_arr = $pjTypeModel->reset()->find($this->_get->toInt('type_id'))->getData();
			
			$date_from = $_SESSION[$this->default_product][$this->default_order]['date_from'];
			$date_to = $_SESSION[$this->default_product][$this->default_order]['date_to'];
			
			$datetime_from = $date_from." ".$_SESSION[$this->default_product][$this->default_order]['hour_from'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_from'];
			$datetime_to = $date_to." ".$_SESSION[$this->default_product][$this->default_order]['hour_to'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_to'];
			
			$cart = pjAppController::getCartTotal($this->default_product, $this->default_order, $this->option_arr);
		
			$this->set('cart', $cart);
			
			$term_arr = pjMultiLangModel::factory()
				->select('t1.content')
				->where('model', 'pjOption')
				->where('field', 'o_terms')
				->where('locale', $this->getLocaleId())
				->findAll()
				->getData();
			$this->set('term_arr',$term_arr) ;
			
			if($this->_get->toString('controller') == 'pjWebsite')
			{
				$this->setTemplate('pjWebsite', 'pjActionLoadExtras');
			}
		}
	}
	
	public function pjActionAddExtra()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$code = 100;
			if (!isset($_SESSION[$this->default_product][$this->default_order]))
			{
				$_SESSION[$this->default_product][$this->default_order] = array();
			}
			if (!isset($_SESSION[$this->default_product][$this->default_order]['extras']))
			{
				$_SESSION[$this->default_product][$this->default_order]['extras'] = array();
			}
			
			if (!array_key_exists($this->_get->toInt('extra_id'), $_SESSION[$this->default_product][$this->default_order]['extras']))
			{
				$arr = pjExtraModel::factory()->find($this->_get->toInt('extra_id'))->getData();
				if (count($arr) > 0)
				{
					$_SESSION[$this->default_product][$this->default_order]['extras'][$this->_get->toInt('extra_id')] = $arr;
					$_SESSION[$this->default_product][$this->default_order]['extras'][$this->_get->toInt('extra_id')]['extra_quantity'] = isset($_REQUEST['extra_quantity'][$this->_get->toInt('extra_id')]) ? $_REQUEST['extra_quantity'][$this->_get->toInt('extra_id')] : 1;
					$code = 200;
				}
			}
			else{
				if($_REQUEST['extra_quantity'][$this->_get->toInt('extra_id')] != $_SESSION[$this->default_product][$this->default_order]['extras'][$this->_get->toInt('extra_id')]['extra_quantity'] ){
					$_SESSION[$this->default_product][$this->default_order]['extras'][$this->_get->toInt('extra_id')]['extra_quantity'] = isset($_REQUEST['extra_quantity'][$this->_get->toInt('extra_id')]) ? $_REQUEST['extra_quantity'][$this->_get->toInt('extra_id')] : 1;
					
					$code = 200;
				}
			}
			
			
			header("Content-type: application/json; charset=utf-8");
			echo '{"code":'.$code.'}';
			exit;
		}
	}
	
	public function pjActionRemoveExtra()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$code = 100;
			if (isset($_SESSION[$this->default_product][$this->default_order]) && is_array($_SESSION[$this->default_product][$this->default_order]) &&
				isset($_SESSION[$this->default_product][$this->default_order]['extras']) && is_array($_SESSION[$this->default_product][$this->default_order]['extras']) &&
				array_key_exists($this->_get->toInt('extra_id'), $_SESSION[$this->default_product][$this->default_order]['extras']))
			{
				unset($_SESSION[$this->default_product][$this->default_order]['extras'][$this->_get->toInt('extra_id')]);
				$code = 200;
			}
			
			header("Content-type: application/json; charset=utf-8");
			echo '{"code":'.$code.'}';
			exit;
		}
	}
	
	public function pjActionLoadCheckout(){
		
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$arr = array();
			
			$_SESSION[$this->default_product][$this->default_order]['1_passed'] = true;
			$_SESSION[$this->default_product][$this->default_order]['2_passed'] = true;
			$_SESSION[$this->default_product][$this->default_order]['3_passed'] = true;
			unset($_SESSION[$this->default_product][$this->default_order]['4_passed']);
			
			$pjMultiLangModel = pjMultiLangModel::factory();
			$pickup_location = $pjMultiLangModel->select('t1.content AS name ')
													  ->where('model', 'pjLocation')
													  ->where('field', 'name')
													  ->where('foreign_id', @$_SESSION[$this->default_product][$this->default_order]['pickup_id'])
													  ->where('locale', $this->getLocaleId())
													  ->findAll()->getData();
            $this->set('pickup_location',pjSanitize::clean($pickup_location[0])) ;
			
			if (!isset($_SESSION[$this->default_product][$this->default_order]['same_location']))
			{
				$return_location_arr = $pjMultiLangModel->reset()->select('t1.content AS name ')
													  ->where('model', 'pjLocation')
													  ->where('field', 'name')
													  ->where('foreign_id', @$_SESSION[$this->default_product][$this->default_order]['return_id'])
													  ->where('locale', $this->getLocaleId())
													  ->findAll()->getData();
													
				$return_location = $return_location_arr[0] ;
			}
			else{
				$return_location = $pickup_location[0];
			}
			
			$this->set('return_location',pjSanitize::clean($return_location)) ;
			
			$type_id = @$_SESSION[$this->default_product][$this->default_order]['type_id'];
			$type_arr = pjTypeModel::factory()->select("t1.*, t2.content as name")
									->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
									->find($type_id)->getData();
									
			$type_arr['example'] = array();
			$current_datetime = date('Y-m-d H:i:s', time() - ($this->option_arr['o_booking_pending'] * 3600));
			$_from = $_SESSION[$this->default_product][$this->default_order]['date_from'] . " " . $_SESSION[$this->default_product][$this->default_order]['hour_from'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_from'];
			$_to = $_SESSION[$this->default_product][$this->default_order]['date_to'] . " " . $_SESSION[$this->default_product][$this->default_order]['hour_to'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_to'];
			$example = pjCarTypeModel::factory()->reset()->select('t1.*, t2.content as make , t3.content as model')
												 ->join('pjMultiLang', "t2.model='pjCar' AND t2.foreign_id=t1.car_id AND t2.field='make' AND t2.locale='".$this->getLocaleId()."'", 'left')
												 ->join('pjMultiLang', "t3.model='pjCar' AND t3.foreign_id=t1.car_id AND t3.field='model' AND t3.locale='".$this->getLocaleId()."'", 'left')
												 ->where("(car_id NOT IN(SELECT TB.`car_id` FROM `".pjBookingModel::factory()->getTable()."` AS TB WHERE (TB.`status` = 'confirmed' OR TB.`status` = 'collected' OR (TB.`status` = 'pending' AND `created` >= '$current_datetime')) AND ( ((`from` BETWEEN '$_from' AND '$_to') OR (`to` BETWEEN '$_from' AND '$_to')) OR (`from` < '$_from' AND `to` > '$_to') OR (`from` > '$_from' AND `to` < '$_to') ) ))")
												 ->where('type_id',$type_id)->findAll()->getData();
			if(count($example) > 0)
			{
				$type_arr['example'] = $example[0];
				$_SESSION[$this->default_product][$this->default_order]['car_id'] = $example[0]['car_id'];
			}
			
			
			$this->set('type_arr',pjSanitize::clean($type_arr));
			
			$country_arr = pjBaseCountryModel::factory()
					->select('t1.id, t2.content AS country_title')
					->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->where('t1.status', 'T')
					->orderBy('`country_title` ASC')->findAll()->getData();			
			$this->set('country_arr', pjSanitize::clean($country_arr));
			
			$extra_arr = pjTypeExtraModel::factory()->select('t1.*, t2.content AS name , t3.price , t3.per ')
									->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.extra_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
									->join('pjExtra', 't3.id = t1.extra_id')
								    ->where('t1.type_id', $type_id)
								    ->where('t3.status', 'T')
								    ->orderBy('t1.extra_id ASC')->findAll()->getData();
            $this->set('extra_arr',pjSanitize::clean($extra_arr));
			
			$type_arr = pjTypeModel::factory()->find($type_id)->getData();
			
			$date_from = $_SESSION[$this->default_product][$this->default_order]['date_from'];
			$date_to = $_SESSION[$this->default_product][$this->default_order]['date_to'];
			
			$datetime_from = $date_from." ".$_SESSION[$this->default_product][$this->default_order]['hour_from'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_from'];
			$datetime_to = $date_to." ".$_SESSION[$this->default_product][$this->default_order]['hour_to'] . ":" . $_SESSION[$this->default_product][$this->default_order]['minutes_to'];
			
			$cart = pjAppController::getCartTotal($this->default_product, $this->default_order, $this->option_arr);
			
			$this->set('cart', $cart);
			
			if($this->_get->toString('controller') == 'pjWebsite')
			{
				$this->setTemplate('pjWebsite', 'pjActionLoadCheckout');
			}
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
			    $this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions($this->getForeignId()));
			    $this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}else{
			    $this->set('payment_titles', __('payment_methods', true));
			}
			
			$bank_account = pjMultiLangModel::factory()
			->select('t1.content')
			->where('t1.model','pjOption')
			->where('t1.locale', $this->getLocaleId())
			->where('t1.field', 'o_bank_account')
			->limit(1)
			->findAll()->getDataIndex(0);
			$this->set('bank_account', $bank_account ? $bank_account['content'] : '');
		}
	}
	
	private function doubleCheckData($data)
	{
	    $front_err = __('front_err', true);
	    
	    if ((int) $this->option_arr['o_bf_include_captcha'] === 3 && $this->option_arr['o_captcha_type_front'] == 'system' && (!isset($data['captcha']) || !pjCaptcha::validate(strtoupper($data['captcha']), $_SESSION[$this->defaultCaptcha])))
	    {
	        pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 110, 'text' => $front_err[110]));
	    }
	    
	    if (!pjBookingModel::factory()->validates($data))
	    {
	        pjAppController::jsonResponse(array('code' => 112, 'text' => $front_err[112]));
	    }
	    
	    /* Validate form */
	    $map = array(
	        'o_bf_include_title' => 'c_title',
	        'o_bf_include_name' => 'c_name',
	        'o_bf_include_email' => 'c_email',
	        'o_bf_include_phone' => 'c_phone',
	        'o_bf_include_company' => 'c_company',
	        'o_bf_include_address' => 'c_address',
	        'o_bf_include_country' => 'c_country',
	        'o_bf_include_state' => 'c_state',
	        'o_bf_include_city' => 'c_city',
	        'o_bf_include_zip' => 'c_zip',
	        'o_bf_include_notes' => 'c_notes'
	    );
	    $map_label = array(
	        'c_title' => __('front_4_title', true),
	        'c_name' => __('front_4_name', true),
	        'c_email' => __('front_4_email', true),
	        'c_phone' => __('front_4_phone', true),
	        'c_company' => __('front_4_company', true),
	        'c_address' => __('front_4_address', true),
	        'c_city' => __('front_4_city', true),
	        'c_state' => __('front_4_state', true),
	        'c_zip' => __('front_4_zip', true),
	        'c_country' => __('front_4_country', true),
	        'c_notes' => __('front_4_notes', true)
	    );
	    foreach ($map as $key => $idx)
	    {
	        $check = true;
	        
	        if ($this->option_arr[$key] == 2)
	        {
	            $check = array_key_exists($idx, $data);
	            
	        } elseif ($this->option_arr[$key] == 3) {
	            
	            $check = array_key_exists($idx, $data) && !empty($data[$idx]);
	        }
	        
	        if ($idx == 'c_email' && array_key_exists($idx, $data) && !empty($data[$idx]))
	        {
	            if (!pjValidation::pjActionEmail($data[$idx]))
	            {
	                $check = false;
	            }
	        }
	        
	        if (!$check)
	        {
	            if($idx == 'c_email')
	            {
	                self::jsonResponse(array('status' => 'ERR', 'code' => 113, 'text' => sprintf($front_err[113], $map_label[$idx]), 'idx' => $idx));
	            }else{
	                self::jsonResponse(array('status' => 'ERR', 'code' => 111, 'text' => sprintf($front_err[111], $map_label[$idx]), 'idx' => $idx));
	            }
	        }
	    }
	    
	    return array('status' => 'OK', 'code' => 200, 'text' => "");
	}
	
	public function pjActionBookingSave()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			$_SESSION[$this->default_product][$this->default_order]['4_passed'] = true;
			$post = $this->_post->raw();
			$opts = pjAppController::getCartTotal($this->default_product, $this->default_order, $this->option_arr);
			$data = array();
			$data['status'] = $this->option_arr['o_booking_status'];			
			$data['rental_days']   = $opts['rental_days'];
			$data['rental_hours']   = $opts['rental_hours'];
			$data['price_per_hour']   = $opts['price_per_hour'];
			$data['price_per_day']   = $opts['price_per_day'];
			$data['price_per_hour']   = $opts['price_per_hour'];
			$data['price_per_day_detail']   = $opts['price_per_day_detail'];
			$data['price_per_hour_detail']   = $opts['price_per_hour_detail'];
			$data['car_rental_fee']   = $opts['car_rental_fee'];
			$data['extra_price']   = $opts['extra_price'];
			$data['insurance']   = $opts['insurance'];
			$data['sub_total']   = $opts['sub_total'];
			$data['tax']   = $opts['tax'];
			$data['total_price']   = $opts['total_price'];
			$data['required_deposit']   = $opts['required_deposit'];
			$data['security_deposit']   = $opts['security_deposit'];
			
			$data['from'] = $_SESSION[$this->default_product][$this->default_order]['date_from'] . " " . $_SESSION[$this->default_product][$this->default_order]['hour_from']. ":" .$_SESSION[$this->default_product][$this->default_order]['minutes_from'].":00";
			$data['to'] = $_SESSION[$this->default_product][$this->default_order]['date_to'] . " " . $_SESSION[$this->default_product][$this->default_order]['hour_to']. ":" .$_SESSION[$this->default_product][$this->default_order]['minutes_to'].":00";
			$data['uuid'] = time();
			$data['booking_id'] = $this->getBookingID();
			$data['ip'] = pjUtil::getClientIp();
			$data['locale_id'] = $this->getLocaleId();
			
			if (isset($_SESSION[$this->default_product][$this->default_order]['same_location']))
			{
				$data['return_id'] = $_SESSION[$this->default_product][$this->default_order]['pickup_id'];
			}
			
			$payment = 'none';
			if ($this->_post->check('payment_method'))
			{
				$payment = $this->_post->toString('payment_method');
			}
			
			
			$pjBookingModel = pjBookingModel::factory();
			$pjCarTypeModel = pjCarTypeModel::factory();
			
			$current_datetime = date('Y-m-d H:i:s', time() - ($this->option_arr['o_booking_pending'] * 3600));
			
			if (isset($_SESSION[$this->default_product][$this->default_order]['car_id']))
			{
				$data['car_id'] = $_SESSION[$this->default_product][$this->default_order]['car_id'];
			}			
			$data = array_merge($post, $_SESSION[$this->default_product][$this->default_order],$data);
			$response = $this->doubleCheckData($data);
			if($response['status'] == 'ERR')
			{
			    pjAppController::jsonResponse($response);
			}
			
			$booking_id = $pjBookingModel
							->setAttributes($data)
							->insert()
							->getInsertId();
			
			if ($booking_id !== false && (int) $booking_id > 0)
			{
				$pjBookingExtraModel = pjBookingExtraModel::factory();
				
				if (isset($_SESSION[$this->default_product][$this->default_order]) && isset($_SESSION[$this->default_product][$this->default_order]['extras']))
				{
					$be = array();
					$be['booking_id'] = $booking_id;
					
					foreach ($_SESSION[$this->default_product][$this->default_order]['extras'] as $extra_id => $be_arr)
					{
						if(is_numeric($extra_id)){
							$be['extra_id'] = $extra_id;
							$be['price'] = $be_arr['price'];
							$be['quantity'] = $be_arr['extra_quantity'];
							$pjBookingExtraModel->setAttributes($be)->insert();
						}
					}
				}
				
				$booking_arr = $pjBookingModel->select(sprintf("t1.*, t2.content as type, t3.content as pickup_location , t4.content as return_location, AES_DECRYPT(t1.cc_num, '%s') AS `cc_num`, AES_DECRYPT(t1.cc_exp, '%s') AS `cc_exp`, AES_DECRYPT(t1.cc_code, '%s') AS `cc_code`", PJ_SALT, PJ_SALT, PJ_SALT))
											  ->join('pjMultiLang', "t2.foreign_id = t1.type_id AND t2.model = 'pjType' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
											  ->join('pjMultiLang', "t3.foreign_id = t1.pickup_id AND t3.model = 'pjLocation' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
											  ->join('pjMultiLang', "t4.foreign_id = t1.return_id AND t4.model = 'pjLocation' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'name'", 'left')
											  ->find($booking_id)->getData();
				
				if (count($booking_arr) > 0)
				{
					$extra_arr = $pjBookingExtraModel->select("t1.*, t2.content as name, t3.price")
													 ->join('pjMultiLang', "t2.foreign_id = t1.extra_id AND t2.model = 'pjExtra' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
													 ->join('pjExtra', "t3.id = t1.extra_id")
													 ->where('t1.booking_id',$booking_arr['id'])
													 ->findAll()->getData();
					$booking_arr['extra_arr'] = $extra_arr;
				}
				
				$pdata = array();
				$pdata['booking_id'] = $booking_arr['id'];
				$pdata['payment_method'] = $payment;
				$pdata['payment_type'] = 'online';
				$pdata['amount'] = $booking_arr['required_deposit'];
				$pdata['status'] = 'notpaid';
				pjBookingPaymentModel::factory()->setAttributes($pdata)->insert();
				
				pjFront::pjActionConfirmSend($this->option_arr, $booking_arr, PJ_SALT, 'confirmation');
				
				$_SESSION[$this->default_product][$this->default_order] = array();
				unset($_SESSION[$this->default_product][$this->default_order]);
				
				$_SESSION[$this->defaultCaptcha] = NULL;
				unset($_SESSION[$this->defaultCaptcha]);
				
				$json = array('code' => 200, 'text' => '', 'booking_id' => $booking_id, 'payment' => $payment);
			} else {
				$json = array('code' => 100, 'text' => '');
			}
			pjAppController::jsonResponse($json);
		}
	}
	
	public function pjActionGetLocations()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$location_arr = pjLocationModel::factory()->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjLocation' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left')
					->where('status', 'T')->orderBy('name ASC')->findAll()->getData();
			foreach ($location_arr as $k => $val) {
				if (!empty($val['thumb'])) {
					$location_arr[$k]['thumb'] = PJ_INSTALL_URL.$val['thumb'];
				}
			}
			pjAppController::jsonResponse($location_arr);
		}
	}
	
	public function pjActionGetTerms()
	{
		$this->setAjax(true);
		if ($this->isXHR())
		{
			$term_arr = pjMultiLangModel::factory()->select('t1.content  ')
												  ->where('model', 'pjOption')
												  ->where('field', 'o_terms')
												  ->where('locale', $this->getLocaleId())
												  ->findAll()->getData();
			$this->set('term_arr',$term_arr) ;
		}
	}
	
	public function pjActionSetLocale()
	{
		$this->setAjax(true);
		if ($this->isXHR())
		{
			$get = $this->_get->raw();
			$locale = $this->_get->check('locale') ? $this->_get->toInt('locale') : 0;
			$_SESSION[$this->defaultLocale] = (int) $locale;
			
			$this->loadSetFields(true);
			
			$months = __('months', true);
			ksort($months);
			
			$option_arr = array(
			    'folder' => PJ_INSTALL_URL,
			    'session_id' => $this->_get->check('session_id') ? $this->_get->toString('session_id') : '',
				'validation' => array(
					'error_dates' => str_replace("{HOURS}", $this->option_arr['o_min_hour'], __('front_1_v_err_dates', true, false)),
					'error_title' => __('front_4_v_err_title', true),
					'error_email' => __('front_4_v_err_email', true),
					'error_length' => str_replace("{DAYS}", $this->option_arr['o_min_hour'], __('front_1_v_err_length', true, false))
				),
				'booking_periods' => pjAppController::jsonEncode($this->option_arr['o_booking_periods']),
				'min_hour' => $this->option_arr['o_booking_periods'] == 'perday' ? ($this->option_arr['o_min_hour'] * 24) : $this->option_arr['o_min_hour'],
				'message_1' => __('front_msg_1', true),
				'message_2' => __('front_msg_2', true),
				'message_3' => __('front_msg_3', true),
				'message_4' => __('front_msg_4', true),
				'location_email' => __('front_location_email', true),
				'location_phone' => __('front_location_phone', true),
				'dateFormat' => $this->option_arr['o_date_format'],
				'startDay' => $this->option_arr['o_week_start'],
				'dayNames' => array_values(__('day_names', true)),
				'monthNamesFull' => array_values($months),
				'closeButton' => __('front_1_close', true),
				'pjLang' => isset($get['pjLang']) && (int) $get['pjLang'] > 0 ? $get['pjLang'] : 0,
				'momentDateFormat' => pjUtil::toMomemtJS($this->option_arr['o_date_format']),
				'time_format' => $this->option_arr['o_time_period'] == '12hours' ? 'LT' : "HH:mm",
				'google_api_key' => @$this->option_arr['o_google_maps_api_key']
			);
			
			pjAppController::jsonResponse($option_arr);
		}
	}
	
	public function pjActionConfirm()
	{
	    $this->setAjax(true);
	    
	    if (pjObject::getPlugin('pjPayments') === NULL)
	    {
	        $this->log('pjPayments plugin not installed');
	        exit;
	    }
	    
	    $pjPayments = new pjPayments();
	    $post = $this->_post->raw();
	    $get = $this->_get->raw();
	    $request = array();
	    if(isset($get['payment_method']))
	    {
	        $request = $get;
	    }
	    if(isset($post['payment_method']))
	    {
	        $request = $post;
	    }
	    if($pjPlugin = $pjPayments->getPaymentPlugin($request))
	    {
	        if($uuid = $this->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionGetCustom', 'params' => $request), array('return')))
	        {
	            $pjBookingModel= pjBookingModel::factory();
	           	
	            $booking_arr = $pjBookingModel->select(sprintf("t1.*, t2.content as type, t3.content as pickup_location , t4.content as return_location, AES_DECRYPT(t1.cc_num, '%s') AS `cc_num`, AES_DECRYPT(t1.cc_exp, '%s') AS `cc_exp`, AES_DECRYPT(t1.cc_code, '%s') AS `cc_code`", PJ_SALT, PJ_SALT, PJ_SALT))
									->join('pjMultiLang', "t2.foreign_id = t1.type_id AND t2.model = 'pjType' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
									->join('pjMultiLang', "t3.foreign_id = t1.pickup_id AND t3.model = 'pjLocation' AND t3.locale = '".$this->getLocaleId()."' AND t3.field = 'name'", 'left')
									->join('pjMultiLang', "t4.foreign_id = t1.return_id AND t4.model = 'pjLocation' AND t4.locale = '".$this->getLocaleId()."' AND t4.field = 'name'", 'left')
									->where('uuid', $uuid)
									->limit(1)
									->findAll()->getDataIndex(0);
				if (!empty($booking_arr))
				{
					$pjBookingExtraModel = pjBookingExtraModel::factory();
					$extra_arr = $pjBookingExtraModel->select("t1.*, t2.content as name, t3.price")
													 ->join('pjMultiLang', "t2.foreign_id = t1.extra_id AND t2.model = 'pjExtra' AND t2.locale = '".$this->getLocaleId()."' AND t2.field = 'name'", 'left')
													 ->join('pjExtra', "t3.id = t1.extra_id")
													 ->where('t1.booking_id',$booking_arr['id'])
													 ->findAll()->getData();
					$booking_arr['extra_arr'] = $extra_arr;
						
				    $params = array(
				        'request'		=> $request,
				        'payment_method' => $request['payment_method'],
				        'foreign_id'	 => $this->getForeignId(),
				        'amount'		 => $booking_arr['required_deposit'],
				        'txn_id'		 => $booking_arr['txn_id'],
				        'order_id'	   => $booking_arr['id'],
				    	'uuid'	   => $booking_arr['uuid'],
				        'cancel_hash'	=> sha1($booking_arr['uuid'].strtotime($booking_arr['created']).PJ_SALT),
				        'key'			=> md5($this->option_arr['private_key'] . PJ_SALT)
				    );
				    $response = $this->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionConfirm', 'params' => $params), array('return'));
				    if($response['status'] == 'OK')
				    {
				        $booking_id = $booking_arr['booking_id'];
				        $this->log("Payments | {$pjPlugin} plugin<br>The booking was confirmed. Booking ID: {$booking_id} Auto increment ID: {$booking_arr['id']}");
				        
				        $pjBookingModel->reset()->setAttributes(array('id' => $booking_arr['id']))->modify(array(
							'status' => $this->option_arr['o_payment_status'],
							'processed_on' => ':NOW()'
						));
						$pjBookingPaymentModel = pjBookingPaymentModel::factory();
						$bp_arr = $pjBookingPaymentModel->where('t1.booking_id', $booking_arr['id'])->where('t1.payment_type', 'online')->limit(1)->findAll()->getData();
						if(count($bp_arr) == 1)
						{
							$pjBookingPaymentModel->reset()->setAttributes(array('id' => $bp_arr[0]['id']))->modify(array('status' => 'paid'));
						}						
						pjFront::pjActionConfirmSend($this->option_arr, $booking_arr, PJ_SALT, 'payment');
				        echo $this->option_arr['o_thankyou_page'];
				        exit;
				    }elseif($response['status'] == 'CANCEL'){
				        $this->log("Payments | {$pjPlugin} plugin<br>Payment was cancelled. UUID: {$uuid}");
				        
				        $pjBookingModel->reset()->set('id', $booking_arr['id'])->modify(array('status' => 'cancelled', 'processed_on' => ':NOW()'));
				        pjFront::pjActionConfirmSend($this->option_arr, $booking_arr, PJ_SALT, 'cancel');
				        if(isset($response['return_url']) && !empty($response['return_url']))
				        {
				            echo $response['return_url'];
				        }else{
				            echo $this->option_arr['o_cancel_booking_page'];
				        }
				        exit;
				    }else{
				        $this->log("Payments | {$pjPlugin} plugin<br>Order confirmation was failed. UUID: {$uuid}");
				    }
				    
				    if(isset($response['redirect']) && $response['redirect'] == true)
				    {
				        echo $this->option_arr['o_thankyou_page'];
				        exit;
				    }
				}else{
				    $this->log("Payments | {$pjPlugin} plugin<br>Booking with UUID {$uuid} not found.");
				}
				echo $this->option_arr['o_thankyou_page'];
				exit;
	        }
	    }
	    echo $this->option_arr['o_thankyou_page'];
	    exit;
	}
	
	public function pjActionConfirmSend($option_arr, $booking_arr, $salt, $opt)
	{
		$pjMultiLangModel = pjMultiLangModel::factory();
	    $pjNotificationModel = pjNotificationModel::factory();

	    $Email = self::getMailer($option_arr);
		$locale_id = isset($booking_arr['locale_id']) && (int) $booking_arr['locale_id'] > 0 ? (int) $booking_arr['locale_id'] : 1;
		$booking_arr['calendar_id'] = $this->getForeignId();
		$tokens = pjAppController::getTokens($booking_arr, $option_arr, $salt, $locale_id);
	
		$admin_email = $this->getAdminEmail();
		$admin_phone = $this->getAdminPhone();
		
		$pickup_email = null;
		$dropoff_email = null;
		if(isset($booking_arr['pickup_id']))
		{
			$pickup_arr = pjLocationModel::factory()->find($booking_arr['pickup_id'])->getData();
			if($pickup_arr['notify_email'] == 'T')
			{
				$pickup_email = $pickup_arr['email'];
			}
		}
		if(isset($booking_arr['return_id']))
		{
			$return_arr = pjLocationModel::factory()->find($booking_arr['return_id'])->getData();
			if($return_arr['notify_email'] == 'T')
			{
				$dropoff_email = $return_arr['email'];
			}
		}
		
		$notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', $opt)->findAll()->getDataIndex(0);
	    if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	    {
	        $resp = pjFront::pjActionGetSubjectMessage($notification, $locale_id, $booking_arr['calendar_id']);
	        $lang_message = $resp['lang_message'];
	        $lang_subject = $resp['lang_subject'];
	        if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($lang_subject[0]['content']))
	        {
	            $subject = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
	            $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	            $Email
	            ->setTo($booking_arr['c_email'])
	            ->setSubject(stripslashes($subject))
	            ->send(stripslashes($message));
	            
	        	if($pickup_email != null)
				{
					 $Email
		            ->setTo($pickup_email)
		            ->setSubject(stripslashes($subject))
		            ->send(stripslashes($message));
				}
				if($dropoff_email != null)
				{
					$Email
		            ->setTo($dropoff_email)
		            ->setSubject(stripslashes($subject))
		            ->send(stripslashes($message));
				}
	        }
	    }
	    
		$notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'email')->where('variant', $opt)->findAll()->getDataIndex(0);
	    if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	    {
	        $resp = pjFront::pjActionGetSubjectMessage($notification, $locale_id, $booking_arr['calendar_id']);
	        $lang_message = $resp['lang_message'];
	        $lang_subject = $resp['lang_subject'];
	        if (count($lang_message) === 1 && count($lang_subject) === 1 && !empty($lang_subject[0]['content']))
	        {
	            $subject = str_replace($tokens['search'], $tokens['replace'], $lang_subject[0]['content']);
	            $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	            
	            $Email
	            ->setTo($admin_email)
	            ->setSubject(stripslashes($subject))
	            ->send(stripslashes($message));
	        }
	    }
		
		/*SMS sent to admin*/
	    if(!empty($admin_phone))
	    {
	        $notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'sms')->where('variant', $opt)->findAll()->getDataIndex(0);
	        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
	        {
	        	$resp = pjFront::pjActionGetSmsMessage($notification, $locale_id, $booking_arr['calendar_id']);
			    $lang_message = $resp['lang_message'];
	            if (count($lang_message) === 1)
	            {
	                $message = str_replace($tokens['search'], $tokens['replace'], $lang_message[0]['content']);
	                $params = array(
	                    'text' => stripslashes($message),
	                    'type' => 'unicode',
	                    'key' => md5($option_arr['private_key'] . PJ_SALT)
	                );
	                $params['number'] = $admin_phone;
	                pjBaseSms::init($params)->pjActionSend();
	            }
	        }
	    }
	}
	
	public function pjActionCancel()
	{
		$this->setLayout('pjActionEmpty');
		
		$pjBookingModel = pjBookingModel::factory();
		
		if ($this->_post->check('booking_cancel'))
		{
			$booking_arr = $pjBookingModel
			->select(sprintf("t1.*, t2.content as type, t3.content as pickup_location , t4.content as return_location, AES_DECRYPT(t1.cc_num, '%s') AS `cc_num`, AES_DECRYPT(t1.cc_exp, '%s') AS `cc_exp`, AES_DECRYPT(t1.cc_code, '%s') AS `cc_code`", PJ_SALT, PJ_SALT, PJ_SALT))
            ->join('pjMultiLang', "t2.foreign_id = t1.type_id AND t2.model = 'pjType' AND t2.locale = t1.locale_id AND t2.field = 'name'", 'left')
            ->join('pjMultiLang', "t3.foreign_id = t1.pickup_id AND t3.model = 'pjLocation' AND t3.locale = t1.locale_id AND t3.field = 'name'", 'left')
            ->join('pjMultiLang', "t4.foreign_id = t1.return_id AND t4.model = 'pjLocation' AND t4.locale = t1.locale_id AND t4.field = 'name'", 'left')
            ->find($this->_post->toInt('id'))->getData();
			
			
			if (count($booking_arr) > 0)
			{
				$pjBookingModel->setAttributes(array('id' => $this->_post->toInt('id')))->modify(array(
					'status' => 'cancelled'
				));
				
				$pjBookingExtraModel = pjBookingExtraModel::factory();
				$extra_arr = $pjBookingExtraModel
				->select("t1.*, t2.content as name, t3.price")
				->join('pjMultiLang', "t2.foreign_id = t1.extra_id AND t2.model = 'pjExtra' AND t2.locale = '".$booking_arr['locale_id']."' AND t2.field = 'name'", 'left')
                ->join('pjExtra', "t3.id = t1.extra_id")
                ->where('t1.booking_id',$booking_arr['id'])
                ->findAll()->getData();
				$booking_arr['extra_arr'] = $extra_arr;
									  
				pjFront::pjActionConfirmSend($this->option_arr, $booking_arr, PJ_SALT, 'cancel');
				
				pjUtil::redirect($this->option_arr['o_cancel_booking_page']);
			}
		} else {
			if ($this->_get->check('hash') && $this->_get->check('id'))
			{
				$booking_arr = $pjBookingModel
				->select('t1.*, t2.content as type, t3.content as pickup_location , t4.content as return_location , t6.content as country_title ')
                ->join('pjMultiLang', "t2.foreign_id = t1.type_id AND t2.model = 'pjType' AND t2.locale = t1.locale_id AND t2.field = 'name'", 'left')
                ->join('pjMultiLang', "t3.foreign_id = t1.pickup_id AND t3.model = 'pjLocation' AND t3.locale = t1.locale_id AND t3.field = 'name'", 'left')
                ->join('pjMultiLang', "t4.foreign_id = t1.return_id AND t4.model = 'pjLocation' AND t4.locale = t1.locale_id AND t4.field = 'name'", 'left')
                ->join('pjType', "t5.id = t1.type_id ")
                ->join('pjMultiLang', "t6.foreign_id = t1.c_country AND t6.model = 'pjBaseCountry' AND t6.locale = t1.locale_id AND t6.field = 'name'", 'left')
                ->find($this->_get->toInt('id'))->getData();
				if (count($booking_arr) == 0)
				{
					$this->tpl['status'] = 2;
				} else {
					if ($booking_arr['status'] == 'cancelled')
					{
						$this->tpl['status'] = 4;
					}else if ($booking_arr['status'] == 'collected'){
						$this->tpl['status'] = 5;
					}else if ($booking_arr['status'] == 'completed'){
						$this->tpl['status'] = 6;
					} else {
						$hash = sha1($booking_arr['id'] . $booking_arr['created'] . PJ_SALT);
						
						if ($this->_get->toString('hash') != $hash)
						{
							$this->tpl['status'] = 3;
						} else {
						    if((int) $booking_arr['locale_id'] > 0)
						    {
						        $locale = pjLocaleModel::factory()->find($booking_arr['locale_id'])->getData();
						        if(!empty($locale))
						        {
						            $this->setLocaleId($locale['id']);
						            $this->loadSetFields(true);
						        }
						    }
							$extra_arr = pjBookingExtraModel::factory()
							->select("t1.*, t2.content as name, t3.price")
							->join('pjMultiLang', "t2.foreign_id = t1.extra_id AND t2.model = 'pjExtra' AND t2.locale = '".$booking_arr['locale_id']."' AND t2.field = 'name'", 'left')
                            ->join('pjExtra', "t3.id = t1.extra_id")
                            ->where('t1.booking_id',$booking_arr['id'])
                            ->findAll()->getData();
							$booking_arr['extra_arr'] = $extra_arr;
							$this->tpl['arr'] = $booking_arr;
						}
					}
				}
			} elseif (!$this->_get->check('err')) {
				$this->tpl['status'] = 1;
			}
		}
		$this->appendCss('index.php?controller=pjFrontEnd&action=pjActionLoadCss', PJ_INSTALL_URL, true);
	}
	
	function pjActionGetLatLng()
	{
		$_address = $this->_get->toString('address');
		$_address = preg_replace('/\s+/', '+', $_address);
	
		$google_api_key = isset($option_arr['o_google_map_api']) ? (!empty($option_arr['o_google_map_api']) ? '&key=' . $option_arr['o_google_map_api'] : "") : "";
		$gfile = "https://maps.googleapis.com/maps/api/geocode/json?address=$_address" . $google_api_key;
	
		$Http = new pjHttp();
		$response = $Http->request($gfile)->getResponse();
	
		$geoObj = pjAppController::jsonDecode($response);
	
		$data = array();
		$geoArr = (array) $geoObj;
		if ($geoArr['status'] == 'OK')
		{
			$geoArr['results'][0] = (array) $geoArr['results'][0];
			$geoArr['results'][0]['geometry'] = (array) $geoArr['results'][0]['geometry'];
			$geoArr['results'][0]['geometry']['location'] = (array) $geoArr['results'][0]['geometry']['location'];
				
			$data['lat'] = $geoArr['results'][0]['geometry']['location']['lat'];
			$data['lng'] = $geoArr['results'][0]['geometry']['location']['lng'];
		} else {
			$data['lat'] = NULL;
			$data['lng'] = NULL;
		}
	
		if (isset($data['lat']) && !is_array($data['lat']))
		{
			$data['code'] = 200;
		}else{
			$data['code'] = 100;
		}
		pjAppController::jsonResponse($data);
	}
	
	public function pjActionCheckWTime()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$date_from = pjDateTime::formatDate($this->_post->toString('date_from'), $this->option_arr['o_date_format']);
			$date_to = pjDateTime::formatDate($this->_post->toString('date_to'), $this->option_arr['o_date_format']);
				
			$from_ts = strtotime($date_from . " " . $this->_post->toString('hour_from').":".$this->_post->toString('minutes_from'));
			$to_ts = strtotime($date_to . " " . $this->_post->toString('hour_to').":".$this->_post->toString('minutes_to'));

			if($to_ts < $from_ts)
			{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 109, 'text' => __('front_invalid_period', true)));
			}
			
			$wt_msg = __('wtime_arr', true);
			$min_hour_msg = str_replace("{HOURS}", $this->option_arr['o_min_hour'], __('front_1_v_err_dates', true, false));
			$min_day_msg = str_replace("{DAYS}", $this->option_arr['o_min_hour'], __('front_1_v_err_length', true, false));
			
			$seconds = abs($from_ts - $to_ts);
			$rental_days = floor($seconds / 86400);
			$rental_hours = ceil($seconds / 3600);
			$hours = intval($rental_hours - ($rental_days * 24));
			
			if($this->option_arr['o_booking_periods'] == 'perday')
			{
				$min_day = $this->option_arr['o_min_hour'];
				if($rental_days < $min_day)
				{
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 107, 'text' => $min_day_msg));
				}
			}else{
				$min_hour = $this->option_arr['o_min_hour'];
				if($rental_days == 0 && $hours < $min_hour)
				{
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 108, 'text' => $min_hour_msg));
				}
			}
			
			$pickup_id = $this->_post->toInt('pickup_id');
			if($this->_post->check('same_location'))
			{
				$return_id = $pickup_id;
			}else{
				$return_id = $this->_post->toInt('return_id');
			}
				
			$pjDateModel = pjDateModel::factory();
			$pjWorkingTimeModel = pjWorkingTimeModel::factory();
			$is_dayoff = true;
			$pickup_date = $pjDateModel->getDailyWorkingTime($pickup_id, $date_from);
			if($pickup_date !== false)
			{
				$is_dayoff = false;
				if($pickup_date['is_dayoff'] == 'T')
				{
				    pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => $wt_msg[7]));
				}else if($from_ts < $pickup_date['start_ts']){
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => $wt_msg[7]));
				}else if($from_ts > $pickup_date['end_ts']){
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => $wt_msg[7]));
				}elseif ($from_ts >= $pickup_date['lunch_start_ts'] && $from_ts < $pickup_date['lunch_end_ts']){
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => $wt_msg[7]));
				}
			}else{
				$wt_arr = $pjWorkingTimeModel->getWorkingTime($pickup_id);
				if(!empty($wt_arr))
				{
					$is_dayoff = false;
					$pickup_weekday = strtolower(date('l', $from_ts));
					if($wt_arr[$pickup_weekday . '_dayoff'] == 'T')
					{
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => $wt_msg[7]));
					}else if($from_ts < strtotime($date_from . ' ' . $wt_arr[$pickup_weekday . '_from'])){
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => $wt_msg[7]));
					}else if($from_ts > strtotime($date_from . ' ' . $wt_arr[$pickup_weekday . '_to'])){
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => $wt_msg[7]));
					}else if($from_ts >= strtotime($date_from . ' ' . $wt_arr[$pickup_weekday . '_lunch_from']) && $from_ts < strtotime($date_from . ' ' . $wt_arr[$pickup_weekday . '_lunch_to'])){
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => $wt_msg[7]));
					}
				}
			}
			if ($is_dayoff) {
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => $wt_msg[7]));
			}
				
			$is_dayoff = true;
			$return_date = $pjDateModel->reset()->getDailyWorkingTime($return_id, $date_to);
			
			if(!empty($return_date))
			{
				$is_dayoff = false;
				if($return_date['is_dayoff'] == 'T')
				{
				    pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => $wt_msg[7]));
				}else if($to_ts < $return_date['start_ts']){
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => $wt_msg[7]));
				}else if($to_ts > $return_date['end_ts']){
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => $wt_msg[7]));
				}elseif ($to_ts >= $return_date['lunch_start_ts'] && $to_ts < $return_date['lunch_end_ts']){
					pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => $wt_msg[7]));
				}
			}else{
				$wt_arr = $pjWorkingTimeModel->reset()->getWorkingTime($return_id);
				if(!empty($wt_arr))
				{
					$is_dayoff = false;
					$return_weekday = strtolower(date('l', $to_ts));
					if($wt_arr[$return_weekday . '_dayoff'] == 'T')
					{
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => $wt_msg[7]));
					}else if($to_ts < strtotime($date_to . ' ' . $wt_arr[$return_weekday . '_from'])){
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => $wt_msg[7]));
					}else if($to_ts > strtotime($date_to . ' ' . $wt_arr[$return_weekday . '_to'])){
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => $wt_msg[7]));
					}else if($to_ts >= strtotime($date_to . ' ' . $wt_arr[$return_weekday . '_lunch_from']) && $to_ts < strtotime($date_to . ' ' . $wt_arr[$return_weekday . '_lunch_to'])){
						pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => $wt_msg[7]));
					}
				}
			}
			if ($is_dayoff) {
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => $wt_msg[7]));
			}
			pjAppController::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
		exit;
	}
	
	public static function pjActionGetSubjectMessage($notification, $locale_id, $calendar_id)
	{
	    $field = $notification['variant'] . '_tokens_' . $notification['recipient'];
	    $field = str_replace('confirmation', 'confirm', $field);
	    $pjMultiLangModel = pjMultiLangModel::factory();
	    $lang_message = $pjMultiLangModel
		    ->reset()
		    ->select('t1.*')
		    ->where('t1.foreign_id', $calendar_id)
		    ->where('t1.model','pjOption')
		    ->where('t1.locale', $locale_id)
		    ->where('t1.field', $field)
		    ->limit(0, 1)
		    ->findAll()
		    ->getData();
	    $field = $notification['variant'] . '_subject_' . $notification['recipient'];
	    $field = str_replace('confirmation', 'confirm', $field);
	    $lang_subject = $pjMultiLangModel
		    ->reset()
		    ->select('t1.*')
		    ->where('t1.foreign_id',  $calendar_id)
		    ->where('t1.model','pjOption')
		    ->where('t1.locale', $locale_id)
		    ->where('t1.field', $field)
		    ->limit(0, 1)
		    ->findAll()
		    ->getData();
	    return compact('lang_message', 'lang_subject');
	}
	
	public static function pjActionGetSmsMessage($notification, $locale_id, $calendar_id)
	{
	    $field = $notification['variant'] . '_sms_' . $notification['recipient'];
	    $field = str_replace('confirmation', 'confirm', $field);
	    $pjMultiLangModel = pjMultiLangModel::factory();
	    $lang_message = $pjMultiLangModel
		    ->reset()
		    ->select('t1.*')
		    ->where('t1.foreign_id', $calendar_id)
		    ->where('t1.model','pjOption')
		    ->where('t1.locale', $locale_id)
		    ->where('t1.field', $field)
		    ->limit(0, 1)
		    ->findAll()
		    ->getData();
	    return compact('lang_message');
	}
	
	public function isXHR()
	{
		// CORS
		return parent::isXHR() || isset($_SERVER['HTTP_ORIGIN']);
	}
	protected static function allowCORS()
	{
	    $install_url = parse_url(PJ_INSTALL_URL);
	    if($install_url['scheme'] == 'https'){
	        header('Set-Cookie: '.session_name().'='.session_id().'; SameSite=None; Secure');
	    }
	    $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*';
	    header('P3P: CP="ALL DSP COR CUR ADM TAI OUR IND COM NAV INT"');
	    header("Access-Control-Allow-Origin: $origin");
	    header("Access-Control-Allow-Credentials: true");
	    header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
	    header("Access-Control-Allow-Headers: Origin, X-Requested-With");
	    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS')
	    {
	        exit;
	    }
	}
}
?>