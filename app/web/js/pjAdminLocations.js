var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		var $frmCreate = $("#frmCreate"),
			$frmUpdate = $("#frmUpdate"),
			validate = ($.fn.validate !== undefined),
			multilang = ($.fn.multilang !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			$datepick = $(".datepick"),
			datepicker = ($.fn.datepicker !== undefined);
		
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
		
		if ($(".select-item").length) {
            $(".select-item").select2({
                placeholder: myLabel.choose ,
                allowClear: true
            });
        };
        
        if($(".touchspin3").length > 0)
		{
			$(".touchspin3").TouchSpin({
				min: 0,
				max: 4294967295,
				step: 1,
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white'
	        });
		}
        
		if ($frmCreate.length > 0 && validate) {
			$frmCreate.validate({
				errorPlacement: function (error, element) {
					var name = element.attr('name');
					error.insertAfter(element.parent());
				},
				onkeyup: false
			});
			$('[data-toggle="tooltip"]').tooltip(); 
		}
		
		if ($frmUpdate.length > 0 && validate) {
			$frmUpdate.validate({
				errorPlacement: function (error, element) {
					var name = element.attr('name');
					error.insertAfter(element.parent());
				},
				onkeyup: false
			});
			$('[data-toggle="tooltip"]').tooltip(); 
		}
				
		if ($("#grid").length > 0 && datagrid) {
			function formatCount(val, obj) {
				
				return ['<a href="index.php?controller=pjAdminLocations&action=pjActionIndex&type_id=', obj.id ,'">'+ val + '</a>'].join(""); 
			}
			
			var editable = false;
			var buttons = [];
			if (myLabel.has_wt) {
				buttons.push({type: "clock-o", url: "index.php?controller=pjAdminTime&action=pjActionIndex&foreign_id={:id}&tab=1"});
			}
			if (myLabel.has_update) {
				editable = true;
				buttons.push({type: "edit", url: "index.php?controller=pjAdminLocations&action=pjActionUpdate&id={:id}"});
			}
			if (myLabel.has_delete) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminLocations&action=pjActionDelete&id={:id}"});
			}
			var actions = [];
			if (myLabel.has_delete_bulk) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminLocations&action=pjActionDeleteBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			
			var select = false;
			if (actions.length) {
				select = {
					field: "id",
					name: "record[]"
				};
			}
			
			function formatImage(val, obj) {
				var src = val ? val : 'app/web/img/backend/no_img.png';
				return ['<a href="index.php?controller=pjAdminLocations&action=pjActionUpdate&id=', obj.id ,'"><img src="', src, '" style="width: 100px" /></a>'].join("");
			}
			
			var $grid = $("#grid").datagrid({
				buttons: buttons,
				columns: [{text: myLabel.location_image, type: "text", sortable: false, editable: false, renderer: formatImage},
				          {text: myLabel.location_name, type: "text", sortable: true, editable: editable},
						  {text: myLabel.location_address, type: "text", sortable: true, editable: false},
						  {text: myLabel.location_availability, type: "text", sortable: true, editable: false},
				          {text: myLabel.status, type: "toggle", sortable: true, editable: editable, positiveLabel: myLabel.active, positiveValue: "T", negativeLabel: myLabel.inactive, negativeValue: "F"}],
				dataUrl: "index.php?controller=pjAdminLocations&action=pjActionGet",
				dataType: "json",
				fields: ['thumb', 'name', 'address_1', 'cnt', 'status'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminLocations&action=pjActionSave&id={:id}",
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
			$grid.datagrid("load", "index.php?controller=pjAdminLocations&action=pjActionGet", "name", "ASC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminLocations&action=pjActionGet", "name", "ASC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminLocations&action=pjActionGet", "name", "ASC", content.page, content.rowCount);
			return false;
		}).on("click", ".pj-delete-image", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			
			var id = $(this).attr('rev');
			var $this = $(this);
			swal({
				title: myLabel.alert_title,
				text: myLabel.alert_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_delete,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post($this.attr("href"), {id: id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$('.pj-location-image').remove();
						break;
					}
				});
			});
		}).on("click", ".btnGoogleMapsApi", function (e) {
			var $this = $(this);
			$.post("index.php?controller=pjAdminLocations&action=pjActionGetGeocode", $(this).closest("form").serialize()).done(function (data) {
				if (data.code !== undefined && data.code == 200) {
					$("#lat").val(data.lat);
					$("#lng").val(data.lng);
					$this.siblings("span").hide().html("");
					initGMap(parseFloat(data.lat), parseFloat(data.lng));
				} else {
					$this.siblings("span").html("<br>" + myLabel.address_not_found).show();
				}
			});
		});

		function initGMap(lat, lng)
		{
			if (lat != '' && lng != '') {
				var latlng = new google.maps.LatLng(lat, lng);
				var mapOptions = {
						  center: latlng,
						  zoom: 12,
						  mapTypeId: google.maps.MapTypeId.ROADMAP
						};
				var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
				var marker = new google.maps.Marker({
									draggable: true,
									position: latlng,
									map: map
								});
				google.maps.event.addListener(marker, 'dragend', function (event) {
				    $('#lat').val(this.getPosition().lat());
				    $('#lng').val(this.getPosition().lng());
				});
			} else {
				var mapOptions = {
						center: new google.maps.LatLng(0, 0),
						zoom: 1,
						mapTypeId: google.maps.MapTypeId.ROADMAP
					};
				var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
			}
		}
		
		$(document).ready(function() {
			if($('#frmCreate').length > 0 || $('#frmUpdate').length > 0)
			{
				var $form = $('#frmCreate'),
					$lat = $('#lat').val(),
			    	$lng = $('#lng').val();
				if ($('#frmUpdate').length > 0) {
					$form = $('#frmUpdate');
				}
				initGMap($lat, $lng);
				
				var input = document.getElementById('address_content');         
			    var autocomplete = new google.maps.places.Autocomplete(input, {
			        types: ["geocode"]
			    });
			    $form.on("keypress", function(e) {
					var code = e.keyCode || e.which; 
					if (code  == 13) {
						var $focused = $(':focus');
						if($focused.attr('name') == 'address_content' )
						{
							e.preventDefault();
							return false;
						}
					}
				});
			    google.maps.event.addListener(autocomplete, 'place_changed', function() {
			        fillInAddress();
			    });	
			    function fillInAddress() 
			    {
			    	var place = autocomplete.getPlace();
			    	for (var i = 0; i < place.address_components.length; i++) 
			    	{
			    		var addressType = place.address_components[i].types[0];
			    	    if(addressType == 'locality' || addressType == 'administrative_area_level_1')
				    	{    
		    	    		$('#city').val(place.address_components[i]['long_name']);
		    	    	}
			    	    if(addressType == 'administrative_area_level_2')
		    	    	{
		    	    		$('#state').val(place.address_components[i]['short_name']);
		    	    	}
				    	if(addressType == 'postal_code')
				    	{    
		    	    		$('#zip').val(place.address_components[i]['short_name']);
		    	    	}
				    	if(addressType == 'country')
						{    
							var country = place.address_components[i]['short_name']; 
							$.post("index.php?controller=pjAdminLocations&action=pjActionGetCountry", {country: country}).done(function (data) {
								if (data.status == 'OK') {
									$("#country_id").val(data.id).trigger('change');
								}
							});
				    	}
			    	}
			    	$('#lat').val(place.geometry.location.lat());
			    	$('#lng').val(place.geometry.location.lng());
			    	initGMap(parseFloat(place.geometry.location.lat()), parseFloat(place.geometry.location.lng()));
			    }
			}
		});
		
	});
})(jQuery_1_8_2);