
var main = (function () {
"use strict";

	// initalize the application
	function init()
	{
		var lnks = $('#categories li');

		var curr;
		for (var l=0; l < lnks.length; l++)
		{
			curr = lnks[l];
			$(curr).click(_linkClickedHandler)
		}
	}

	function _linkClickedHandler(evt)
	{
		var el = evt.target;
		if (el.nodeName == 'INPUT')
		{
			var checkbox = el;
			var item = $(checkbox).parent().parent(); // parent li item
			if (item.hasClass('depth0'))
			{
				var lnks = $('li.depth1',item);
				var curr;
				for (var l=0; l < lnks.length; l++)
				{
					curr = lnks[l];
					if (checkbox.checked)
					{
						$(curr).removeClass('hide');
					}
					else
					{
						$(curr).addClass('hide');
						$('input',$(curr)).prop('checked', false);
						var lnks2 = $('li.depth2',$(curr));
						var curr2;
						for (var l2=0; l2 < lnks2.length; l2++)
						{
							curr2 = lnks2[l2];
							$(curr2).addClass('hide');
							$('input',$(curr2)).prop('checked', false);
						}
					}
				}
			}
			else if (item.hasClass('depth1'))
			{
				var lnks = $('li.depth2',item);
				var curr;
				for (var l=0; l < lnks.length; l++)
				{
					curr = lnks[l];
					if (checkbox.checked)
					{
						$(curr).removeClass('hide');
					}
					else
					{
						$(curr).addClass('hide');
						$('input',$(curr)).prop('checked', false);
						var lnks3 = $('li.depth3',$(curr));
						var curr3;
						for (var l3=0; l3 < lnks3.length; l3++)
						{
							curr3 = lnks3[l3];
							$(curr3).addClass('hide');
							$('input',$(curr3)).prop('checked', false);
						}
					}
				}
			}
			else if (item.hasClass('depth2'))
			{
				var lnks = $('li.depth3',item);
				var curr;
				for (var l=0; l < lnks.length; l++)
				{
					curr = lnks[l];
					if (checkbox.checked)
					{
						$(curr).removeClass('hide');
					}
					else
					{
						$(curr).addClass('hide');
					}
				}
			}
		}

	}

	// return internally scoped var as value of globally scoped object
	return {
		init:init
	};

})();

$(document).ready(function(){
	main.init();
});