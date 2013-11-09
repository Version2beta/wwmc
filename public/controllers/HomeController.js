var layoutSkills;

layoutSkills = function(skills) {
  var hScale, row, rowIndex, rows, skill, vScale, width, windowHeight, windowWidth, _i, _len, _results;
  windowWidth = $(window).width();
  windowHeight = $(window).height();
  hScale = windowWidth / (12 * 4);
  vScale = 36;
  rows = [
    {
      skills: []
    }
  ];
  _results = [];
  for (_i = 0, _len = skills.length; _i < _len; _i++) {
    skill = skills[_i];
    rowIndex = _.findIndex(rows, function(row) {
      var rowSkill, rowSkillEnd, rowSkillEndWithinSkill, rowSkillStartWithinSkill, skillEnd, skillEndWithinRowSkill, skillStartWithinRowSkill, _j, _len1, _ref;
      _ref = row.skills;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        rowSkill = _ref[_j];
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
    if (rowIndex === -1) {
      row = {
        skills: []
      };
      rows.push(row);
      rowIndex = rows.length - 1;
    } else {
      row = rows[rowIndex];
    }
    row.skills.push(skill);
    width = skill.developmentalAgeRange * hScale;
    _results.push(skill.layout = {
      width: width + 'px',
      left: ((skill.developmentalAge - 1) * hScale) + 'px',
      row: rowIndex,
      top: (rowIndex * vScale) + 'px'
    });
  }
  return _results;
};

window.HomeCtrl = function($scope, $http) {
  var reLayout;
  reLayout = function() {
    return layoutSkills($scope.skills);
  };
  $(window).on('resize', function() {
    return $scope.$apply(reLayout);
  });
  return $http.get('/skills').success(function(skills) {
    $scope.skills = skills;
    return reLayout();
  }).error(function(err) {
    return alert("Error loading skills: " + err);
  });
};
