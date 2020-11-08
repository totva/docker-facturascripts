<?php

// increase the maximum execution time
$cfg['ExecTimeLimit'] = 3000; // default = 300 s = 5 min, increased to 50 min.

// increase session timeout
$sessionDuration = 60*60*24*7; // 60*60*24*7 = one week, default was 1440
ini_set('session.gc_maxlifetime', $sessionDuration);
$cfg['LoginCookieValidity'] = $sessionDuration;