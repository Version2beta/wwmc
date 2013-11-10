var categoryColors, layoutSkills, layoutTimeline;

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

window.HomeCtrl = function($scope, skills) {
  var drawDependencies, highlightedDependencies, reLayout, skillsById;
  $scope.skills = skills;
  skillsById = _.indexBy(skills, 'id');
  highlightedDependencies = [];
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
  reLayout();
  $(window).on('resize', function() {
    return $scope.$apply(reLayout);
  });
  $scope.open = function(skill) {
    var s, _i, _len, _ref;
    if (skill.detail !== "detail") {
      $scope.showDependencies(skill);
      _ref = $scope.skills;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        s.detail = null;
      }
      skill.detail = "detail";
    }
    return false;
  };
  $scope.close = function(skill) {
    console.log(skill);
    skill.detail = null;
    return $scope.hideDependencies(skill);
  };
  $scope.showDependenciesOrOpen = function(skill) {
    if (skill.active) {
      return $scope.open(skill);
    } else {
      $scope.hideDependencies(skill);
      return $scope.showDependencies(skill);
    }
  };
  drawDependencies = function(skill, depth) {
    var dependencies, dependency, _i, _len;
    if (depth == null) {
      depth = 0;
    }
    if (depth > 10) {
      return;
    }
    dependencies = (skill.dependencies || []).map(function(id) {
      return skillsById[id];
    });
    for (_i = 0, _len = dependencies.length; _i < _len; _i++) {
      dependency = dependencies[_i];
      dependency.dependency = "dependency";
      dependencies = dependencies.concat(drawDependencies(dependency, depth));
    }
    return dependencies;
  };
  $scope.showDependencies = function(skill) {
    skill.active = "active";
    highlightedDependencies = drawDependencies(skill);
    highlightedDependencies.push(skill);
    return $scope.showHideDependencies = "hide-dependencies";
  };
  return $scope.hideDependencies = function() {
    var dep, _results;
    $scope.showHideDependencies = "";
    _results = [];
    while (dep = highlightedDependencies.pop()) {
      dep.active = null;
      dep.detail = null;
      _results.push(dep.dependency = null);
    }
    return _results;
  };
};
