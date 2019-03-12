-- check for awesome 3.5 onwards
version_major = tonumber(string.sub(awesome.version, 2, 2))
version_minor = tonumber(string.sub(awesome.version, 4, 4))
is_awesome_35 = (version_major == 3 and version_minor >= 5)

awesome.font = "sans 13"

if not is_awesome_35 then 
    require("rc_2")

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
else
    require("rc_35")
end
