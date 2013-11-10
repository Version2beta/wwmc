var categoryColors, layoutSkills, layoutTimeline,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

categoryColors = ["#DFEF8F", "#8FEF95", "#EFBA8F", "#EF9A8F", "#EF8FB5"];

layoutSkills = function($scope, _arg) {
  var categories, category, hPadding, hScale, left, row, rowIndex, rows, skill, top, topPadding, vScale, width, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2;
  hScale = _arg.hScale, vScale = _arg.vScale, topPadding = _arg.topPadding, hPadding = _arg.hPadding;
  $scope.skillsHeight = 0;
  $scope.skillsWidth = 0;
  categories = [];
  _ref = $scope.skills;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    skill = _ref[_i];
    category = _.find(categories, function(category) {
      return category.name === skill.categories;
    });
    if (!category) {
      category = {
        name: skill.categories,
        rows: []
      };
      categories.push(category);
    }
    rows = category.rows;
    row = _.find(rows, function(row) {
      var rowSkill, rowSkillEnd, rowSkillEndWithinSkill, rowSkillStartWithinSkill, skillEnd, skillEndWithinRowSkill, skillStartWithinRowSkill, _j, _len1, _ref1;
      _ref1 = row.skills;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        rowSkill = _ref1[_j];
        skillEnd = skill.developmentalAge + skill.developmentalAgeRange;
        rowSkillEnd = rowSkill.developmentalAge + rowSkill.developmentalAgeRange;
        skillStartWithinRowSkill = skill.developmentalAge >= rowSkill.developmentalAge && skill.developmentalAge < rowSkillEnd;
        skillEndWithinRowSkill = skillEnd > rowSkill.developmentalAge && skillEnd < rowSkillEnd;
        rowSkillStartWithinSkill = rowSkill.developmentalAge > skill.developmentalAge && rowSkill.developmentalAge < skillEnd;
        rowSkillEndWithinSkill = rowSkillEnd > skill.developmentalAge && rowSkillEnd < skillEnd;
        if (skillStartWithinRowSkill || skillEndWithinRowSkill || rowSkillStartWithinSkill || rowSkillEndWithinSkill) {
          return false;
        }
      }
      return true;
    });
    if (!row) {
      row = {
        skills: []
      };
      rows.push(row);
    }
    row.skills.push(skill);
  }
  rowIndex = 0;
  for (_j = 0, _len1 = categories.length; _j < _len1; _j++) {
    category = categories[_j];
    _ref1 = category.rows;
    for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
      row = _ref1[_k];
      _ref2 = row.skills;
      for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
        skill = _ref2[_l];
        width = skill.developmentalAgeRange * hScale;
        top = rowIndex * vScale + topPadding;
        left = skill.developmentalAge * hScale + hPadding;
        skill.layout = {
          width: width + 'px',
          height: vScale + 'px',
          left: left + 'px',
          row: rowIndex,
          top: top + 'px'
        };
        $scope.skillsHeight = Math.max(top + vScale - topPadding, $scope.skillsHeight);
        $scope.skillsWidth = Math.max(left + width + hPadding, $scope.skillsWidth);
      }
      rowIndex++;
    }
  }
  return $scope.categories = categories.map(function(category, i) {
    return {
      name: category.name,
      height: category.rows.length * vScale,
      backgroundColor: categoryColors[i]
    };
  });
};

layoutTimeline = function($scope, _arg) {
  var hPadding, hScale, maxMonth, month, topPadding, vScale;
  hScale = _arg.hScale, vScale = _arg.vScale, maxMonth = _arg.maxMonth, topPadding = _arg.topPadding, hPadding = _arg.hPadding;
  return $scope.timelineNotches = (function() {
    var _i, _results;
    _results = [];
    for (month = _i = 0; _i <= maxMonth; month = _i += 3) {
      _results.push({
        month: month,
        left: (hScale * month + hPadding) + 'px'
      });
    }
    return _results;
  })();
};

window.HomeCtrl = function($scope, $http) {
  var debounce, reLayout;
  $http.get('/skills').success(function(skills) {
    $scope.skills = skills;
    return reLayout();
  });
  reLayout = function() {
    var hPadding, hScale, maxMonth, maxSkill, maxYear, topPadding, vScale, windowWidth, _i, _results;
    windowWidth = $(window).width();
    hScale = windowWidth / (12 * 4);
    vScale = 36;
    topPadding = 40;
    hPadding = 30;
    $scope.vScale = vScale;
    $scope.hScale = hScale;
    layoutSkills($scope, {
      hScale: hScale,
      vScale: vScale,
      topPadding: topPadding,
      hPadding: hPadding
    });
    maxSkill = _.max($scope.skills, function(skill) {
      return skill.developmentalAge + skill.developmentalAgeRange;
    });
    maxMonth = maxSkill.developmentalAge + maxSkill.developmentalAgeRange;
    maxYear = Math.floor(maxMonth / 12);
    $scope.years = (function() {
      _results = [];
      for (var _i = 0; 0 <= maxYear ? _i <= maxYear : _i >= maxYear; 0 <= maxYear ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this).map(function(year) {
      return {
        year: year,
        left: (hScale * 12 * year + hPadding) + 'px'
      };
    });
    return layoutTimeline($scope, {
      hScale: hScale,
      vScale: vScale,
      topPadding: topPadding,
      hPadding: hPadding,
      maxMonth: maxMonth
    });
  };
  $(window).on('resize', function() {
    return $scope.$apply(reLayout);
  });
  $scope.logs = [];
  $scope.log = function(what) {
    if (!isDebug()) {
      return;
    }
    console.log(what);
    $scope.logs.push(what);
    return $scope.notice = $scope.logs.slice(-10).reverse();
  };
  $scope.debounce = null;
  debounce = function() {
    $scope.debounce = true;
    return setTimeout((function() {
      return $scope.debounce = null;
    }), 500);
  };
  $scope.open = function(ev, skill) {
    if ($scope.debounce) {
      return;
    }
    $scope.log("open");
    return skill.state = "detail";
  };
  $scope.close = function(ev, skill) {
    $scope.log("close");
    debounce();
    return skill.state = "active";
  };
  $scope.showDependenciesOrOpen = function(ev, skill) {
    $scope.log("showDependenciesOrOpen " + skill.state);
    if (skill.state === "detail") {
      return;
    }
    if (skill.state === "active") {
      return $scope.open(ev, skill);
    } else {
      debounce();
      $scope.clear(ev, skill);
      return $scope.showDependencies(ev, skill);
    }
  };
  $scope.showDependencies = function(ev, skill) {
    var s, _i, _len, _ref, _ref1, _results;
    $scope.log("showDependencies");
    skill.state = "active";
    _ref = $scope.skills;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      s = _ref[_i];
      if (_ref1 = s._id, __indexOf.call(skill.dependencies || [], _ref1) >= 0) {
        s.state = "dependency";
        _results.push($scope.showDependencies(ev, s));
      } else {
        if (!s.state === "active") {
          _results.push(s.state = "hide-dependency");
        } else {
          _results.push(void 0);
        }
      }
    }
    return _results;
  };
  return $scope.clear = function(ev, skill) {
    var s, _i, _len, _ref, _results;
    $scope.log("clear");
    if (!(skill != null ? skill.state : void 0)) {
      _ref = $scope.skills;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        _results.push(s.state = null);
      }
      return _results;
    }
  };
};
