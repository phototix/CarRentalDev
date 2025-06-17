var jQuery = jQuery || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var $frmCreate = $("#frmCreate"),
			validate = ($.fn.validate !== undefined),
			multilang = ($.fn.multilang !== undefined),
			datagrid = ($.fn.datagrid !== undefined);
		
		if (multilang && myLabel.isFlagReady == 1) {
			$(".multilang").multilang({
				langs: pjLocale.langs,
				flagPath: pjLocale.flagPath,
				tooltip: "",
				select: function (event, ui) {
					$("input[name='locale_id']").val(ui.index);					
				}
			});
		}
		
		if ($frmCreate.length > 0 && validate) {
			$frmCreate.validate({
				onkeyup: false,
				submitHandler: function (form) {
					var price = parseFloat($('input[name="price"]').val());
					if(price <= 99999999999999.99)
					{
						var l = Ladda.create( $(form).find(":submit").get(0) );
						l.start();
						
						$.ajaxSetup({async:false});
						var formData = new FormData(form);
						$.ajax({
				            url: "index.php?controller=pjAdminExtras&action=pjActionAddExtra",
				            type: 'post',
				            data: formData,
				            dataType: 'html',
				            async: true,
				            processData: false,
				            contentType: false,
				            success : function(data) {
				            	var content = $grid.datagrid("option", "content");
								$grid.datagrid("load", "index.php?controller=pjAdminExtras&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
								$(form)[0].reset();
								l.stop();
								if (multilang && myLabel.isFlagReady == 1) {
						        	$('.pj-form-langbar-item').first().trigger('click');
								}
				            },
				            error : function(request) {
				            	l.stop();
				            }
				        });
					}else{
						swal({
			    			title: "",
							text: myLabel.prices_invalid_input,
							type: "warning",
							confirmButtonColor: "#DD6B55",
							confirmButtonText: "OK",
							closeOnConfirm: false,
							showLoaderOnConfirm: false
						}, function () {
							swal.close();
						});
					}
					return false;
				}
			});
		}
        
        function formatPrice (str, obj) {
			return obj.price_formated;
		}
		if ($("#grid").length > 0 && datagrid) {
			var buttons = [];
			if (pjGrid.hasAccessUpdate) {
				buttons.push({type: "edit", url: "index.php?controller=pjAdminExtras&action=pjActionUpdate&id={:id}"});
			}
			if (pjGrid.hasAccessDeleteSingle) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminExtras&action=pjActionDelete&id={:id}"});
			}
			var actions = [];
			if (pjGrid.hasAccessDeleteMulti) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminExtras&action=pjActionDeleteBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			var select = false;
			if (actions.length) {
				select = {
					field: "id",
					name: "record[]"
				};
			}
			var $grid = $("#grid").datagrid({
				buttons: buttons,
		          columns: [
							{text: myLabel.extra_title, type: "text", sortable: true, editable: pjGrid.hasAccessUpdate},
							{text: myLabel.extra_price, type: "text", sortable: true, editable: false},
							{text: myLabel.status, type: "toggle", sortable: true, editable: pjGrid.hasAccessUpdate, positiveLabel: myLabel.active, positiveValue: "T", negativeLabel: myLabel.inactive, negativeValue: "F"}
				          ],
				dataUrl: "index.php?controller=pjAdminExtras&action=pjActionGet",
				dataType: "json",
				fields: ['name', 'price', 'status'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminExtras&action=pjActionSaveExtra&id={:id}",
				select: select
			});
		}
		
		
		$(document).on("click", ".btn-all", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(this).addClass("btn-primary active").removeClass("btn-default")
			.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			var content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				status: "",
				q: ""
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminExtras&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
			return false;
		}).on("click", ".btn-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache"),
				obj = {};
			$this.addClass("btn-primary active").removeClass("btn-default")
			.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			obj.status = "";
			obj[$this.data("column")] = $this.data("value");
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminExtras&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
			return false;
		}).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val()
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminExtras&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
			return false;
		}).on("click", ".pj-table-icon-edit", function (e) {
			var $url = $(this).attr("href");
			$.get($url).done(function (data) {
				$(".boxFormExtra").html(data);
				if (multilang && myLabel.isFlagReady == 1) {
		        	$('.pj-form-langbar-item').first().trigger('click');
				}
				
				$("#frmUpdate").validate({
    				onkeyup: false,
    				submitHandler: function (form) {
    					var price = parseFloat($('input[name="price"]').val());
    					if(price <= 99999999999999.99)
    					{
	    					var l = Ladda.create( $(form).find(":submit").get(0) );
	    					l.start();
	    					
	    					$.ajaxSetup({async:false});
							var formData = new FormData(form);
							$.ajax({
					            url: "index.php?controller=pjAdminExtras&action=pjActionUpdate",
					            type: 'post',
					            data: formData,
					            dataType: 'html',
					            async: true,
					            processData: false,
					            contentType: false,
					            success : function(data) {
					            	var content = $grid.datagrid("option", "content");
		    						$grid.datagrid("load", "index.php?controller=pjAdminExtras&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
		    						if(pjGrid.hasAccessCreate == true)
		    						{
		    							$(".pjBtnCancelUpdateExtra").trigger("click");
		    						}else{
		    							$(".boxFormExtra").html("");
		    						}
		    						l.stop();
					            },
					            error : function(request) {
					            	l.stop();
					            }
					        });
    					}else{
    						swal({
				    			title: "",
								text: myLabel.prices_invalid_input,
								type: "warning",
								confirmButtonColor: "#DD6B55",
								confirmButtonText: "OK",
								closeOnConfirm: false,
								showLoaderOnConfirm: false
							}, function () {
								swal.close();
							});
    					}
    					return false;
    				}
    			});
			});
			return false;
		}).on("click", ".pjBtnCancelUpdateExtra", function (e) {
			if(pjGrid.hasAccessCreate == true)
			{
				var $url = 'index.php?controller=pjAdminExtras&action=pjActionCreate';
				$.get($url).done(function (data) {
					$(".boxFormExtra").html(data);
					if (multilang && myLabel.isFlagReady == 1) {
			        	$('.pj-form-langbar-item').first().trigger('click');
					}
					
					$("#frmCreate").validate({
						onkeyup: false,
						submitHandler: function (form) {
							var l = Ladda.create( $(form).find(":submit").get(0) );
							l.start();
							
							$.ajaxSetup({async:false});
							var formData = new FormData(form);
							$.ajax({
					            url: "index.php?controller=pjAdminExtras&action=pjActionAddExtra",
					            type: 'post',
					            data: formData,
					            dataType: 'html',
					            async: true,
					            processData: false,
					            contentType: false,
					            success : function(data) {
					            	var content = $grid.datagrid("option", "content");
									$grid.datagrid("load", "index.php?controller=pjAdminExtras&action=pjActionGet", content.column, content.direction, content.page, content.rowCount);
									$(form)[0].reset();
									l.stop();
									if (multilang && myLabel.isFlagReady == 1) {
							        	$('.pj-form-langbar-item').first().trigger('click');
									}
					            },
					            error : function(request) {
					            	l.stop();
					            }
					        });
							return false;
						}
					});
				});
			}else{
				$(".boxFormExtra").html("");
			}
			return false;
		}).on("change", ".number", function (e) {
			var v = parseFloat(this.value);
		    if (isNaN(v)) {
		        this.value = '';
		    } else {
		        this.value = v.toFixed(2);
		    }
		    if (parseFloat(this.value) > 99999999999999.99) {
		    	this.value = '99999999999999.99';
		    }
		});
	});
})(jQuery);