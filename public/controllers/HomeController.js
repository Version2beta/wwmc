var hScale, layoutSkills, vScale;

vScale = 46;

hScale = 10;

layoutSkills = function(skills) {
  var row, rowIndex, rows, skill, width, _i, _len;
  rows = [
    {
      skills: []
    }
  ];
  for (_i = 0, _len = skills.length; _i < _len; _i++) {
    skill = skills[_i];
    rowIndex = _.findIndex(rows, function(row) {
      var rowSkill, rowSkillEnd, rowSkillEndWithinSkill, rowSkillStartWithinSkill, skillEnd, skillEndWithinRowSkill, skillStartWithinRowSkill, _j, _len1, _ref;
      _ref = row.skills;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        rowSkill = _ref[_j];
        skillEnd = skill.developmentalAge + skill.developmentalAgeRange;
        rowSkillEnd = rowSkill.developmentalAge + rowSkill.developmentalAgeRange;
        skillStartWithinRowSkill = skill.developmentalAge >= rowSkill.developmentalAge && skill.developmentalAge <= rowSkillEnd;
        skillEndWithinRowSkill = skillEnd >= rowSkill.developmentalAge && skillEnd <= rowSkillEnd;
        rowSkillStartWithinSkill = rowSkill.developmentalAge >= skill.developmentalAge && rowSkill.developmentalAge <= skillEnd;
        rowSkillEndWithinSkill = rowSkillEnd >= skill.developmentalAge && rowSkillEnd <= skillEnd;
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
    skill.layout = {
      width: width + 'px',
      left: (skill.developmentalAge * hScale) + 'px',
      row: rowIndex,
      top: (rowIndex * vScale) + 'px'
    };
  }
  return skills;
};

window.HomeCtrl = function($scope) {
  var i, skills;
  skills = (function() {
    var _i, _results;
    _results = [];
    for (i = _i = 0; _i <= 100; i = ++_i) {
      _results.push({
        _id: "23",
        title: "Eye hand movement",
        description: "Eye–hand movements better coordinated; can put objects together, take them apart; fit large pegs into pegboard.",
        developmentalAge: Math.floor(Math.random() * 128),
        developmentalAgeRange: Math.floor(Math.random() * 20) + 6,
        dependencies: [],
        categories: ["cognitive"]
      });
    }
    return _results;
  })();
  return $scope.skills = layoutSkills(skills);
};
