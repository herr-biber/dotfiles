-- check for awesome 3.5 onwards
version_major = tonumber(string.sub(awesome.version, 2, 2))
version_minor = tonumber(string.sub(awesome.version, 4, 4))

awesome.font = "sans 13"

if version_major >= 4
    require("rc_4")
elseif (version_major == 3 and version_minor >= 5):
    require("rc_35")
else
    require("rc_2")
end
