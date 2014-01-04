DayPilotBubble = {};
DayPilotBubble.mouseMove = function (ev) {
    if (typeof (DayPilotBubble) === 'undefined')return;
    DayPilotBubble.mouse = DayPilotBubble.mousePosition(ev);
};
DayPilotBubble.mousePosition = function (e) {
    var $a = 0;
    var $b = 0;
    if (!e)var e = window.event;
    if (e.pageX || e.pageY) {
        $a = e.pageX;
        $b = e.pageY;
    }
    else if (e.clientX || e.clientY) {
        $a = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
        $b = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
    };
    var $c = {
    };
    $c.x = $a;
    $c.y = $b;
    $c.clientY = e.clientY;
    $c.clientX = e.clientX;
    return $c;
};
DayPilotBubble.Bubble = function (id) {
    var $d = this;
    var $e = false;
    if (navigator && navigator.userAgent && navigator.userAgent.indexOf("MSIE") !=- 1) {
        if (document.compatMode && document.compatMode == "BackCompat") {
            $e = true;
        }
    };
    this.callBack = function ($f) {
        WebForm_DoCallback(this.uniqueID, $f, this.updateView, this, this.callbackError, true);
    };
    this.callbackError = function ($c, $g) {
        alert($c);
    };
    this.updateView = function ($c, $g) {
        DayPilotBubble.active = $g;
        if ($g) {
            if ($g.object) {
                $g.object.innerHTML = $c;
            };
            $g.adjustPosition();
            $g.addShadow();
        }
    };
    this.init = function () {
        DayPilot.re(document.body, 'mousemove', DayPilotBubble.mouseMove);
    };
    this.showEvent = function ($h, $i) {
        var a = [];
        a.push($h);
        a.push($i);
        this.showOnMouseOver("EVE:" + DayPilot.ea(a));
    };
    this.showCell = function ($h, $j, $k, end) {
        var a = [];
        a.push($h);
        a.push($j);
        a.push($k);
        a.push(end);
        this.showOnMouseOver("CEL:" + DayPilot.ea(a));
    };
    this.showTime = function ($h, $k, end) {
        var a = [];
        a.push($h);
        a.push($k);
        a.push(end);
        this.showOnMouseOver("TIM:" + DayPilot.ea(a));
    };
    this.showResource = function ($h, $j) {
        var a = [];
        a.push($h);
        a.push($j);
        this.showOnMouseOver("RES:" + DayPilot.ea(a));
    };
    this.show = function ($l) {
        if (DayPilotBubble.active == this && this.callbackArgument == $l) {
            return;
        };
        if (typeof (DayPilotMenu) != 'undefined' && DayPilotMenu.menu) {
            return;
        };
        DayPilotBubble.hideActive();
        DayPilotBubble.active = this;
        this.callbackArgument = $l;
        this.object = document.createElement("div");
        if (!this.showLoadingLabel) {
            this.object.style.display = 'none';
        };
        document.body.appendChild(this.object);
        if (this.border) {
            this.object.style.border = this.border;
        };
        if (this.width) {
            this.object.style.width = this.width;
        };
        this.object.style.backgroundColor = this.backgroundColor;
        this.object.style.position = 'absolute';
        this.object.style.padding = '4px';
        this.object.style.cursor = 'default';
        this.object.style.top = '0px';
        this.object.style.left = '0px';
        this.object.style.zIndex = 11;
        this.object.onclick = function () {
            DayPilotBubble.hideActive();
        };
        this.object.onmouseover = function () {
            DayPilotBubble.cancelTimeout();
        };
        this.object.onmouseout = this.delayedHide;
        this.object.innerHTML = this.loadingText;
        this.mouse = DayPilotBubble.mouse;
        if (this.showLoadingLabel) {
            this.adjustPosition();
            this.addShadow();
        };
        this.callBack($l);
    };
    this.adjustPosition = function () {
        var $m = 22;
        var $n = 10;
        var $o = 10;
        if (!this.object) {
            return;
        };
        this.object.style.display = '';
        var $p = this.object.clientHeight;
        var $q = this.object.clientWidth;
        this.object.style.display = 'none';
        var $r = document.documentElement.clientHeight;
        if ($e) {
            $r = document.body.clientHeight;
        };
        if (this.mouse.clientY > $r - $p + $o) {
            var $s = this.mouse.clientY - ($r - $p) + $o;
            this.object.style.top = (this.mouse.y - $p - $n) + 'px';
        }
        else {
            this.object.style.top = this.mouse.y + $m + 'px';
        };
        var $t = document.documentElement.clientWidth;
        if ($e) {
            $t = document.body.clientWidth;
        };
        if (this.mouse.clientX > $t - $q + $o) {
            var $u = this.mouse.clientX - ($t - $q) + $o;
            this.object.style.left = (this.mouse.x - $u) + 'px';
        }
        else {
            this.object.style.left = this.mouse.x + 'px';
        };
        this.object.style.display = '';
    };
    this.delayedHide = function () {
        DayPilotBubble.cancelTimeout();
        if ($d.hideAfter > 0) {
            DayPilotBubble.timeout = window.setTimeout("DayPilotBubble.hideActive()", $d.hideAfter);
        }
    };
    this.showOnMouseOver = function ($l) {
        DayPilotBubble.cancelTimeout();
        DayPilotBubble.timeout = window.setTimeout(this.clientObjectName + ".show('" + $l + "')", this.showAfter);
    };
    this.hideOnMouseOut = function () {
        this.delayedHide();
    };
    this.addShadow = function () {
        if (!this.useShadow) {
            return;
        };
        if (!this.object) {
            return;
        };
        if (this.shadows && this.shadows.length > 0) {
            this.removeShadow();
        };
        this.shadows = [];
        for (var i = 0; i < 5; i++) {
            var $v = document.createElement('div');
            $v.style.position = 'absolute';
            $v.style.width = this.object.offsetWidth + 'px';
            $v.style.height = this.object.offsetHeight + 'px';
            $v.style.top = this.object.offsetTop + i + 'px';
            $v.style.left = this.object.offsetLeft + i + 'px';
            $v.style.zIndex = 10;
            $v.style.filter = 'alpha(opacity:10)';
            $v.style.opacity = 0.1;
            $v.style.backgroundColor = '#000000';
            document.body.appendChild($v);
            this.shadows.push($v);
        }
    };
    this.removeShadow = function () {
        if (!this.shadows) {
            return;
        };
        for (var i = 0; i < this.shadows.length; i++) {
            document.body.removeChild(this.shadows[i]);
        };
        this.shadows = [];
    };
    this.removeDiv = function () {
        if (!this.object) {
            return;
        };
        document.body.removeChild(this.object);
        this.object = null;
    };
    this.init();
};
DayPilotBubble.cancelTimeout = function () {
    if (DayPilotBubble.timeout) {
        window.clearTimeout(DayPilotBubble.timeout);
    }
};
DayPilotBubble.hideActive = function () {
    DayPilotBubble.cancelTimeout();
    var $d = DayPilotBubble.active;
    if ($d) {
        $d.removeDiv();
        $d.removeShadow();
    };
    DayPilotBubble.active = null;
};
