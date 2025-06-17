<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminExtras extends pjAdmin
{
	public function pjActionIndex()
	{
		$this->checkLogin();
		
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
			->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
		
		$lp_arr = array();
		foreach ($locale_arr as $item)
		{
			$lp_arr[$item['id']."_"] = $item['file'];
		}
		$this->set('lp_arr', $locale_arr);
		$this->set('locale_str', pjAppController::jsonEncode($lp_arr));

		$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
		
		$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
		$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
		$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminExtras.js');
	}
	
	public function pjActionGet()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjExtraModel = pjExtraModel::factory()
			->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer');
			
		if ($q = $this->_get->toString('q'))
		{
			$q = str_replace(array('_', '%'), array('\_', '\%'), $pjExtraModel->escapeStr($q));
			$pjExtraModel->where('t2.content LIKE "%'.$q.'%"');
		}
		if ($this->_get->toString('status') && in_array($this->_get->toString('status'), array('T', 'F')))
		{
			$pjExtraModel->where('t1.status', $this->_get->toString('status'));
		}
		$column = 'name';
		$direction = 'ASC';
		if ($this->_get->toString('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjExtraModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}
		$data = $pjExtraModel
					->select('t1.*, t2.content AS name')
					->orderBy("$column $direction")
					->limit($rowCount, $offset)
					->findAll()
					->getData();
		$extra_per= __('extra_per', true);
		foreach ($data as $k => $v) {
		    $v['name'] = pjSanitize::clean($v['name']);
		    $v['price'] = pjCurrency::formatPrice($v['price'])." ".$extra_per[$v['per']];
			$data[$k] = $v;
		}	
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionAddExtra()
	{
		$this->setAjax(true);
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		
		if ($this->_post->check('add_extra'))
		{
			$post = $this->_post->raw();
			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			$extra_id = pjExtraModel::factory(array_merge($post, $data))->insert()->getInsertId();
			if ($extra_id !== false && (int) $extra_id > 0)
			{
				if (isset($_FILES['image']))
				{
					if($_FILES['image']['error'] == 0)
					{
						$size = getimagesize($_FILES['image']['tmp_name']);
						if($size == true)
						{
							$pjImage = new pjImage();
							$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
							if ($pjImage->load($_FILES['image']))
							{
								$thumb_path = PJ_UPLOAD_PATH . 'extras/thumbs/' . md5($extra_id . PJ_SALT) . ".jpg";
								$pjImage
									->loadImage()
									->resizeSmart(150, 170)
									->saveImage($thumb_path);
				
								$image_path = PJ_UPLOAD_PATH . 'extras/' . md5($extra_id . PJ_SALT) . ".jpg";
								$pjImage
									->loadImage()
									->saveImage($image_path);
									
								pjExtraModel::factory()->reset()->set('id', $extra_id)->modify(array('thumb_path' => $thumb_path, 'image_path' => $image_path));
							}
						}else{
							
						}
					}else if($_FILES['image']['error'] != 4){
						
					}
				}
				
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $extra_id, 'pjExtra');
				}
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
		}
	}
	
	public function pjActionDelete()
	{
		$this->setAjax(true);
	
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
		}
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isGet() && !$this->_get->check('id') && $this->_get->toInt('id') < 0)
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if (pjExtraModel::factory()->set('id', $this->_get->toInt('id'))->erase()->getAffectedRows() == 1)
		{
			pjMultiLangModel::factory()->where('model', 'pjExtra')->where('foreign_id', $this->_get->toInt('id'))->eraseAll();
			$response = array('status' => 'OK');
		} else {
			$response = array('status' => 'ERR');
		}
		
		self::jsonResponse($response);
	}
	
	public function pjActionDeleteBulk()
	{
		$this->setAjax(true);
	
		if (!pjAuth::factory()->hasAccess())
		{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
		}
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}

		if (!$this->_post->has('record') || !($record = $this->_post->toArray('record')))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid data.'));
		}
		if (pjExtraModel::factory()->whereIn('id', $record)->eraseAll()->getAffectedRows() > 0)
		{
			pjMultiLangModel::factory()->where('model', 'pjExtra')->whereIn('foreign_id', $record)->eraseAll();
			self::jsonResponse(array('status' => 'OK'));
		}
		
		self::jsonResponse(array('status' => 'ERR'));
	}
	
	public function pjActionCreate()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (self::isGet())
		{
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
			->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
				
			$lp_arr = array();
			foreach ($locale_arr as $item)
			{
				$lp_arr[$item['id']."_"] = $item['file'];
			}
			$this->set('lp_arr', $locale_arr);
			$this->set('locale_str', self::jsonEncode($lp_arr));
	
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
		}
	}
	
	public function pjActionUpdate()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}

		if (self::isPost() && $this->_post->check('update_extra'))
		{
			$pjExtraModel = pjExtraModel::factory();
			$arr = $pjExtraModel->find($this->_post->toInt('id'))->getData();
			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			if ($arr) {
				$extra_id = $this->_post->toInt('id');
				$pjExtraModel->reset()->set('id', $extra_id)->modify(array_merge($this->_post->raw(), $data));
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $extra_id, 'pjExtra');
				}
			} else {
				$extra_id = $pjExtraModel->reset()->setAttributes(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $extra_id, 'pjExtra');
				}
			}
			if ($extra_id !== false && (int)$extra_id > 0) {
				if (isset($_FILES['image']))
				{
					if($_FILES['image']['error'] == 0)
					{
						$size = getimagesize($_FILES['image']['tmp_name']);
						if($size == true)
						{
							$pjImage = new pjImage();
							$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
							if ($pjImage->load($_FILES['image']))
							{
								if ($arr) {
									@clearstatcache();
									if (!empty($arr['thumb_path']) && is_file($arr['thumb_path']))
									{
										@unlink($arr['thumb_path']);
									}
									if (!empty($arr['image_path']) && is_file($arr['image_path']))
									{
										@unlink($arr['image_path']);
									}
								}
								
								$thumb_path = PJ_UPLOAD_PATH . 'extras/thumbs/' . md5($extra_id . PJ_SALT) . ".jpg";
								$pjImage
									->loadImage()
									->resizeSmart(150, 170)
									->saveImage($thumb_path);
				
								$image_path = PJ_UPLOAD_PATH . 'extras/' . md5($extra_id . PJ_SALT) . ".jpg";
								$pjImage
									->loadImage()
									->saveImage($image_path);
								$pjExtraModel->reset()->set('id', $extra_id)->modify(array('thumb_path' => $thumb_path, 'image_path' => $image_path));
							}
						}else{
							
						}
					}else if($_FILES['image']['error'] != 4){
						
					}
				}	
			}
			
			self::jsonResponse(array('status' => 'OK'));
		}
		
		if (self::isGet())
		{
			$arr = pjExtraModel::factory()->find($this->_get->toInt('id'))->getData();
			$arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjExtra');
			$this->set('arr', $arr);
			
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
				->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
				->where('t2.file IS NOT NULL')
				->orderBy('t1.sort ASC')->findAll()->getData();
			
			$lp_arr = array();
			foreach ($locale_arr as $item)
			{
				$lp_arr[$item['id']."_"] = $item['file'];
			}
			$this->set('lp_arr', $locale_arr);
			$this->set('locale_str', self::jsonEncode($lp_arr));
	
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
		}
	}
	
	public function pjActionSaveExtra()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'HTTP method not allowed.'));
		}
		
		$params = array(
				'id' => $this->_get->toInt('id'),
				'column' => $this->_post->toString('column'),
				'value' => $this->_post->toString('value'),
		);
		if (!(isset($params['id'], $params['column'], $params['value'])
				&& pjValidation::pjActionNumeric($params['id'])
				&& pjValidation::pjActionNotEmpty($params['column'])))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
		}
		
		$pjExtraModel = pjExtraModel::factory();
		if (!in_array($params['column'], $pjExtraModel->getI18n()))
		{
			$pjExtraModel->where('id', $params['id'])->limit(1)->modifyAll(array($params['column'] => $params['value']));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($params['column'] => $params['value'])), $params['id'], 'pjExtra');
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200));
	}
}
?>