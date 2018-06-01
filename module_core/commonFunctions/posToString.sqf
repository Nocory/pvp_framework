_pos = _this;

_numberToString = {
	_arr = toArray str(_this % 1);
	_arr set[0,"x"];
	_arr = _arr - ["x"];
	str(_this - (_this % 1)) + toString _arr
};

format["[%1,%2,%3]",
	(_pos select 0) call _numberToString,
	(_pos select 1) call _numberToString,
	(_pos select 2) call _numberToString
];