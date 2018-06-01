private["_number","_remainder","_alphaArray"];

_number = round((_this select 0) min 255);

_alphaArray = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];

_remainder = _number % 16;

(_alphaArray select ((_number - _remainder) / 16)) + (_alphaArray select _remainder)