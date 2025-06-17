<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminTypes extends pjAdmin
{
	public function pjActionCreate()
	{
		$this->checkLogin();
		
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminTypes&action=pjActionIndex&err=AT12");
		}
		
		if (self::isPost() && $this->_post->toInt('action_create'))
		{
			$err = 'AT03';

			$data = array();
			$post = $this->_post->raw();
			$data['status'] = $this->_post->check('status') ? 'T' : 'F';
			$id = pjTypeModel::factory(array_merge($data, $post))->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				if (isset($_FILES['thumb_path']))
				{
					if($_FILES['thumb_path']['error'] == 0)
					{
						$size = getimagesize($_FILES['thumb_path']['tmp_name']);
						if($size == true)
						{
							$pjImage = new pjImage();
							$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
							if ($pjImage->load($_FILES['thumb_path']))
							{
								$dst = PJ_UPLOAD_PATH . 'types/' . md5($id . PJ_SALT) . ".jpg";
								$pjImage
								->loadImage()
								->resizeSmart(220, 140)
								->saveImage($dst);
				
								pjTypeModel::factory()->reset()->set('id', $id)->modify(array('thumb_path' => $dst));
							}
						}else{
							$err = 'AT14';
						}
					}else if($_FILES['thumb_path']['error'] != 4){
						$err = 'AT13';
					}
				}
				
				if ($this->_post->toArray('extra_id') && $this->_post->toArray('extra_id') != '')
				{
					$pjTypeExtraModel = pjTypeExtraModel::factory()->setBatchFields(array('extra_id', 'type_id'));
					foreach ($this->_post->toArray('extra_id') as $extra_id)
					{
						$pjTypeExtraModel->addBatchRow(array($extra_id, $id));
					}
					$pjTypeExtraModel->insertBatch();
				}
				
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $id, 'pjType');
				}
			} else {
				$err = 'AT04';
			}
			if ($err == 'AT04' || !pjAuth::factory('pjAdminTypes', 'pjActionUpdate')->hasAccess()) {
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminTypes&action=pjActionIndex&err=$err");
			} else {
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminTypes&action=pjActionUpdate&id=$id&tab=1&err=$err");
			}
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
			
			$this->set('extra_arr', pjExtraModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('additional-methods.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminTypes.js');
		}
	}
	
	public function pjActionDeleteImage()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
	
		if ($this->_post->check('id') && $this->_post->toInt('id'))
		{
			$pjTypeModel = pjTypeModel::factory();
			$arr = $pjTypeModel->find($this->_post->toInt('id'))->getData();
			if (!empty($arr))
			{
				$pjTypeModel->reset()->set('id', $arr['id'])->modify(array('thumb_path' => ':NULL'));
	
				@clearstatcache();
				if (!empty($arr['thumb_path']) && is_file($arr['thumb_path']))
				{
					@unlink($arr['thumb_path']);
				}
	
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	}
	
	public function pjActionDelete()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}

		if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$pjTypeModel = pjTypeModel::factory();
			$arr = $pjTypeModel->find($this->_get->toInt('id'))->getData();
			if (!empty($arr) && $pjTypeModel->setAttributes(array('id' => $arr['id']))->erase()->getAffectedRows() == 1)
			{
				pjMultiLangModel::factory()->where('model', 'pjType')->where('foreign_id', $this->_get->toInt('id'))->eraseAll();
				pjTypeExtraModel::factory()->where('type_id', $this->_get->toInt('id'))->eraseAll();
				pjPriceModel::factory()->where('type_id', $this->_get->toInt('id'))->eraseAll();
				if (!empty($arr['thumb_path']) && is_file($arr['thumb_path']))
				{
					@unlink($arr['thumb_path']);
				}
				
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service has been deleted.'));
			} else {
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Service has not been deleted.'));
			}
		}
		
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing, empty or invalid parameters.'));
	}
	
	public function pjActionDeleteBulk()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
		
		$record = $this->_post->toArray('record');
		if (count($record))
		{
			$pjTypeModel = pjTypeModel::factory();
			$arr = $pjTypeModel->whereIn('id', $record)->findAll()->getData();
			
			$pjTypeModel->reset()->whereIn('id', $record)->eraseAll();
			pjMultiLangModel::factory()->where('model', 'pjType')->whereIn('foreign_id', $record)->eraseAll();
			pjTypeExtraModel::factory()->whereIn('type_id', $record)->eraseAll();
			pjPriceModel::factory()->whereIn('type_id', $record)->eraseAll();
			foreach ($arr as $type)
			{
				if (!empty($type['thumb_path']) && is_file($type['thumb_path']))
				{
					@unlink($type['thumb_path']);
				}
			}
			
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service(s) has been deleted.'));
		}
		exit;
	}
	
	public function pjActionGet()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		$pjCarTypeModel = pjCarTypeModel::factory();
		$pjTypeModel = pjTypeModel::factory()
			->join('pjMultiLang', "t2.model='pjType' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer');
		
		$get = $this->_get->raw();
		if ($q = $this->_get->toString('q'))
		{
			$pjTypeModel->where('t2.content LIKE', "%$q%");
		}

		if ($this->_get->check('status') && $get['status'] != '' && in_array($this->_get->toString('status'), array('T','F'))) {
			$pjTypeModel->where('t1.status', $this->_get->toString('status'));
		}

		$column = 'type';
		$direction = 'ASC';
		if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjTypeModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjTypeModel->select(sprintf('t1.*,  t2.content  as type , UCASE(MID(t1.transmission,1,1)) as transmission,
			(SELECT COUNT(*) FROM `%s` WHERE `type_id` = `t1`.`id` LIMIT 1) AS `cnt`', $pjCarTypeModel->getTable()))
			->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			
		foreach ($data as $k => $v)
		{
			$data[$k]['type'] = pjSanitize::clean($v['type']);
		}
			
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionIndex()
	{
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminTypes.js');
		
		$this->set('has_update', pjAuth::factory('pjAdminTypes', 'pjActionUpdate')->hasAccess());
		$this->set('has_create', pjAuth::factory('pjAdminTypes', 'pjActionCreate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminTypes', 'pjActionDelete')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminTypes', 'pjActionDeleteBulk')->hasAccess());
	}
	
	public function pjActionSave()
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
		if (!pjAuth::factory('pjAdminTypes', 'pjActionUpdate')->hasAccess())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
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
		
		$pjTypeModel = pjTypeModel::factory();
		if (!in_array($params['column'], $pjTypeModel->getI18n()))
		{
			$pjTypeModel->set('id', $params['id'])->modify(array($params['column'] => $params['value']));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($params['column'] => $params['value'])), $params['id'], 'pjType', 'data');
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200));
	}
	
	public function pjActionUpdate()
	{
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminTypes&action=pjActionIndex&err=AT15");
		}
		
		if (self::isPost() && $this->_post->toInt('action_update'))
		{
		    
			$err = 'AT01';
			
			$data = array();
			$post = $this->_post->raw();
			$data['status'] = $this->_post->check('status') ? 'T' : 'F';
			if (isset($_FILES['thumb_path']))
			{
				if($_FILES['thumb_path']['error'] == 0)
				{
					$size = getimagesize($_FILES['thumb_path']['tmp_name']);
						
					if($size == true)
					{
						$pjTypeModel = pjTypeModel::factory();
						$arr = $pjTypeModel->find($this->_post->toInt('id'))->getData();
						if (!empty($arr))
						{
							@clearstatcache();
							if (!empty($arr['thumb_path']) && is_file($arr['thumb_path']))
							{
								@unlink($arr['thumb_path']);
							}
						}
							
						$pjImage = new pjImage();
						$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
						if ($pjImage->load($_FILES['thumb_path']))
						{
							$data['thumb_path'] = PJ_UPLOAD_PATH . 'types/' . md5($this->_post->toInt('id') . PJ_SALT) . ".jpg";
							$pjImage
							->loadImage()
							->resizeSmart(220, 140)
							->saveImage($data['thumb_path']);
						}
					}else{
						$err = 'AT17';
					}
				}else if($_FILES['thumb_path']['error'] != 4){
					$err = 'AT16';
				}
			}
			
			pjTypeModel::factory()->set('id', $this->_post->toString('id'))->modify(array_merge($post, $data));
			
			$i18n_arr = $this->_post->toI18n('i18n');
			if (!empty($i18n_arr))
			{
				pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $this->_post->toInt('id'), 'pjType');
			}
			
			$pjTypeExtraModel = pjTypeExtraModel::factory();
			$pjTypeExtraModel->where('type_id', $this->_post->toInt('id'))->eraseAll();
			if ($this->_post->toArray('extra_id') && $this->_post->toArray('extra_id') != '')
			{
				$pjTypeExtraModel->reset()->setBatchFields(array('extra_id', 'type_id'));
				foreach ($this->_post->toArray('extra_id') as $extra_id)
				{
					$pjTypeExtraModel->addBatchRow(array($extra_id, $this->_post->toString('id')));
				}
				$pjTypeExtraModel->insertBatch();
			}
			$price_id_arr = array();
			$pjPriceModel = pjPriceModel::factory();
			foreach ($post['date_from'] as $index => $date_from)
			{
				if (!empty($date_from) && !empty($post['date_to'][$index]) && !empty($post['from'][$index]) && !empty($post['to'][$index]) && !empty($post['price'][$index]))
				{
					$data = array();
					$data['type_id'] = $this->_post->toInt('id');
					$data['date_from'] = pjDateTime::formatDate($post['date_from'][$index], $this->option_arr['o_date_format']);
					$data['date_to'] = pjDateTime::formatDate($post['date_to'][$index], $this->option_arr['o_date_format']);
					$data['from'] = $post['from'][$index];
					$data['to'] = $post['to'][$index];
					$data['price_per'] = $post['price_per'][$index];
					$data['price'] = $post['price'][$index];
					if (strpos($index, 'cr_') !== false) {
						$pid = $pjPriceModel->reset()->setAttributes($data)->insert()->getInsertId();
						$price_id_arr[] = $pid;
					} else {
						$pjPriceModel->reset()->where('id', $index)->limit(1)->modifyAll($data);
						$price_id_arr[] = $index;
					}
				}
			}
			if(!empty($price_id_arr))
			{
				$pjPriceModel->reset()->where('type_id', $this->_post->toInt('id'))->whereNotIn('id', $price_id_arr)->eraseAll();
			} else {
				$pjPriceModel->reset()->where('type_id', $this->_post->toInt('id'))->eraseAll();
			}
			
			if($err == 'AT01')
			{
				pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminTypes&action=pjActionIndex&err=AT01");
			}else{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminTypes&action=pjActionUpdate&id=".$this->_post->toString('id')."&err=$err");
			}
		} 
		
		if (self::isGet())
		{
			$arr = pjTypeModel::factory()->find($this->_get->toInt('id'))->getData();
			if (empty($arr))
			{
				pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminTypes&action=pjActionIndex&err=AT08");
			}
			$arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjType');
			$this->set('arr', $arr);
			
			$price_arr = pjPriceModel::factory()
				->where('t1.type_id', $arr['id'])
				->orderBy('t1.date_from ASC, t1.date_to ASC, t1.from ASC, t1.to ASC')
				->findAll()
				->getData();
			$this->set('price_arr', $price_arr);
			
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
			
			$this->set('extra_arr', pjExtraModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjExtra' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.status', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			$this->set('te_arr', pjTypeExtraModel::factory()->where('t1.type_id', $arr['id'])->findAll()->getDataPair(null, 'extra_id'));
			
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
				
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
				
			$this->appendCss('datepicker3.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('additional-methods.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminTypes.js');
		}
	}
}
?>